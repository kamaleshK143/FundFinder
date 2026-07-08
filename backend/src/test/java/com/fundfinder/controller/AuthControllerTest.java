package com.fundfinder.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fundfinder.dto.auth.AuthResponse;
import com.fundfinder.dto.auth.RegisterRequest;
import com.fundfinder.exception.DuplicateEmailException;
import com.fundfinder.exception.GlobalExceptionHandler;
import com.fundfinder.security.CustomUserDetailsService;
import com.fundfinder.security.JwtService;
import com.fundfinder.service.AuthService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Security filters are disabled here (addFilters = false) so this slice
 * focuses purely on request mapping, validation, and status codes - the
 * authorization rules themselves are covered separately in
 * SecurityIntegrationTest, which boots the real filter chain.
 */
@WebMvcTest(controllers = AuthController.class)
@AutoConfigureMockMvc(addFilters = false)
@org.springframework.context.annotation.Import(GlobalExceptionHandler.class)
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private AuthService authService;

    // JwtAuthenticationFilter is a Filter bean, so @WebMvcTest constructs it even
    // with addFilters = false - these satisfy its constructor dependencies.
    @MockitoBean
    private JwtService jwtService;
    @MockitoBean
    private CustomUserDetailsService customUserDetailsService;

    @Test
    void registerReturns201WithTokensOnSuccess() throws Exception {
        when(authService.register(any())).thenReturn(
                AuthResponse.of("access-token", "refresh-token", 900));

        RegisterRequest request = new RegisterRequest("Test Student", "student@example.com", "password123");

        mockMvc.perform(post("/api/auth/register")
                        .contentType("application/json")
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.accessToken").value("access-token"))
                .andExpect(jsonPath("$.tokenType").value("Bearer"));
    }

    @Test
    void registerReturns400OnInvalidEmail() throws Exception {
        RegisterRequest request = new RegisterRequest("Test Student", "not-an-email", "password123");

        mockMvc.perform(post("/api/auth/register")
                        .contentType("application/json")
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Validation failed"));
    }

    @Test
    void registerReturns400OnShortPassword() throws Exception {
        RegisterRequest request = new RegisterRequest("Test Student", "student@example.com", "short");

        mockMvc.perform(post("/api/auth/register")
                        .contentType("application/json")
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void registerReturns409OnDuplicateEmail() throws Exception {
        when(authService.register(any())).thenThrow(new DuplicateEmailException("student@example.com"));

        RegisterRequest request = new RegisterRequest("Test Student", "student@example.com", "password123");

        mockMvc.perform(post("/api/auth/register")
                        .contentType("application/json")
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict());
    }

    @Test
    void loginReturns401OnInvalidCredentials() throws Exception {
        when(authService.login(any())).thenThrow(new com.fundfinder.exception.InvalidCredentialsException());

        mockMvc.perform(post("/api/auth/login")
                        .contentType("application/json")
                        .content("{\"email\":\"student@example.com\",\"password\":\"wrong\"}"))
                .andExpect(status().isUnauthorized());
    }
}

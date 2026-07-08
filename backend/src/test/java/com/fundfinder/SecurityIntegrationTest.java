package com.fundfinder;

import com.fundfinder.repository.RefreshTokenRepository;
import com.fundfinder.repository.UserRepository;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Boots the real Spring Security filter chain (unlike the @WebMvcTest slices,
 * which disable it to focus on controller logic) to prove the actual
 * authorization rules in SecurityConfig hold - including that GET
 * /api/auth/me requires a token despite living under /api/auth/**, which is
 * mostly permitAll (register/login/refresh/logout). Requires a local MySQL
 * matching application.yml, same as running the app itself.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
class SecurityIntegrationTest {

    // Unique per JVM run so re-running the suite never collides with a
    // previous run's leftover row (e.g. if cleanup was interrupted).
    private static final String TEST_EMAIL = "security-integration-test-" + System.currentTimeMillis() + "@example.com";

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @AfterAll
    static void cleanUp(@Autowired UserRepository userRepository, @Autowired RefreshTokenRepository refreshTokenRepository) {
        userRepository.findByEmail(TEST_EMAIL).ifPresent(user -> {
            refreshTokenRepository.findAll().stream()
                    .filter(token -> token.getUser().getId().equals(user.getId()))
                    .forEach(refreshTokenRepository::delete);
            userRepository.delete(user);
        });
    }

    @Test
    void profileEndpointRejectsRequestsWithNoToken() throws Exception {
        mockMvc.perform(get("/api/profile"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void meEndpointRejectsRequestsWithNoTokenDespiteLivingUnderAuthPrefix() throws Exception {
        mockMvc.perform(get("/api/auth/me"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void scholarshipListIsPubliclyReadableWithNoToken() throws Exception {
        mockMvc.perform(get("/api/scholarships"))
                .andExpect(status().isOk());
    }

    @Test
    void scholarshipWriteEndpointRejectsRequestsWithNoToken() throws Exception {
        mockMvc.perform(post("/api/scholarships").contentType("application/json").content("{}"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void meEndpointSucceedsWithAValidTokenFromRealRegistration() throws Exception {
        String registerBody = """
                {"fullName":"Security Test","email":"%s","password":"password123"}
                """.formatted(TEST_EMAIL);

        String response = mockMvc.perform(post("/api/auth/register")
                        .contentType("application/json")
                        .content(registerBody))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        String accessToken = response.split("\"accessToken\":\"")[1].split("\"")[0];

        mockMvc.perform(get("/api/auth/me").header("Authorization", "Bearer " + accessToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value(TEST_EMAIL));
    }
}

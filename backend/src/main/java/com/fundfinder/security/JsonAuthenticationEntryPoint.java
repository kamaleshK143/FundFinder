package com.fundfinder.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fundfinder.exception.ApiError;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Spring Security's default behaviour on 401 is an HTML error page, which a
 * Flutter client can't parse. This returns the same ApiError JSON shape used
 * everywhere else in the API.
 */
@Component
public class JsonAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final ObjectMapper objectMapper = new ObjectMapper().findAndRegisterModules();

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException)
            throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        ApiError error = ApiError.of(401, "Unauthorized", "Authentication is required to access this resource");
        response.getWriter().write(objectMapper.writeValueAsString(error));
    }
}

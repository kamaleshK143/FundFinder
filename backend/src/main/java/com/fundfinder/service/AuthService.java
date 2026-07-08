package com.fundfinder.service;

import com.fundfinder.dto.auth.AuthResponse;
import com.fundfinder.dto.auth.LoginRequest;
import com.fundfinder.dto.auth.RegisterRequest;
import com.fundfinder.entity.RefreshToken;
import com.fundfinder.entity.User;
import com.fundfinder.enums.Role;
import com.fundfinder.exception.DuplicateEmailException;
import com.fundfinder.exception.InvalidCredentialsException;
import com.fundfinder.exception.InvalidRefreshTokenException;
import com.fundfinder.repository.RefreshTokenRepository;
import com.fundfinder.repository.UserRepository;
import com.fundfinder.security.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Value("${app.jwt.refresh-token-expiration-ms}")
    private long refreshTokenExpirationMs;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new DuplicateEmailException(request.email());
        }

        User user = User.builder()
                .fullName(request.fullName())
                .email(request.email())
                .passwordHash(passwordEncoder.encode(request.password()))
                .role(Role.STUDENT)
                .build();
        userRepository.save(user);

        return issueTokens(user);
    }

    public AuthResponse login(LoginRequest request) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.email(), request.password()));
        } catch (BadCredentialsException e) {
            throw new InvalidCredentialsException();
        }

        User user = userRepository.findByEmail(request.email())
                .orElseThrow(InvalidCredentialsException::new);

        return issueTokens(user);
    }

    @Transactional
    public AuthResponse refresh(String rawRefreshToken) {
        RefreshToken existing = refreshTokenRepository.findByToken(rawRefreshToken)
                .orElseThrow(() -> new InvalidRefreshTokenException("Refresh token not recognized"));

        if (existing.isRevoked() || existing.isExpired()) {
            throw new InvalidRefreshTokenException("Refresh token is expired or has been revoked");
        }

        existing.setRevoked(true);
        refreshTokenRepository.save(existing);

        return issueTokens(existing.getUser());
    }

    @Transactional
    public void logout(String rawRefreshToken) {
        refreshTokenRepository.findByToken(rawRefreshToken).ifPresent(token -> {
            token.setRevoked(true);
            refreshTokenRepository.save(token);
        });
    }

    private AuthResponse issueTokens(User user) {
        String accessToken = jwtService.generateAccessToken(user);

        RefreshToken refreshToken = RefreshToken.builder()
                .user(user)
                .token(UUID.randomUUID().toString())
                .expiryDate(LocalDateTime.now().plusNanos(refreshTokenExpirationMs * 1_000_000))
                .build();
        refreshTokenRepository.save(refreshToken);

        return AuthResponse.of(accessToken, refreshToken.getToken(), jwtService.getAccessTokenExpirationSeconds());
    }
}

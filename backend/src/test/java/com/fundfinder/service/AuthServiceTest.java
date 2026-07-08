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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private RefreshTokenRepository refreshTokenRepository;
    @Mock
    private PasswordEncoder passwordEncoder;
    @Mock
    private JwtService jwtService;
    @Mock
    private AuthenticationManager authenticationManager;

    @InjectMocks
    private AuthService authService;

    private User user;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(authService, "refreshTokenExpirationMs", 604800000L);
        user = User.builder()
                .id(1L)
                .fullName("Test Student")
                .email("student@example.com")
                .passwordHash("hashed")
                .role(Role.STUDENT)
                .build();
    }

    @Test
    void registerThrowsWhenEmailAlreadyExists() {
        when(userRepository.existsByEmail("student@example.com")).thenReturn(true);

        RegisterRequest request = new RegisterRequest("Test Student", "student@example.com", "password123");

        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(DuplicateEmailException.class);

        verify(userRepository, never()).save(any());
    }

    @Test
    void registerSavesUserAndIssuesTokens() {
        when(userRepository.existsByEmail("student@example.com")).thenReturn(false);
        when(passwordEncoder.encode("password123")).thenReturn("hashed");
        when(jwtService.generateAccessToken(any())).thenReturn("access-token");
        when(jwtService.getAccessTokenExpirationSeconds()).thenReturn(900L);

        RegisterRequest request = new RegisterRequest("Test Student", "student@example.com", "password123");

        AuthResponse response = authService.register(request);

        verify(userRepository).save(any(User.class));
        ArgumentCaptor<RefreshToken> tokenCaptor = ArgumentCaptor.forClass(RefreshToken.class);
        verify(refreshTokenRepository).save(tokenCaptor.capture());

        assertThat(response.accessToken()).isEqualTo("access-token");
        assertThat(response.refreshToken()).isEqualTo(tokenCaptor.getValue().getToken());
        assertThat(response.expiresIn()).isEqualTo(900L);
    }

    @Test
    void loginThrowsInvalidCredentialsOnBadPassword() {
        when(authenticationManager.authenticate(any())).thenThrow(new BadCredentialsException("bad"));

        LoginRequest request = new LoginRequest("student@example.com", "wrongpassword");

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(InvalidCredentialsException.class);
    }

    @Test
    void loginIssuesTokensOnSuccess() {
        when(userRepository.findByEmail("student@example.com")).thenReturn(Optional.of(user));
        when(jwtService.generateAccessToken(user)).thenReturn("access-token");
        when(jwtService.getAccessTokenExpirationSeconds()).thenReturn(900L);

        LoginRequest request = new LoginRequest("student@example.com", "password123");

        AuthResponse response = authService.login(request);

        verify(authenticationManager).authenticate(any());
        assertThat(response.accessToken()).isEqualTo("access-token");
    }

    @Test
    void refreshRejectsUnknownToken() {
        when(refreshTokenRepository.findByToken("unknown")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> authService.refresh("unknown"))
                .isInstanceOf(InvalidRefreshTokenException.class);
    }

    @Test
    void refreshRejectsRevokedToken() {
        RefreshToken revoked = RefreshToken.builder()
                .user(user)
                .token("revoked-token")
                .expiryDate(LocalDateTime.now().plusDays(1))
                .revoked(true)
                .build();
        when(refreshTokenRepository.findByToken("revoked-token")).thenReturn(Optional.of(revoked));

        assertThatThrownBy(() -> authService.refresh("revoked-token"))
                .isInstanceOf(InvalidRefreshTokenException.class);
    }

    @Test
    void refreshRejectsExpiredToken() {
        RefreshToken expired = RefreshToken.builder()
                .user(user)
                .token("expired-token")
                .expiryDate(LocalDateTime.now().minusDays(1))
                .revoked(false)
                .build();
        when(refreshTokenRepository.findByToken("expired-token")).thenReturn(Optional.of(expired));

        assertThatThrownBy(() -> authService.refresh("expired-token"))
                .isInstanceOf(InvalidRefreshTokenException.class);
    }

    @Test
    void refreshRotatesTokenAndRevokesTheOldOne() {
        RefreshToken existing = RefreshToken.builder()
                .user(user)
                .token("old-token")
                .expiryDate(LocalDateTime.now().plusDays(1))
                .revoked(false)
                .build();
        when(refreshTokenRepository.findByToken("old-token")).thenReturn(Optional.of(existing));
        when(jwtService.generateAccessToken(user)).thenReturn("new-access-token");
        when(jwtService.getAccessTokenExpirationSeconds()).thenReturn(900L);

        AuthResponse response = authService.refresh("old-token");

        assertThat(existing.isRevoked()).isTrue();
        assertThat(response.accessToken()).isEqualTo("new-access-token");
        assertThat(response.refreshToken()).isNotEqualTo("old-token");
    }

    @Test
    void logoutRevokesTheGivenToken() {
        RefreshToken existing = RefreshToken.builder()
                .user(user)
                .token("some-token")
                .expiryDate(LocalDateTime.now().plusDays(1))
                .revoked(false)
                .build();
        when(refreshTokenRepository.findByToken("some-token")).thenReturn(Optional.of(existing));

        authService.logout("some-token");

        assertThat(existing.isRevoked()).isTrue();
        verify(refreshTokenRepository).save(existing);
    }

    @Test
    void logoutIsANoOpForAnUnknownToken() {
        when(refreshTokenRepository.findByToken("unknown")).thenReturn(Optional.empty());

        authService.logout("unknown");

        verify(refreshTokenRepository, never()).save(any());
    }
}

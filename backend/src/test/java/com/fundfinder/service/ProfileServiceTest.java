package com.fundfinder.service;

import com.fundfinder.dto.profile.ProfileRequest;
import com.fundfinder.dto.profile.ProfileResponse;
import com.fundfinder.entity.Profile;
import com.fundfinder.entity.User;
import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import com.fundfinder.exception.ResourceNotFoundException;
import com.fundfinder.repository.ProfileRepository;
import com.fundfinder.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProfileServiceTest {

    @Mock
    private ProfileRepository profileRepository;
    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private ProfileService profileService;

    @Test
    void getByUserIdThrowsWhenNoProfileExists() {
        when(profileRepository.findByUserId(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> profileService.getByUserId(1L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getByUserIdReturnsExistingProfile() {
        Profile profile = Profile.builder()
                .id(1L)
                .educationLevel(EducationLevel.UNDERGRADUATE)
                .annualFamilyIncome(new BigDecimal("200000"))
                .category(Category.SC)
                .gender(Gender.FEMALE)
                .state("Kerala")
                .hasDisability(false)
                .build();
        when(profileRepository.findByUserId(1L)).thenReturn(Optional.of(profile));

        ProfileResponse response = profileService.getByUserId(1L);

        assertThat(response.state()).isEqualTo("Kerala");
        assertThat(response.category()).isEqualTo(Category.SC);
    }

    @Test
    void upsertCreatesANewProfileWhenNoneExists() {
        User user = User.builder().id(1L).build();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(profileRepository.findByUserId(1L)).thenReturn(Optional.empty());

        ProfileRequest request = new ProfileRequest(
                EducationLevel.CLASS_12, new BigDecimal("150000"), Category.OBC, Gender.MALE, "Karnataka", false);

        ProfileResponse response = profileService.upsert(1L, request);

        verify(profileRepository).save(any(Profile.class));
        assertThat(response.educationLevel()).isEqualTo(EducationLevel.CLASS_12);
        assertThat(response.state()).isEqualTo("Karnataka");
    }

    @Test
    void upsertUpdatesTheExistingProfileRatherThanCreatingASecondOne() {
        User user = User.builder().id(1L).build();
        Profile existing = Profile.builder()
                .id(5L)
                .user(user)
                .educationLevel(EducationLevel.CLASS_10)
                .annualFamilyIncome(new BigDecimal("100000"))
                .category(Category.GENERAL)
                .gender(Gender.MALE)
                .state("Bihar")
                .hasDisability(false)
                .build();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(profileRepository.findByUserId(1L)).thenReturn(Optional.of(existing));

        ProfileRequest request = new ProfileRequest(
                EducationLevel.UNDERGRADUATE, new BigDecimal("300000"), Category.EWS, Gender.OTHER, "Goa", true);

        ProfileResponse response = profileService.upsert(1L, request);

        assertThat(response.id()).isEqualTo(5L);
        assertThat(response.educationLevel()).isEqualTo(EducationLevel.UNDERGRADUATE);
        assertThat(response.state()).isEqualTo("Goa");
        assertThat(response.hasDisability()).isTrue();
    }

    @Test
    void upsertThrowsWhenUserDoesNotExist() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        ProfileRequest request = new ProfileRequest(
                EducationLevel.UNDERGRADUATE, new BigDecimal("150000"), Category.GENERAL, Gender.MALE, "Goa", false);

        assertThatThrownBy(() -> profileService.upsert(99L, request))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}

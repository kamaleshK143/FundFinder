package com.fundfinder.service;

import com.fundfinder.dto.profile.ProfileRequest;
import com.fundfinder.dto.profile.ProfileResponse;
import com.fundfinder.entity.Profile;
import com.fundfinder.entity.User;
import com.fundfinder.exception.ResourceNotFoundException;
import com.fundfinder.repository.ProfileRepository;
import com.fundfinder.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ProfileService {

    private final ProfileRepository profileRepository;
    private final UserRepository userRepository;

    public ProfileResponse getByUserId(Long userId) {
        Profile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("No profile found for this user yet"));
        return ProfileResponse.from(profile);
    }

    /**
     * One user has exactly one profile, so this both creates the first
     * profile and updates it on every later edit ("Tell us more" is
     * resubmittable, not a one-time form).
     */
    @Transactional
    public ProfileResponse upsert(Long userId, ProfileRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Profile profile = profileRepository.findByUserId(userId).orElseGet(() -> {
            Profile created = new Profile();
            created.setUser(user);
            return created;
        });

        profile.setEducationLevel(request.educationLevel());
        profile.setAnnualFamilyIncome(request.annualFamilyIncome());
        profile.setCategory(request.category());
        profile.setGender(request.gender());
        profile.setState(request.state());
        profile.setHasDisability(request.hasDisability());

        profileRepository.save(profile);
        return ProfileResponse.from(profile);
    }
}

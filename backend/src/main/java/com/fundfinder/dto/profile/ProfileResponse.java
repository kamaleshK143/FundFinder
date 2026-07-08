package com.fundfinder.dto.profile;

import com.fundfinder.entity.Profile;
import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;

import java.math.BigDecimal;

public record ProfileResponse(
        Long id,
        EducationLevel educationLevel,
        BigDecimal annualFamilyIncome,
        Category category,
        Gender gender,
        String state,
        boolean hasDisability
) {
    public static ProfileResponse from(Profile profile) {
        return new ProfileResponse(
                profile.getId(),
                profile.getEducationLevel(),
                profile.getAnnualFamilyIncome(),
                profile.getCategory(),
                profile.getGender(),
                profile.getState(),
                profile.isHasDisability()
        );
    }
}

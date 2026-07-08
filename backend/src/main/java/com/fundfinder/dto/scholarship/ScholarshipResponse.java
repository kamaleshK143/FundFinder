package com.fundfinder.dto.scholarship;

import com.fundfinder.entity.Scholarship;
import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Set;

public record ScholarshipResponse(
        Long id,
        String name,
        String providerName,
        String description,
        String rewardAmountText,
        String officialLink,
        LocalDate applicationDeadline,
        boolean isAlwaysOpen,
        EducationLevel minEducationLevel,
        EducationLevel maxEducationLevel,
        BigDecimal maxAnnualIncome,
        Gender requiredGender,
        boolean requiresDisability,
        boolean isActive,
        Set<Category> eligibleCategories,
        Set<String> eligibleStates
) {
    public static ScholarshipResponse from(Scholarship s) {
        return new ScholarshipResponse(
                s.getId(),
                s.getName(),
                s.getProviderName(),
                s.getDescription(),
                s.getRewardAmountText(),
                s.getOfficialLink(),
                s.getApplicationDeadline(),
                s.isAlwaysOpen(),
                s.getMinEducationLevel(),
                s.getMaxEducationLevel(),
                s.getMaxAnnualIncome(),
                s.getRequiredGender(),
                s.isRequiresDisability(),
                s.isActive(),
                s.getEligibleCategories(),
                s.getEligibleStates()
        );
    }
}

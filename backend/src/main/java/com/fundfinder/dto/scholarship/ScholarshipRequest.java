package com.fundfinder.dto.scholarship;

import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Set;

public record ScholarshipRequest(
        @NotBlank(message = "Name is required")
        String name,

        String providerName,
        String description,
        String rewardAmountText,
        String officialLink,
        LocalDate applicationDeadline,
        boolean isAlwaysOpen,

        @NotNull(message = "Minimum education level is required")
        EducationLevel minEducationLevel,

        @NotNull(message = "Maximum education level is required")
        EducationLevel maxEducationLevel,

        BigDecimal maxAnnualIncome,

        @NotNull(message = "Required gender is required (use ANY if open to everyone)")
        Gender requiredGender,

        boolean requiresDisability,
        boolean isActive,

        // Empty/omitted set means "open to everyone" for that criterion.
        Set<Category> eligibleCategories,
        Set<String> eligibleStates
) {
}

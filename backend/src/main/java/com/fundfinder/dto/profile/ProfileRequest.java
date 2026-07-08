package com.fundfinder.dto.profile;

import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

import java.math.BigDecimal;

public record ProfileRequest(
        @NotNull(message = "Education level is required")
        EducationLevel educationLevel,

        @NotNull(message = "Annual family income is required")
        @PositiveOrZero(message = "Annual family income cannot be negative")
        BigDecimal annualFamilyIncome,

        @NotNull(message = "Category is required")
        Category category,

        @NotNull(message = "Gender is required")
        Gender gender,

        @NotNull(message = "State is required")
        String state,

        boolean hasDisability
) {
}

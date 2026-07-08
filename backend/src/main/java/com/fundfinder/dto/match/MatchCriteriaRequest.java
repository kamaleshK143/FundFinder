package com.fundfinder.dto.match;

import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import com.fundfinder.matching.MatchCriteria;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

import java.math.BigDecimal;

/**
 * Request body for POST /api/match/preview - lets a caller ask "what would I
 * match if my situation were X?" without needing a saved Profile first. This
 * is what the guided chatbot flow (Phase 5) builds incrementally from its
 * Q&A answers, then submits in one shot at the end.
 */
public record MatchCriteriaRequest(
        @NotNull(message = "Education level is required")
        EducationLevel educationLevel,

        @NotNull(message = "Annual family income is required")
        @PositiveOrZero(message = "Annual family income cannot be negative")
        BigDecimal annualIncome,

        @NotNull(message = "Category is required")
        Category category,

        @NotNull(message = "Gender is required")
        Gender gender,

        @NotNull(message = "State is required")
        String state,

        boolean hasDisability
) {
    public MatchCriteria toMatchCriteria() {
        return MatchCriteria.builder()
                .educationLevel(educationLevel)
                .annualIncome(annualIncome)
                .category(category)
                .gender(gender)
                .state(state)
                .hasDisability(hasDisability)
                .build();
    }
}

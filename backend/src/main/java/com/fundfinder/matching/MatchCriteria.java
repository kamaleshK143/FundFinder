package com.fundfinder.matching;

import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;

/**
 * The shared input contract for eligibility matching. It is deliberately
 * decoupled from the Profile entity: it can be built from a student's saved
 * Profile (see ProfileMapper, used by GET /api/match) or directly from a
 * request body (POST /api/match/preview, used by the guided chatbot flow in
 * Phase 5). Either way, EligibilityDecisionEngine only ever sees this one
 * shape - that's what lets the dashboard and the chatbot share the exact
 * same matching logic.
 * <p>
 * Builder is used here (not Lombok's @Data/all-args constructor) because
 * there are two different call sites constructing this object with the same
 * six fields, and a plain constructor call would be an unreadable wall of
 * positional arguments.
 */
@Getter
@Builder
public class MatchCriteria {
    private final EducationLevel educationLevel;
    private final BigDecimal annualIncome;
    private final Category category;
    private final Gender gender;
    private final String state;
    private final boolean hasDisability;
}

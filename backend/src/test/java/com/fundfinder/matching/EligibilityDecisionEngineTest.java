package com.fundfinder.matching;

import com.fundfinder.entity.Scholarship;
import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import com.fundfinder.repository.ScholarshipRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

/**
 * One test class per decision node in EligibilityDecisionEngine, plus an
 * integration-style scenario at the bottom that mirrors a real seeded
 * dataset. ScholarshipRepository is mocked so each test controls exactly
 * which scholarships the engine sees - no database needed for this class.
 */
@ExtendWith(MockitoExtension.class)
class EligibilityDecisionEngineTest {

    @Mock
    private ScholarshipRepository scholarshipRepository;

    @InjectMocks
    private EligibilityDecisionEngine engine;

    private Scholarship.ScholarshipBuilder baseScholarship() {
        return Scholarship.builder()
                .id(1L)
                .name("Test Scholarship")
                .minEducationLevel(EducationLevel.UNDERGRADUATE)
                .maxEducationLevel(EducationLevel.POSTGRADUATE)
                .maxAnnualIncome(new BigDecimal("250000"))
                .requiredGender(Gender.ANY)
                .requiresDisability(false)
                .isActive(true)
                .eligibleCategories(Set.of())
                .eligibleStates(Set.of());
    }

    private MatchCriteria.MatchCriteriaBuilder baseCriteria() {
        return MatchCriteria.builder()
                .educationLevel(EducationLevel.UNDERGRADUATE)
                .annualIncome(new BigDecimal("250000"))
                .category(Category.GENERAL)
                .gender(Gender.MALE)
                .state("Tamil Nadu")
                .hasDisability(false);
    }

    private List<MatchResult> matchAgainst(Scholarship scholarship, MatchCriteria criteria) {
        when(scholarshipRepository.findByIsActiveTrue()).thenReturn(List.of(scholarship));
        return engine.match(criteria);
    }

    @Nested
    class EducationLevelNode {

        @Test
        void matchesWhenExactlyAtMinBoundary() {
            Scholarship s = baseScholarship().minEducationLevel(EducationLevel.UNDERGRADUATE).build();
            MatchCriteria c = baseCriteria().educationLevel(EducationLevel.UNDERGRADUATE).build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }

        @Test
        void matchesWhenExactlyAtMaxBoundary() {
            Scholarship s = baseScholarship().maxEducationLevel(EducationLevel.POSTGRADUATE).build();
            MatchCriteria c = baseCriteria().educationLevel(EducationLevel.POSTGRADUATE).build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }

        @Test
        void rejectsWhenBelowMinLevel() {
            Scholarship s = baseScholarship().minEducationLevel(EducationLevel.UNDERGRADUATE).build();
            MatchCriteria c = baseCriteria().educationLevel(EducationLevel.CLASS_12).build();

            assertThat(matchAgainst(s, c)).isEmpty();
        }

        @Test
        void rejectsWhenAboveMaxLevel() {
            Scholarship s = baseScholarship().maxEducationLevel(EducationLevel.POSTGRADUATE).build();
            MatchCriteria c = baseCriteria().educationLevel(EducationLevel.PHD).build();

            assertThat(matchAgainst(s, c)).isEmpty();
        }
    }

    @Nested
    class IncomeCeilingNode {

        @Test
        void matchesWhenIncomeExactlyAtCeiling() {
            Scholarship s = baseScholarship().maxAnnualIncome(new BigDecimal("250000")).build();
            MatchCriteria c = baseCriteria().annualIncome(new BigDecimal("250000")).build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }

        @Test
        void rejectsWhenIncomeExceedsCeiling() {
            Scholarship s = baseScholarship().maxAnnualIncome(new BigDecimal("250000")).build();
            MatchCriteria c = baseCriteria().annualIncome(new BigDecimal("250001")).build();

            assertThat(matchAgainst(s, c)).isEmpty();
        }

        @Test
        void nullCeilingMeansNoIncomeCapAtAll() {
            Scholarship s = baseScholarship().maxAnnualIncome(null).build();
            MatchCriteria c = baseCriteria().annualIncome(new BigDecimal("9999999")).build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }
    }

    @Nested
    class CategoryNode {

        @Test
        void emptyEligibleCategoriesMeansOpenToEveryCategory() {
            Scholarship s = baseScholarship().eligibleCategories(Set.of()).build();
            MatchCriteria c = baseCriteria().category(Category.SC).build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }

        @Test
        void matchesWhenCategoryIsInEligibleSet() {
            Scholarship s = baseScholarship().eligibleCategories(Set.of(Category.SC, Category.ST)).build();
            MatchCriteria c = baseCriteria().category(Category.SC).build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }

        @Test
        void rejectsWhenCategoryIsNotInEligibleSet() {
            Scholarship s = baseScholarship().eligibleCategories(Set.of(Category.SC, Category.ST)).build();
            MatchCriteria c = baseCriteria().category(Category.GENERAL).build();

            assertThat(matchAgainst(s, c)).isEmpty();
        }
    }

    @Nested
    class StateNode {

        @Test
        void emptyEligibleStatesMeansOpenPanIndia() {
            Scholarship s = baseScholarship().eligibleStates(Set.of()).build();
            MatchCriteria c = baseCriteria().state("Kerala").build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }

        @Test
        void rejectsWhenStateNotInEligibleSet() {
            Scholarship s = baseScholarship().eligibleStates(Set.of("Maharashtra")).build();
            MatchCriteria c = baseCriteria().state("Kerala").build();

            assertThat(matchAgainst(s, c)).isEmpty();
        }
    }

    @Nested
    class GenderNode {

        @Test
        void anyRequiredGenderMatchesEveryone() {
            Scholarship s = baseScholarship().requiredGender(Gender.ANY).build();
            MatchCriteria c = baseCriteria().gender(Gender.FEMALE).build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }

        @Test
        void rejectsWhenGenderDoesNotMatchRequirement() {
            Scholarship s = baseScholarship().requiredGender(Gender.FEMALE).build();
            MatchCriteria c = baseCriteria().gender(Gender.MALE).build();

            assertThat(matchAgainst(s, c)).isEmpty();
        }
    }

    @Nested
    class DisabilityNode {

        @Test
        void rejectsWhenDisabilityRequiredButNotPresent() {
            Scholarship s = baseScholarship().requiresDisability(true).build();
            MatchCriteria c = baseCriteria().hasDisability(false).build();

            assertThat(matchAgainst(s, c)).isEmpty();
        }

        @Test
        void matchesWhenDisabilityRequiredAndPresent() {
            Scholarship s = baseScholarship().requiresDisability(true).build();
            MatchCriteria c = baseCriteria().hasDisability(true).build();

            assertThat(matchAgainst(s, c)).hasSize(1);
        }
    }

    @Nested
    class IntegrationScenario {

        private Scholarship scPostMatric;
        private Scholarship pragatiForGirls;
        private Scholarship inspireNoIncomeCap;

        @BeforeEach
        void setUpRealisticScholarships() {
            scPostMatric = baseScholarship()
                    .name("Post-Matric Scholarship for SC Students")
                    .minEducationLevel(EducationLevel.CLASS_11)
                    .maxEducationLevel(EducationLevel.POSTGRADUATE)
                    .maxAnnualIncome(new BigDecimal("250000"))
                    .eligibleCategories(Set.of(Category.SC))
                    .build();

            pragatiForGirls = baseScholarship()
                    .name("AICTE Pragati Scholarship for Girl Students")
                    .minEducationLevel(EducationLevel.UNDERGRADUATE)
                    .maxEducationLevel(EducationLevel.UNDERGRADUATE)
                    .maxAnnualIncome(new BigDecimal("800000"))
                    .requiredGender(Gender.FEMALE)
                    .build();

            inspireNoIncomeCap = baseScholarship()
                    .name("INSPIRE Scholarship for Higher Education")
                    .minEducationLevel(EducationLevel.UNDERGRADUATE)
                    .maxEducationLevel(EducationLevel.UNDERGRADUATE)
                    .maxAnnualIncome(null)
                    .build();
        }

        @Test
        void scGirlUndergraduateWithLowIncomeMatchesAllThreeApplicableSchemes() {
            when(scholarshipRepository.findByIsActiveTrue())
                    .thenReturn(List.of(scPostMatric, pragatiForGirls, inspireNoIncomeCap));

            MatchCriteria criteria = MatchCriteria.builder()
                    .educationLevel(EducationLevel.UNDERGRADUATE)
                    .annualIncome(new BigDecimal("200000"))
                    .category(Category.SC)
                    .gender(Gender.FEMALE)
                    .state("Tamil Nadu")
                    .hasDisability(false)
                    .build();

            List<MatchResult> results = engine.match(criteria);

            assertThat(results)
                    .extracting(r -> r.getScholarship().getName())
                    .containsExactlyInAnyOrder(
                            "Post-Matric Scholarship for SC Students",
                            "AICTE Pragati Scholarship for Girl Students",
                            "INSPIRE Scholarship for Higher Education");
        }

        @Test
        void generalCategoryMaleWithHighIncomeOnlyMatchesTheNoIncomeCapScheme() {
            when(scholarshipRepository.findByIsActiveTrue())
                    .thenReturn(List.of(scPostMatric, pragatiForGirls, inspireNoIncomeCap));

            MatchCriteria criteria = MatchCriteria.builder()
                    .educationLevel(EducationLevel.UNDERGRADUATE)
                    .annualIncome(new BigDecimal("1200000"))
                    .category(Category.GENERAL)
                    .gender(Gender.MALE)
                    .state("Tamil Nadu")
                    .hasDisability(false)
                    .build();

            List<MatchResult> results = engine.match(criteria);

            assertThat(results)
                    .extracting(r -> r.getScholarship().getName())
                    .containsExactly("INSPIRE Scholarship for Higher Education");
        }
    }
}

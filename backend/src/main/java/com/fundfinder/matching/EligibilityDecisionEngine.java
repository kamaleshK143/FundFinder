package com.fundfinder.matching;

import com.fundfinder.entity.Scholarship;
import com.fundfinder.enums.Gender;
import com.fundfinder.repository.ScholarshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * The scholarship-matching decision tree.
 * <p>
 * This is a real decision tree, just written as guard clauses instead of a
 * generic Node/Composite object graph: each `if` below is one decision node
 * (education level -> income -> category -> state -> gender -> disability),
 * and each early `return` is a leaf of the tree. A generic pluggable-node
 * framework was deliberately NOT built here - with a fixed six criteria and
 * ~20 scholarships, that would be indirection with no real benefit, and
 * harder to defend line-by-line in an interview than this straight-line
 * version. (Spring already manages this class as a singleton bean via its
 * IoC container, so there's no need to hand-roll a Singleton pattern here
 * either.)
 * <p>
 * If this ever needed to grow to dozens of independent criteria that could
 * be added/removed at runtime, the natural next step would be to extract
 * each `if` into its own EligibilityRule implementation and iterate a
 * List&lt;EligibilityRule&gt; (the Strategy pattern) - but that's premature for
 * six fixed fields today.
 */
@Service
@RequiredArgsConstructor
public class EligibilityDecisionEngine {

    private final ScholarshipRepository scholarshipRepository;

    public List<MatchResult> match(MatchCriteria criteria) {
        return scholarshipRepository.findByIsActiveTrue().stream()
                .map(scholarship -> evaluate(scholarship, criteria))
                .filter(MatchResult::isEligible)
                .toList();
    }

    private MatchResult evaluate(Scholarship scholarship, MatchCriteria criteria) {
        // Node 1: education level must fall within [min, max] for this scholarship.
        if (criteria.getEducationLevel().ordinal() < scholarship.getMinEducationLevel().ordinal()
                || criteria.getEducationLevel().ordinal() > scholarship.getMaxEducationLevel().ordinal()) {
            return MatchResult.notEligible(scholarship, "Education level not in eligible range");
        }

        // Node 2: income ceiling. A null ceiling means the scholarship is pure-merit (no income cap).
        if (scholarship.getMaxAnnualIncome() != null
                && criteria.getAnnualIncome().compareTo(scholarship.getMaxAnnualIncome()) > 0) {
            return MatchResult.notEligible(scholarship, "Family income exceeds the scholarship's ceiling");
        }

        // Node 3: category. An empty eligible-categories set means "open to every category".
        if (!scholarship.getEligibleCategories().isEmpty()
                && !scholarship.getEligibleCategories().contains(criteria.getCategory())) {
            return MatchResult.notEligible(scholarship, "Category not eligible for this scholarship");
        }

        // Node 4: state. An empty eligible-states set means "open pan-India".
        if (!scholarship.getEligibleStates().isEmpty()
                && !scholarship.getEligibleStates().contains(criteria.getState())) {
            return MatchResult.notEligible(scholarship, "Not open to applicants from this state");
        }

        // Node 5: gender. ANY means open to everyone.
        if (scholarship.getRequiredGender() != Gender.ANY
                && scholarship.getRequiredGender() != criteria.getGender()) {
            return MatchResult.notEligible(scholarship, "Gender restriction not met");
        }

        // Node 6: disability requirement.
        if (scholarship.isRequiresDisability() && !criteria.isHasDisability()) {
            return MatchResult.notEligible(scholarship, "This scholarship requires disability status");
        }

        // Leaf: passed every node above.
        return MatchResult.eligible(scholarship);
    }
}

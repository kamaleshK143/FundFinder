package com.fundfinder.matching;

import com.fundfinder.entity.Scholarship;
import lombok.Getter;

/**
 * The outcome of running one Scholarship through the decision tree for a
 * given MatchCriteria. reason is null when eligible, and set to the exact
 * criterion that failed otherwise - this is what makes the engine
 * traceable rather than a black-box yes/no.
 */
@Getter
public class MatchResult {
    private final Scholarship scholarship;
    private final boolean eligible;
    private final String reason;

    private MatchResult(Scholarship scholarship, boolean eligible, String reason) {
        this.scholarship = scholarship;
        this.eligible = eligible;
        this.reason = reason;
    }

    public static MatchResult eligible(Scholarship scholarship) {
        return new MatchResult(scholarship, true, null);
    }

    public static MatchResult notEligible(Scholarship scholarship, String reason) {
        return new MatchResult(scholarship, false, reason);
    }
}

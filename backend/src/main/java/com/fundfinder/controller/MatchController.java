package com.fundfinder.controller;

import com.fundfinder.dto.match.MatchCriteriaRequest;
import com.fundfinder.dto.scholarship.ScholarshipResponse;
import com.fundfinder.entity.Profile;
import com.fundfinder.exception.ResourceNotFoundException;
import com.fundfinder.matching.EligibilityDecisionEngine;
import com.fundfinder.matching.MatchCriteria;
import com.fundfinder.matching.MatchResult;
import com.fundfinder.matching.ProfileMapper;
import com.fundfinder.repository.ProfileRepository;
import com.fundfinder.security.UserPrincipal;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Both endpoints below call the exact same EligibilityDecisionEngine -
 * only where the MatchCriteria comes from differs. That's the concrete
 * proof that the dashboard and the (Phase 5) guided chatbot share one
 * matching engine rather than two parallel implementations.
 */
@RestController
@RequestMapping("/api/match")
@RequiredArgsConstructor
public class MatchController {

    private final EligibilityDecisionEngine decisionEngine;
    private final ProfileMapper profileMapper;
    private final ProfileRepository profileRepository;

    /** Matches against the caller's already-saved Profile. Used by the dashboard. */
    @GetMapping
    public ResponseEntity<List<ScholarshipResponse>> matchFromSavedProfile(@AuthenticationPrincipal UserPrincipal principal) {
        Profile profile = profileRepository.findByUserId(principal.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Complete your profile before viewing matches"));

        return ResponseEntity.ok(runMatch(profileMapper.toMatchCriteria(profile)));
    }

    /** Matches against criteria supplied directly in the request body, without touching a saved Profile. */
    @PostMapping("/preview")
    public ResponseEntity<List<ScholarshipResponse>> matchFromCriteria(@Valid @RequestBody MatchCriteriaRequest request) {
        return ResponseEntity.ok(runMatch(request.toMatchCriteria()));
    }

    private List<ScholarshipResponse> runMatch(MatchCriteria criteria) {
        List<MatchResult> results = decisionEngine.match(criteria);
        return results.stream()
                .map(MatchResult::getScholarship)
                .map(ScholarshipResponse::from)
                .toList();
    }
}

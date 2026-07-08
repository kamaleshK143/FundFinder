package com.fundfinder.service;

import com.fundfinder.dto.scholarship.ScholarshipRequest;
import com.fundfinder.dto.scholarship.ScholarshipResponse;
import com.fundfinder.entity.Scholarship;
import com.fundfinder.exception.ResourceNotFoundException;
import com.fundfinder.repository.ScholarshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ScholarshipService {

    private final ScholarshipRepository scholarshipRepository;

    public List<ScholarshipResponse> getAllActive() {
        return scholarshipRepository.findByIsActiveTrue().stream()
                .map(ScholarshipResponse::from)
                .toList();
    }

    public ScholarshipResponse getById(Long id) {
        return ScholarshipResponse.from(findOrThrow(id));
    }

    @Transactional
    public ScholarshipResponse create(ScholarshipRequest request) {
        Scholarship scholarship = new Scholarship();
        applyRequest(scholarship, request);
        scholarshipRepository.save(scholarship);
        return ScholarshipResponse.from(scholarship);
    }

    @Transactional
    public ScholarshipResponse update(Long id, ScholarshipRequest request) {
        Scholarship scholarship = findOrThrow(id);
        applyRequest(scholarship, request);
        scholarshipRepository.save(scholarship);
        return ScholarshipResponse.from(scholarship);
    }

    @Transactional
    public void delete(Long id) {
        Scholarship scholarship = findOrThrow(id);
        scholarshipRepository.delete(scholarship);
    }

    private Scholarship findOrThrow(Long id) {
        return scholarshipRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Scholarship not found: " + id));
    }

    private void applyRequest(Scholarship scholarship, ScholarshipRequest request) {
        scholarship.setName(request.name());
        scholarship.setProviderName(request.providerName());
        scholarship.setDescription(request.description());
        scholarship.setRewardAmountText(request.rewardAmountText());
        scholarship.setOfficialLink(request.officialLink());
        scholarship.setApplicationDeadline(request.applicationDeadline());
        scholarship.setAlwaysOpen(request.isAlwaysOpen());
        scholarship.setMinEducationLevel(request.minEducationLevel());
        scholarship.setMaxEducationLevel(request.maxEducationLevel());
        scholarship.setMaxAnnualIncome(request.maxAnnualIncome());
        scholarship.setRequiredGender(request.requiredGender());
        scholarship.setRequiresDisability(request.requiresDisability());
        scholarship.setActive(request.isActive());
        scholarship.setEligibleCategories(
                request.eligibleCategories() == null ? new HashSet<>() : new HashSet<>(request.eligibleCategories()));
        scholarship.setEligibleStates(
                request.eligibleStates() == null ? new HashSet<>() : new HashSet<>(request.eligibleStates()));
    }
}

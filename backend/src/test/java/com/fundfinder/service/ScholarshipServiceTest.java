package com.fundfinder.service;

import com.fundfinder.dto.scholarship.ScholarshipRequest;
import com.fundfinder.dto.scholarship.ScholarshipResponse;
import com.fundfinder.entity.Scholarship;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import com.fundfinder.exception.ResourceNotFoundException;
import com.fundfinder.repository.ScholarshipRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ScholarshipServiceTest {

    @Mock
    private ScholarshipRepository scholarshipRepository;

    @InjectMocks
    private ScholarshipService scholarshipService;

    private ScholarshipRequest sampleRequest() {
        return new ScholarshipRequest(
                "Test Scholarship", "Test Provider", "A description", "Rs 10,000/year",
                "https://example.com", LocalDate.of(2026, 12, 31), false,
                EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                null, Gender.ANY, false, true, Set.of(), Set.of());
    }

    @Test
    void getAllActiveReturnsOnlyActiveScholarships() {
        Scholarship active = Scholarship.builder().id(1L).name("Active One").isActive(true)
                .eligibleCategories(Set.of()).eligibleStates(Set.of()).build();
        when(scholarshipRepository.findByIsActiveTrue()).thenReturn(List.of(active));

        List<ScholarshipResponse> result = scholarshipService.getAllActive();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).name()).isEqualTo("Active One");
    }

    @Test
    void getByIdThrowsWhenNotFound() {
        when(scholarshipRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> scholarshipService.getById(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createSavesANewScholarship() {
        ScholarshipResponse response = scholarshipService.create(sampleRequest());

        ArgumentCaptor<Scholarship> captor = ArgumentCaptor.forClass(Scholarship.class);
        verify(scholarshipRepository).save(captor.capture());

        assertThat(captor.getValue().getName()).isEqualTo("Test Scholarship");
        assertThat(response.name()).isEqualTo("Test Scholarship");
    }

    @Test
    void updateModifiesTheExistingScholarshipInPlace() {
        Scholarship existing = Scholarship.builder().id(7L).name("Old Name")
                .eligibleCategories(Set.of()).eligibleStates(Set.of()).build();
        when(scholarshipRepository.findById(7L)).thenReturn(Optional.of(existing));

        ScholarshipResponse response = scholarshipService.update(7L, sampleRequest());

        assertThat(response.id()).isEqualTo(7L);
        assertThat(response.name()).isEqualTo("Test Scholarship");
    }

    @Test
    void deleteRemovesTheScholarship() {
        Scholarship existing = Scholarship.builder().id(3L).name("To Delete").build();
        when(scholarshipRepository.findById(3L)).thenReturn(Optional.of(existing));

        scholarshipService.delete(3L);

        verify(scholarshipRepository).delete(existing);
    }

    @Test
    void deleteThrowsWhenScholarshipDoesNotExist() {
        when(scholarshipRepository.findById(404L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> scholarshipService.delete(404L))
                .isInstanceOf(ResourceNotFoundException.class);

        verify(scholarshipRepository, never()).delete(any());
    }
}

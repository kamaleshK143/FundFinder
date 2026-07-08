package com.fundfinder.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fundfinder.entity.Scholarship;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import com.fundfinder.exception.GlobalExceptionHandler;
import com.fundfinder.matching.EligibilityDecisionEngine;
import com.fundfinder.matching.MatchResult;
import com.fundfinder.matching.ProfileMapper;
import com.fundfinder.repository.ProfileRepository;
import com.fundfinder.security.CustomUserDetailsService;
import com.fundfinder.security.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Set;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Security filters disabled here (addFilters = false) - request mapping and
 * response shape are the focus. The authorization rule itself (this
 * endpoint requires a token) is covered by SecurityIntegrationTest, which
 * boots the real filter chain.
 */
@WebMvcTest(controllers = MatchController.class)
@AutoConfigureMockMvc(addFilters = false)
@org.springframework.context.annotation.Import(GlobalExceptionHandler.class)
class MatchControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private EligibilityDecisionEngine decisionEngine;
    @MockitoBean
    private ProfileMapper profileMapper;
    @MockitoBean
    private ProfileRepository profileRepository;

    // JwtAuthenticationFilter is a Filter bean, so @WebMvcTest constructs it even
    // with addFilters = false - these satisfy its constructor dependencies.
    @MockitoBean
    private JwtService jwtService;
    @MockitoBean
    private CustomUserDetailsService customUserDetailsService;

    private Scholarship sampleScholarship() {
        return Scholarship.builder()
                .id(1L)
                .name("Test Scholarship")
                .minEducationLevel(EducationLevel.UNDERGRADUATE)
                .maxEducationLevel(EducationLevel.POSTGRADUATE)
                .requiredGender(Gender.ANY)
                .eligibleCategories(Set.of())
                .eligibleStates(Set.of())
                .build();
    }

    @Test
    void matchFromCriteriaReturnsEligibleScholarships() throws Exception {
        when(decisionEngine.match(any())).thenReturn(List.of(MatchResult.eligible(sampleScholarship())));

        String body = """
                {"educationLevel":"UNDERGRADUATE","annualIncome":150000,"category":"SC","gender":"FEMALE","state":"Kerala","hasDisability":false}
                """;

        mockMvc.perform(post("/api/match/preview")
                        .contentType("application/json")
                        .content(body))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].name").value("Test Scholarship"));
    }

    @Test
    void matchFromCriteriaReturns400WhenFieldsAreMissing() throws Exception {
        mockMvc.perform(post("/api/match/preview")
                        .contentType("application/json")
                        .content("{}"))
                .andExpect(status().isBadRequest());
    }
}

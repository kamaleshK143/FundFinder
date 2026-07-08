package com.fundfinder.entity;

import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * eligibleCategories / eligibleStates use the convention that an EMPTY set
 * means "open to everyone" - this avoids having to enumerate all 28
 * states for a pan-India scholarship, or all 6 categories for a
 * no-category-restriction one.
 */
@Entity
@Table(name = "scholarships")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Scholarship {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(length = 150)
    private String providerName;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 255)
    private String rewardAmountText;

    @Column(length = 500)
    private String officialLink;

    private LocalDate applicationDeadline;

    @Builder.Default
    @Column(nullable = false)
    private boolean isAlwaysOpen = false;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private EducationLevel minEducationLevel;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private EducationLevel maxEducationLevel;

    @Column(precision = 12, scale = 2)
    private BigDecimal maxAnnualIncome;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    @Column(nullable = false, length = 10)
    private Gender requiredGender = Gender.ANY;

    @Builder.Default
    @Column(nullable = false)
    private boolean requiresDisability = false;

    @Builder.Default
    @Column(nullable = false)
    private boolean isActive = true;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "scholarship_eligible_categories", joinColumns = @JoinColumn(name = "scholarship_id"))
    @Enumerated(EnumType.STRING)
    @Column(name = "category", length = 20)
    @Builder.Default
    private Set<Category> eligibleCategories = new HashSet<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "scholarship_eligible_states", joinColumns = @JoinColumn(name = "scholarship_id"))
    @Column(name = "state", length = 50)
    @Builder.Default
    private Set<String> eligibleStates = new HashSet<>();

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = createdAt;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}

package com.fundfinder.seed;

import com.fundfinder.entity.Scholarship;
import com.fundfinder.entity.User;
import com.fundfinder.enums.Category;
import com.fundfinder.enums.EducationLevel;
import com.fundfinder.enums.Gender;
import com.fundfinder.enums.Role;
import com.fundfinder.repository.ScholarshipRepository;
import com.fundfinder.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Set;

/**
 * Seeds ~18 real Indian government and non-government scholarships (researched
 * July 2026 - eligibility rules, income ceilings and deadlines for these
 * schemes change periodically, so treat this as a realistic illustrative
 * snapshot, not a live feed. Update via the admin-only /api/scholarships
 * endpoints as schemes change, rather than editing this seeder after the
 * first run.
 * <p>
 * Runs once: both loaders no-op if their table already has rows, so restarting
 * the app never duplicates data or overwrites admin edits made through the API.
 */
@Component
@RequiredArgsConstructor
public class ScholarshipDataSeeder implements CommandLineRunner {

    private final ScholarshipRepository scholarshipRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        seedAdminUser();
        seedScholarships();
    }

    private void seedAdminUser() {
        if (userRepository.existsByEmail("admin@fundfinder.local")) {
            return;
        }
        User admin = User.builder()
                .fullName("FundFinder Admin")
                .email("admin@fundfinder.local")
                .passwordHash(passwordEncoder.encode("Admin@12345"))
                .role(Role.ADMIN)
                .build();
        userRepository.save(admin);
    }

    private void seedScholarships() {
        if (scholarshipRepository.count() > 0) {
            return;
        }

        scholarshipRepository.saveAll(java.util.List.of(
                scholarship("Central Sector Scheme of Scholarship for College and University Students",
                        "Department of Higher Education, Govt. of India",
                        "Merit scholarship for students in the top 20th percentile of their Class 12 board exam, to support undergraduate and postgraduate study.",
                        "Rs 12,000/year (UG), Rs 20,000/year (PG)",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("450000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("AICTE Pragati Scholarship for Girl Students",
                        "All India Council for Technical Education (AICTE)",
                        "Financial assistance for girl students admitted to the 1st year of an AICTE-approved technical diploma or degree programme.",
                        "Rs 50,000/year for up to 4 years",
                        "https://www.aicte-india.org", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("800000"), Gender.FEMALE, false,
                        Set.of(), Set.of()),

                scholarship("Post-Matric Scholarship for SC Students",
                        "Department of Social Justice and Empowerment, Govt. of India",
                        "Covers tuition fees and maintenance allowance for Scheduled Caste students studying beyond Class 10.",
                        "Tuition fee + maintenance allowance (varies by course)",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.SC), Set.of()),

                scholarship("Post-Matric Scholarship for OBC Students (PM-YASASVI)",
                        "Ministry of Social Justice and Empowerment",
                        "Financial assistance for OBC/EBC/DNT students pursuing post-matriculation courses in India.",
                        "Rs 5,000-20,000/year depending on course",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.OBC), Set.of()),

                scholarship("Post-Matric Scholarship for ST Students",
                        "Ministry of Tribal Affairs",
                        "Maintenance allowance and fee reimbursement for Scheduled Tribe students studying beyond Class 10.",
                        "Maintenance allowance + full fee reimbursement",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.ST), Set.of()),

                scholarship("National Means-cum-Merit Scholarship (NMMS)",
                        "Ministry of Education, Govt. of India",
                        "Merit scholarship for economically weaker students to prevent dropout at the secondary stage; for government/aided school students only.",
                        "Rs 12,000/year (Rs 1,000/month)",
                        "https://scholarships.gov.in", LocalDate.of(2026, 9, 30), false,
                        EducationLevel.CLASS_9, EducationLevel.CLASS_12,
                        new BigDecimal("350000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Pre-Matric Scholarship for Minorities",
                        "Ministry of Minority Affairs",
                        "Financial assistance for minority community students (Muslim, Sikh, Christian, Buddhist, Jain, Zoroastrian) studying in Classes 1 to 10.",
                        "Up to Rs 10,000/year (admission/tuition fee + maintenance allowance)",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_8_AND_BELOW, EducationLevel.CLASS_10,
                        new BigDecimal("100000"), Gender.ANY, false,
                        Set.of(Category.MINORITY), Set.of()),

                scholarship("INSPIRE Scholarship for Higher Education (SHE)",
                        "Department of Science and Technology (DST), Govt. of India",
                        "Merit scholarship for students in the top 1% of their Class 12 board (or top ranks in JEE/NEET/KVPY) pursuing basic/natural sciences.",
                        "Rs 80,000/year for up to 5 years",
                        "https://www.online-inspire.gov.in", LocalDate.of(2026, 11, 30), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Top Class Education Scheme for Students with Disabilities",
                        "Department of Empowerment of Persons with Disabilities (DEPwD)",
                        "Full financial support for students with at least 40% disability pursuing postgraduate study at premier institutes (IIT/IIM/NIT etc).",
                        "Full tuition fee (up to Rs 2,00,000/yr) + Rs 3,000/month living allowance",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.POSTGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("600000"), Gender.ANY, true,
                        Set.of(), Set.of()),

                scholarship("Merit-cum-Means Scholarship for Minorities",
                        "Ministry of Minority Affairs",
                        "For meritorious minority-community students pursuing technical or professional courses at UG/PG level.",
                        "Tuition fee + maintenance allowance (up to Rs 20,000/year)",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.MINORITY), Set.of()),

                scholarship("Reliance Foundation Undergraduate Scholarship",
                        "Reliance Foundation",
                        "Need-and-merit scholarship for first-year undergraduate students with at least 60% in Class 12.",
                        "Up to Rs 2,00,000 over the degree programme",
                        "https://www.scholarships.reliancefoundation.org", LocalDate.of(2026, 9, 15), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("1500000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("National Fellowship for OBC Students (NF-OBC)",
                        "University Grants Commission (UGC)",
                        "Fellowship for OBC candidates pursuing full-time M.Phil./Ph.D. programmes with UGC-NET/CSIR-NET JRF qualification.",
                        "JRF/SRF-equivalent stipend for up to 5 years",
                        "https://nfobc.ugc.ac.in", LocalDate.of(2026, 11, 30), false,
                        EducationLevel.PHD, EducationLevel.PHD,
                        new BigDecimal("600000"), Gender.ANY, false,
                        Set.of(Category.OBC), Set.of()),

                scholarship("LIC Golden Jubilee Scholarship",
                        "Life Insurance Corporation of India",
                        "Merit-cum-means scholarship for Class 12 pass students entering undergraduate, diploma or ITI courses.",
                        "Rs 20,000-40,000/year depending on course",
                        "https://licindia.in/golden-jubilee-scholarship-scheme", LocalDate.of(2026, 9, 30), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Begum Hazrat Mahal National Scholarship for Minority Girls",
                        "Maulana Azad Education Foundation",
                        "Scholarship for girl students of notified minority communities studying in Classes 9 to 12.",
                        "Rs 10,000-12,000/year",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_9, EducationLevel.CLASS_12,
                        new BigDecimal("200000"), Gender.FEMALE, false,
                        Set.of(Category.MINORITY), Set.of()),

                scholarship("Maharashtra EBC (Economically Backward Class) Scholarship",
                        "Government of Maharashtra (MahaDBT)",
                        "Tuition and exam fee reimbursement for economically backward students admitted via the Centralised Admission Process in Maharashtra.",
                        "Tuition + exam fee reimbursement",
                        "https://mahadbt.maharashtra.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("800000"), Gender.ANY, false,
                        Set.of(Category.EWS), Set.of("Maharashtra")),

                scholarship("Tamil Nadu Post-Matric Scholarship for BC/MBC/DNC Students",
                        "Government of Tamil Nadu, Dept. of Collegiate Education",
                        "Full fee waiver and stipend for Backward Class/Most Backward Class/Denotified Community students in Tamil Nadu.",
                        "Full fee waiver + stipend",
                        "https://tndce.tn.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.OBC), Set.of("Tamil Nadu")),

                scholarship("Aditya Birla Scholarship",
                        "Aditya Birla Group",
                        "Merit scholarship for top-ranked students admitted to IITs/NITs (engineering), IIMs/XLRI (management) or select law colleges.",
                        "Rs 1,50,000-3,00,000/year depending on stream",
                        "https://www.adityabirlascholars.net", LocalDate.of(2026, 8, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Kotak Kanya Scholarship",
                        "Kotak Education Foundation",
                        "Scholarship for meritorious girl students (75%+ in Class 12) entering professional undergraduate courses such as engineering, medicine or law.",
                        "Rs 1,50,000/year till course completion",
                        "https://www.kotakeducationfoundation.org", LocalDate.of(2026, 8, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("600000"), Gender.FEMALE, false,
                        Set.of(), Set.of())
        ));
    }

    private Scholarship scholarship(
            String name, String provider, String description, String reward, String link,
            LocalDate deadline, boolean alwaysOpen,
            EducationLevel minLevel, EducationLevel maxLevel,
            BigDecimal maxIncome, Gender requiredGender, boolean requiresDisability,
            Set<Category> categories, Set<String> states
    ) {
        return Scholarship.builder()
                .name(name)
                .providerName(provider)
                .description(description)
                .rewardAmountText(reward)
                .officialLink(link)
                .applicationDeadline(deadline)
                .isAlwaysOpen(alwaysOpen)
                .minEducationLevel(minLevel)
                .maxEducationLevel(maxLevel)
                .maxAnnualIncome(maxIncome)
                .requiredGender(requiredGender)
                .requiresDisability(requiresDisability)
                .isActive(true)
                .eligibleCategories(new java.util.HashSet<>(categories))
                .eligibleStates(new java.util.HashSet<>(states))
                .build();
    }
}

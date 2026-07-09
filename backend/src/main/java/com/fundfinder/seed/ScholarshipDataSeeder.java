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
 * Seeds 51 real Indian government and non-government scholarships (researched
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
                        Set.of(), Set.of()),

                // --- Additional National Scholarship Portal / central government schemes ---

                scholarship("AICTE Saksham Scholarship Scheme for Specially-Abled Students",
                        "All India Council for Technical Education (AICTE)",
                        "Financial assistance for specially-abled students (at least 40% disability) admitted to the 1st year of an AICTE-approved diploma or degree programme.",
                        "Rs 50,000/year",
                        "https://www.aicte-india.org", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("800000"), Gender.ANY, true,
                        Set.of(), Set.of()),

                scholarship("National Overseas Scholarship for SC etc. Candidates",
                        "Department of Social Justice and Empowerment, Govt. of India",
                        "Full funding for low-income meritorious SC/DNT/landless-labourer candidates to pursue Master's or PhD study abroad.",
                        "Full tuition + annual maintenance allowance (USD 15,400 or GBP 9,900)",
                        "https://socialjustice.gov.in", LocalDate.of(2027, 3, 31), false,
                        EducationLevel.POSTGRADUATE, EducationLevel.PHD,
                        new BigDecimal("800000"), Gender.ANY, false,
                        Set.of(Category.SC), Set.of()),

                scholarship("CBSE Merit Scholarship Scheme for Single Girl Child",
                        "Central Board of Secondary Education (CBSE)",
                        "Merit scholarship for single daughters (no siblings) who scored 60%+ in the CBSE Class 10 exam and are studying Class 11-12 in a CBSE-affiliated school.",
                        "Rs 500-1,000/month for 2 years",
                        "https://www.cbse.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.CLASS_12,
                        new BigDecimal("800000"), Gender.FEMALE, false,
                        Set.of(), Set.of()),

                scholarship("Prime Minister's Scholarship Scheme for Wards of Ex-Servicemen",
                        "Kendriya Sainik Board, Ministry of Defence",
                        "Scholarship for dependent wards/widows of ex-servicemen, ex-Coast Guard and police personnel who scored 60%+ in Class 12, entering the 1st year of a professional degree.",
                        "Rs 2,500/month (boys), Rs 3,000/month (girls)",
                        "https://ksb.gov.in", LocalDate.of(2026, 9, 30), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("National Fellowship for Scheduled Caste Students (NFSC)",
                        "Department of Social Justice and Empowerment, Govt. of India",
                        "Fellowship for SC candidates pursuing full-time M.Phil./Ph.D. programmes with UGC-NET/CSIR-NET JRF qualification.",
                        "JRF/SRF-equivalent stipend for up to 5 years",
                        "https://socialjustice.gov.in", LocalDate.of(2026, 11, 30), false,
                        EducationLevel.PHD, EducationLevel.PHD,
                        new BigDecimal("600000"), Gender.ANY, false,
                        Set.of(Category.SC), Set.of()),

                scholarship("Ishan Uday Special Scholarship Scheme for North Eastern Region",
                        "University Grants Commission (UGC)",
                        "Scholarship for students domiciled in the 8 North Eastern states entering the 1st year of a UG degree programme.",
                        "Rs 5,400/month (general), Rs 7,800/month (technical/medical)",
                        "https://www.ugc.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("450000"), Gender.ANY, false,
                        Set.of(), Set.of("Arunachal Pradesh", "Assam", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Sikkim", "Tripura")),

                scholarship("PM-YASASVI Top Class Education Scheme for OBC/EBC/DNT Students",
                        "Ministry of Social Justice and Empowerment",
                        "Full financial support for OBC/EBC/DNT students admitted to notified premier institutes (IITs, IIMs, NITs, AIIMS, NLUs and similar).",
                        "Full tuition + non-refundable charges + Rs 3,000/month",
                        "https://scholarships.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.OBC), Set.of()),

                scholarship("Prime Minister's Research Fellowship (PMRF)",
                        "Ministry of Education, Govt. of India",
                        "Direct-entry PhD fellowship at IITs/IISc for top graduates and final-year students of UG/integrated-PG science and technology programmes.",
                        "Rs 70,000-80,000/month + Rs 2,00,000/year research grant",
                        "https://pmrf.in", null, true,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Central Sector Scholarship of Top Class Education for SC Students",
                        "Department of Social Justice and Empowerment, Govt. of India",
                        "Full financial support for SC students admitted to notified premier institutes for undergraduate or postgraduate study.",
                        "Full tuition fee (up to Rs 2,00,000/yr at private institutes) + living allowance",
                        "https://tcs.dosje.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("600000"), Gender.ANY, false,
                        Set.of(Category.SC), Set.of()),

                // --- State-specific schemes ---

                scholarship("Vidyasiri Scholarship",
                        "Department of Social Welfare, Govt. of Karnataka",
                        "Post-matric scholarship for SC/ST/Category-1/OBC students in Karnataka, covering full course fee plus a maintenance allowance for hostellers.",
                        "Full fee reimbursement + Rs 14,000-25,000/year",
                        "https://ssp.karnataka.gov.in", LocalDate.of(2027, 1, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.SC, Category.ST, Category.OBC), Set.of("Karnataka")),

                scholarship("e-Grantz Post-Matric Scholarship for SC/ST Students",
                        "Govt. of Kerala",
                        "Post-matric scholarship for SC/ST students in Kerala, with no family income ceiling - full fee waiver plus a monthly maintenance allowance.",
                        "Full fee waiver + up to Rs 1,500/month",
                        "https://egrantz.kerala.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(Category.SC, Category.ST), Set.of("Kerala")),

                scholarship("Post-Matric (Dashmottar) Scholarship",
                        "Social Welfare Department, Govt. of Uttar Pradesh",
                        "Post-matric scholarship for UP-domiciled students in undergraduate, postgraduate, diploma and professional courses.",
                        "Tuition + maintenance allowance (varies by course)",
                        "https://scholarship.up.gov.in", LocalDate.of(2026, 11, 30), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(), Set.of("Uttar Pradesh")),

                scholarship("Swami Vivekananda Merit-cum-Means Scholarship (SVMCM)",
                        "Govt. of West Bengal",
                        "Merit-cum-means scholarship for West Bengal students from Class 11 through PhD in science, arts, commerce, engineering, medical and technical courses.",
                        "Rs 1,000-8,000/month depending on course",
                        "https://svmcm.wb.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.PHD,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(), Set.of("West Bengal")),

                scholarship("Mukhyamantri Yuva Swavalamban Yojana (MYSY)",
                        "Govt. of Gujarat",
                        "Gujarat's flagship merit scholarship for students scoring 80%+ in Class 10/12, entering professional undergraduate courses such as engineering, medicine or pharmacy.",
                        "Tuition up to Rs 2,00,000/year + Rs 10,000 equipment allowance",
                        "https://mysy.gujarat.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("600000"), Gender.ANY, false,
                        Set.of(), Set.of("Gujarat")),

                scholarship("Mukhyamantri Uchch Shiksha Chhatravritti Yojana",
                        "Higher Technical and Medical Education Dept., Govt. of Rajasthan",
                        "Rajasthan's flagship higher-education scholarship for meritorious Class 12 board toppers and income-eligible students entering UG/PG courses.",
                        "Rs 500-2,000/month, up to Rs 2,00,000 total",
                        "https://hte.rajasthan.gov.in", LocalDate.of(2026, 11, 30), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(), Set.of("Rajasthan")),

                scholarship("Jagananna Vidya Deevena",
                        "Govt. of Andhra Pradesh",
                        "Full tuition fee reimbursement for SC/ST/BC/EBC/Minority/Kapu students from Andhra Pradesh pursuing undergraduate and professional courses.",
                        "Full tuition fee reimbursement",
                        "https://jnanabhumi.ap.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.SC, Category.ST, Category.OBC, Category.MINORITY), Set.of("Andhra Pradesh")),

                scholarship("Telangana Post-Matric Scholarship (ePASS)",
                        "Govt. of Telangana",
                        "Post-matric scholarship and fee reimbursement for SC/ST/BC/Minority students from Telangana studying Class 11 through postgraduation.",
                        "Fee reimbursement + maintenance allowance",
                        "https://telanganaepass.cgg.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        new BigDecimal("200000"), Gender.ANY, false,
                        Set.of(Category.SC, Category.ST, Category.OBC, Category.MINORITY), Set.of("Telangana")),

                scholarship("Post-Matric Scholarship for SC/BC Students",
                        "Department of Social Justice, Empowerment and Minorities, Govt. of Punjab",
                        "Post-matric scholarship for SC/BC students from Punjab, covering fees and a monthly maintenance allowance from Class 11 through postgraduation.",
                        "Rs 230-1,200/month + fee reimbursement",
                        "https://scholarships.punjab.gov.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(Category.SC, Category.OBC), Set.of("Punjab")),

                // --- Private trusts and corporate foundations ---

                scholarship("Sitaram Jindal Foundation Scholarship",
                        "Sitaram Jindal Foundation",
                        "Merit-cum-means scholarship for financially disadvantaged students from Class 11 through postgraduation, including polytechnic and diploma courses. Applications are accepted year-round.",
                        "Rs 500-3,200/month depending on course",
                        "https://sitaramjindalfoundation.org", null, true,
                        EducationLevel.CLASS_11, EducationLevel.POSTGRADUATE,
                        new BigDecimal("400000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("HDFC Bank Parivartan Educational Crisis Scholarship Support",
                        "HDFC Bank Parivartan",
                        "Support for students from Class 1 through postgraduation who are at risk of dropping out due to a personal or family financial crisis.",
                        "Rs 15,000-75,000 depending on course level",
                        "https://www.parivartanecss.com", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.CLASS_8_AND_BELOW, EducationLevel.POSTGRADUATE,
                        new BigDecimal("250000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("ONGC Foundation Scholarship",
                        "ONGC Foundation",
                        "Merit scholarship for 1st-year SC/ST/OBC/EWS/PwD students admitted to engineering, MBA, MBBS or geology/geophysics programmes.",
                        "Rs 48,000/year",
                        "https://www.ongcfoundation.org", LocalDate.of(2026, 9, 30), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("450000"), Gender.ANY, false,
                        Set.of(Category.SC, Category.ST, Category.OBC, Category.EWS), Set.of()),

                scholarship("L&T Build India Scholarship",
                        "Larsen & Toubro",
                        "Scholarship for final-year Civil/Electrical B.E./B.Tech students at IIT Delhi, IIT Madras, NIT Surathkal and NIT Trichy with a minimum 70% aggregate.",
                        "Rs 13,400/month for 24 months",
                        "https://www.larsentoubro.com", LocalDate.of(2027, 3, 25), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("JN Tata Endowment for the Higher Education of Indians",
                        "Tata Trusts",
                        "Merit-based loan-scholarship for Indian graduates admitted to Master's, PhD or post-doctoral study abroad, across all fields.",
                        "Interest-free loan-scholarship (amount varies by course)",
                        "https://jntataendowment.org", LocalDate.of(2027, 4, 30), false,
                        EducationLevel.POSTGRADUATE, EducationLevel.PHD,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("NTPC Scholarship",
                        "NTPC Limited",
                        "Scholarship for SC/ST/PwD students in the 2nd year of a full-time B.E./B.Tech programme in specified engineering disciplines.",
                        "Up to Rs 60,000/year",
                        "https://www.vidyasaarathi.co.in", LocalDate.of(2026, 10, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("450000"), Gender.ANY, false,
                        Set.of(Category.SC, Category.ST), Set.of()),

                scholarship("Indian Oil Educational Scholarship Scheme",
                        "Indian Oil Corporation Limited",
                        "Scholarship for school and undergraduate students from very low-income families, with preference given to the most financially disadvantaged applicants.",
                        "Up to Rs 36,000/year",
                        "https://iocl.com/Scholarships", LocalDate.of(2026, 9, 30), false,
                        EducationLevel.CLASS_9, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("60000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("K.C. Mahindra Scholarship for Post-Graduate Studies Abroad",
                        "K.C. Mahindra Education Trust",
                        "Interest-free loan-scholarship for meritorious Indian graduates from financially weak backgrounds pursuing postgraduate study abroad.",
                        "Up to Rs 10,00,000 (interest-free loan-scholarship)",
                        "https://www.kcmet.org", LocalDate.of(2027, 6, 30), false,
                        EducationLevel.POSTGRADUATE, EducationLevel.POSTGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Colgate Keep India Smiling Scholarship",
                        "Colgate-Palmolive (India) Limited",
                        "One-time scholarship for students enrolled full-time in BDS or MDS courses at recognised institutions.",
                        "Rs 75,000 (one-time)",
                        "https://www.colgatepalmolive.co.in", LocalDate.of(2026, 9, 30), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("800000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Foundation for Excellence (FFE) Scholarship",
                        "Foundation for Excellence",
                        "Merit-cum-means scholarship for 1st-year BE/B.Tech, integrated M.Tech, MBBS or 5-year Law students admitted via merit-based counselling.",
                        "Rs 50,000/year",
                        "https://ffe.org", LocalDate.of(2026, 8, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.UNDERGRADUATE,
                        new BigDecimal("300000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Inlaks Shivdasani Foundation Scholarship",
                        "Inlaks Shivdasani Foundation",
                        "Merit-based scholarship for Indian graduates admitted to a Master's programme abroad, covering tuition, living expenses and travel.",
                        "Up to USD 1,20,000",
                        "https://inlaksfoundation.org", LocalDate.of(2027, 4, 15), false,
                        EducationLevel.POSTGRADUATE, EducationLevel.POSTGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Bharat Petroleum Corporation Scholarship for Higher Studies",
                        "Bharat Petroleum Corporation Limited",
                        "Scholarship for graduates with 60%+ marks admitted to a postgraduate course in India or abroad. Applications open twice a year.",
                        "Tuition + living stipend (varies by case)",
                        "https://www.bharatpetroleum.in/careers/scholarship-announcement", null, true,
                        EducationLevel.POSTGRADUATE, EducationLevel.POSTGRADUATE,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Reliance Foundation Postgraduate Scholarship",
                        "Reliance Foundation",
                        "Scholarship for 1st-year postgraduate students in AI, computer science, engineering and applied science fields, selected via GATE score or UG CGPA.",
                        "Up to Rs 6,00,000 over the programme",
                        "https://www.scholarships.reliancefoundation.org", LocalDate.of(2026, 9, 15), false,
                        EducationLevel.POSTGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("1500000"), Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Aga Khan Foundation International Scholarship Programme",
                        "Aga Khan Foundation",
                        "Half-grant, half-loan scholarship for Indian students entering the 1st year of a Master's or PhD programme abroad, across all fields of study.",
                        "Half grant + half interest-based loan (amount varies by course)",
                        "https://akf.org/international-scholarship-programme", LocalDate.of(2027, 3, 31), false,
                        EducationLevel.POSTGRADUATE, EducationLevel.PHD,
                        null, Gender.ANY, false,
                        Set.of(), Set.of()),

                scholarship("Coal India Limited Merit Scholarship for Engineering & Medical Students",
                        "Coal India Limited",
                        "Merit scholarship for meritorious students from low-income (BPL) families pursuing engineering or medical courses.",
                        "Tuition + maintenance allowance (varies by course)",
                        "https://www.coalindia.in", LocalDate.of(2026, 8, 31), false,
                        EducationLevel.UNDERGRADUATE, EducationLevel.POSTGRADUATE,
                        new BigDecimal("100000"), Gender.ANY, false,
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

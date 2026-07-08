package com.fundfinder.matching;

import com.fundfinder.entity.Profile;
import org.springframework.stereotype.Component;

@Component
public class ProfileMapper {

    public MatchCriteria toMatchCriteria(Profile profile) {
        return MatchCriteria.builder()
                .educationLevel(profile.getEducationLevel())
                .annualIncome(profile.getAnnualFamilyIncome())
                .category(profile.getCategory())
                .gender(profile.getGender())
                .state(profile.getState())
                .hasDisability(profile.isHasDisability())
                .build();
    }
}

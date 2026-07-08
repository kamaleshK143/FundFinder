package com.fundfinder.controller;

import com.fundfinder.dto.profile.ProfileRequest;
import com.fundfinder.dto.profile.ProfileResponse;
import com.fundfinder.security.UserPrincipal;
import com.fundfinder.service.ProfileService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/profile")
@RequiredArgsConstructor
public class ProfileController {

    private final ProfileService profileService;

    @GetMapping
    public ResponseEntity<ProfileResponse> getMyProfile(@AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(profileService.getByUserId(principal.getId()));
    }

    @PutMapping
    public ResponseEntity<ProfileResponse> upsertMyProfile(
            @AuthenticationPrincipal UserPrincipal principal,
            @Valid @RequestBody ProfileRequest request
    ) {
        return ResponseEntity.ok(profileService.upsert(principal.getId(), request));
    }
}

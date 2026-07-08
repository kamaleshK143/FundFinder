package com.fundfinder.controller;

import com.fundfinder.dto.scholarship.ScholarshipRequest;
import com.fundfinder.dto.scholarship.ScholarshipResponse;
import com.fundfinder.service.ScholarshipService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * GET is public (permitAll in SecurityConfig) so anyone can browse
 * scholarships without an account. Write operations require ROLE_ADMIN -
 * see SecurityConfig's authorizeHttpRequests rule for /api/scholarships/**.
 * There is deliberately no admin UI: new scholarships are added by calling
 * these endpoints directly (e.g. via Postman) as the seeded admin user.
 */
@RestController
@RequestMapping("/api/scholarships")
@RequiredArgsConstructor
public class ScholarshipController {

    private final ScholarshipService scholarshipService;

    @GetMapping
    public ResponseEntity<List<ScholarshipResponse>> getAll() {
        return ResponseEntity.ok(scholarshipService.getAllActive());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ScholarshipResponse> getById(@PathVariable Long id) {
        return ResponseEntity.ok(scholarshipService.getById(id));
    }

    @PostMapping
    public ResponseEntity<ScholarshipResponse> create(@Valid @RequestBody ScholarshipRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(scholarshipService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ScholarshipResponse> update(@PathVariable Long id, @Valid @RequestBody ScholarshipRequest request) {
        return ResponseEntity.ok(scholarshipService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        scholarshipService.delete(id);
        return ResponseEntity.noContent().build();
    }
}

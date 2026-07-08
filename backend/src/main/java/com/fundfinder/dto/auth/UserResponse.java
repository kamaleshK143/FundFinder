package com.fundfinder.dto.auth;

import com.fundfinder.entity.User;
import com.fundfinder.enums.Role;

public record UserResponse(
        Long id,
        String fullName,
        String email,
        Role role
) {
    public static UserResponse from(User user) {
        return new UserResponse(user.getId(), user.getFullName(), user.getEmail(), user.getRole());
    }
}

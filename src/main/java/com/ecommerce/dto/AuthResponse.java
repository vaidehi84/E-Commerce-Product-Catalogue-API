package com.ecommerce.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthResponse {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String token;
    private Set<String> roles;
    private LocalDateTime createdAt;
}

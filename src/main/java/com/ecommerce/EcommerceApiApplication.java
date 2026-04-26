package com.ecommerce;

import com.ecommerce.entity.Role;
import com.ecommerce.repository.RoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class EcommerceApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(EcommerceApiApplication.class, args);
    }

    @Bean
    public CommandLineRunner run(RoleRepository roleRepository) {
        return args -> {
            // Initialize default roles if they don't exist
            if (roleRepository.findByName(Role.RoleName.ROLE_USER).isEmpty()) {
                roleRepository.save(Role.builder()
                        .name(Role.RoleName.ROLE_USER)
                        .build());
            }

            if (roleRepository.findByName(Role.RoleName.ROLE_ADMIN).isEmpty()) {
                roleRepository.save(Role.builder()
                        .name(Role.RoleName.ROLE_ADMIN)
                        .build());
            }
        };
    }
}

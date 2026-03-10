package com.xwworkz.sports.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.Pattern;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserLoginDto {

    private int loginId;

    @NotBlank(message = "Email or contact cannot be blank")
    private String emailOrContact;

    @NotBlank(message = "Password is required")
    @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!]).{8,20}$"
            , message = "Password must be 8–20 characters long, include at least one digit, one lowercase letter, one uppercase letter, and one special character")
    private String password;

    private LocalDate localDate;
    private LocalTime localTime;
}

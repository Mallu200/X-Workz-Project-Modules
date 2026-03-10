package com.xwworkz.sports.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "user_register")
@NamedQueries({
        @NamedQuery(name = "UserEntity.findByEmail", query = "SELECT u FROM UserEntity u WHERE u.emailId = :emailId"),
        @NamedQuery(name = "UserEntity.findByContact", query = "SELECT u FROM UserEntity u WHERE u.contact = :contact"),
    @NamedQuery(name = "UserEntity.findByEmailOrContact", query = "SELECT u FROM UserEntity u WHERE u.emailId = :emailOrContact OR u.contact = :emailOrContact"),
        @NamedQuery(name = "UserEntity.updateOtpByEmail", query = "UPDATE UserEntity u SET u.otp = :otp WHERE u.emailId = :emailId"),
        @NamedQuery(name = "UserEntity.findExpiredOtps", query = "SELECT u FROM UserEntity u WHERE u.otp IS NOT NULL AND u.otpCreatedAt < :time")
})
public class UserEntity {
    @Id
    @Column(name = "user_id")
    private int userId;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "gender")
    private String gender;

    @Column(name = "date_of_birth")
    private String dateOfBirth;

    @Column(name = "contact",unique = true)
    private String contact;

    @Column(name = "email_id",unique = true)
    private String emailId;

    @Column(name = "country")
    private String country;

    @Column(name = "state")
    private String state;

    @Column(name = "city")
    private String city;

    @Column(name = "pin_code")
    private String pincode;

    @Column(name = "password")
    private String password;

    @Column(name = "otp")
    private String otp;

    @Column(name = "otp_created_at")
    private LocalDateTime otpCreatedAt;

    @Column(name = "profile_name")
    private String profileName;
}

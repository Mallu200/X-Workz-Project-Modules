package com.xwworkz.sports.entity;

import lombok.Data;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Entity
@Table(name = "user_login")
public class UserLoginEntity {

    @Id
    @Column(name = "login_id")
    private int loginId;

    @Column(name = "email_or_contact")
    private String emailOrContact;

    @Column(name = "password")
    private String password;

    @Column(name = "login_date")
    private LocalDate loginDate;

    @Column(name = "login_time")
    private LocalTime loginTime;
}

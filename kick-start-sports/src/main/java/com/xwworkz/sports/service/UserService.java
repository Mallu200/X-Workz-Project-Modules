package com.xwworkz.sports.service;

import com.xwworkz.sports.dto.UserDto;
import com.xwworkz.sports.dto.UserLoginDto;

import java.util.List;

public interface UserService {
    boolean createUser(UserDto userDto, List<String> errors);

    UserDto findByContact(String contact);

    UserDto findByEmailId(String emailId);

    UserDto findByEmailOrContact(String emailOrContact);

    boolean checkPassword(UserLoginDto loginDto, String rawPassword);

    boolean userLogin(UserLoginDto loginDto);

    boolean sendOtpToEmail(String email);

    boolean verifyOtp(String email, String otp);

    boolean updatePassword(String email, String password, List<String> errors);

    boolean clearExpiredOtps();

    boolean updateUserProfile(UserDto userDto);
}

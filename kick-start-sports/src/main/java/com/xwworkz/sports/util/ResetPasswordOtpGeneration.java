package com.xwworkz.sports.util;

public interface ResetPasswordOtpGeneration {
    String otpGenerator();

    String simpleMailMessage(String email);
}

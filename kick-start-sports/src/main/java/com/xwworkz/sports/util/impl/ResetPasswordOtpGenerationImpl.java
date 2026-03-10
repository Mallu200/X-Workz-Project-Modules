package com.xwworkz.sports.util.impl;

import com.xwworkz.sports.service.UserService;
import com.xwworkz.sports.util.ResetPasswordOtpGeneration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Random;

@Component
public class ResetPasswordOtpGenerationImpl implements ResetPasswordOtpGeneration {

    private static final Logger logger = LoggerFactory.getLogger(ResetPasswordOtpGenerationImpl.class);


    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private UserService userService;

    @Override
    public String otpGenerator() {
        Random random = new Random();
        int generateOtp = 1000 + random.nextInt(9000);
        logger.info("[otpGenerator] Generated OTP for internal use (not logged for security)");
        return String.valueOf(generateOtp);
    }

    @Override
    public String simpleMailMessage(String emailID) {
        logger.info("[simpleMailMessage] Preparing to send OTP to email: {}", emailID);

        String otp = otpGenerator();

        SimpleMailMessage mailMessage = new SimpleMailMessage();
        mailMessage.setFrom("chapisgarmallikarjun@gmail.com");
        mailMessage.setTo(emailID);
        mailMessage.setSubject("Your OTP for Password Reset");

        String text = "Dear User,\n\n" +
                "We received a request to reset your password for your account.\n" +
                "Please use the following One-Time Password (OTP) to proceed:\n\n" +
                "OTP: " + otp + "\n\n" +
                "This OTP is valid for the next 10 minutes.\n" +
                "If you did not request a password reset, please ignore this email.\n\n" +
                "Best regards,\n" +
                "KickStart Sports Team";

        mailMessage.setText(text);

        // Send the email
        try{
            mailSender.send(mailMessage);
            logger.info("[simpleMailMessage] OTP email sent successfully to: {}", emailID);
        }catch (Exception e){
            logger.error("[simpleMailMessage] Failed to send OTP email to: {}", emailID, e);
        }
        return otp;
    }

    // otp expiring
    @Scheduled(fixedRate = 500000)
    private void runTask() {
        logger.info("[runTask] Checking for expired OTPs...");
        try {
            boolean cleared = userService.clearExpiredOtps();

            if (cleared) {
                logger.info("[runTask] Expired OTPs were cleared successfully.");
            } else {
                logger.info("[runTask] No expired OTPs to clear.");
            }
        }catch (Exception e){
            logger.error("[runTask] Exception while clearing expired OTPs", e);
        }
    }
}
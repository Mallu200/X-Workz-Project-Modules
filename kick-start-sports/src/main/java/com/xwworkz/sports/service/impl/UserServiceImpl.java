
package com.xwworkz.sports.service.impl;

import com.xwworkz.sports.dto.UserDto;
import com.xwworkz.sports.dto.UserLoginDto;
import com.xwworkz.sports.entity.UserEntity;
import com.xwworkz.sports.entity.UserLoginEntity;
import com.xwworkz.sports.repository.UserRepository;
import com.xwworkz.sports.service.UserService;
import com.xwworkz.sports.util.ResetPasswordOtpGeneration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.TimeZone;

@Service
public class UserServiceImpl implements UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    public static boolean isPasswordValid(String password) {
        if (password == null) return false;
        // 8-20 chars, at least 1 digit, 1 lowercase, 1 uppercase, 1 special char
        return password.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!]).{8,20}$");
    }

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private ResetPasswordOtpGeneration otpGenerator;

    static {
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
        logger.info("[Startup] JVM default timezone set to UTC");
    }

    @Override
    public boolean createUser(UserDto userDto, List<String> errors) {
        logger.info("[createUser] Called with email: {}", userDto.getEmailId());
        try {
            if (!isPasswordValid(userDto.getPassword())) {
                errors.add("Password must be 8–20 characters, include upper, lower, digit, special char");
            }
            if (!userDto.getPassword().equals(userDto.getConfirmPassword())) {
                errors.add("Password and Confirm Password do not match.");
                logger.warn("[createUser] Password mismatch for email: {}", userDto.getEmailId());
            }
            if (findByEmailId(userDto.getEmailId()) != null) {
                errors.add("User already exists with this email.");
                logger.warn("[createUser] Email already exists: {}", userDto.getEmailId());
            }
            if (findByContact(userDto.getContact()) != null) {
                errors.add("User already exists with this contact.");
                logger.warn("[createUser] Contact already exists: {}", userDto.getContact());
            }
            if (!errors.isEmpty()) {
                return false;
            }
            UserEntity userEntity = new UserEntity();
            BeanUtils.copyProperties(userDto, userEntity);
            userEntity.setPassword(passwordEncoder.encode(userDto.getPassword()));
            logger.info("[createUser] UserEntity created for email: {}", userDto.getEmailId());

            boolean saved = userRepository.saveUser(userEntity);
            logger.info("[createUser] User saved: {}", saved);
            return saved;
        } catch (Exception e) {
            logger.error("[createUser] Exception for email: {}", userDto.getEmailId(), e);
            errors.add("Exception occurred while creating user: " + e.getMessage());
            return false;
        }
    }

    @Override
    public UserDto findByEmailId(String emailId) {
        logger.info("[findByEmailId] Called with: {}", emailId);
        try {
            UserEntity user = userRepository.findByEmailId(emailId);
            if (user == null) {
                logger.warn("[findByEmailId] No user found for email: {}", emailId);
                return null;
            }
            UserDto dto = new UserDto();
            BeanUtils.copyProperties(user, dto);
            logger.info("[findByEmailId] User found for email: {}", emailId);
            return dto;
        } catch (Exception e) {
            logger.error("[findByEmailId] Exception for email: {}", emailId, e);
            return null;
        }
    }

    @Override
    public UserDto findByContact(String contact) {
        logger.info("[findByContact] Called with: {}", contact);
        try {
            UserEntity user = userRepository.findByContact(contact);
            if (user == null) {
                logger.warn("[findByContact] No user found for contact: {}", contact);
                return null;
            }
            UserDto dto = new UserDto();
            BeanUtils.copyProperties(user, dto);
            logger.info("[findByContact] User found for contact: {}", contact);
            return dto;
        } catch (Exception e) {
            logger.error("[findByContact] Exception for contact: {}", contact, e);
            return null;
        }
    }

    @Override
    public UserDto findByEmailOrContact(String emailOrContact) {
        logger.info("[findByEmailOrContact] Called with: {}", emailOrContact);
        try {
            UserEntity user = userRepository.findByEmailOrContact(emailOrContact);
            if (user == null) {
                logger.warn("[findByEmailOrContact] No user found for: {}", emailOrContact);
                return null;
            }
            UserDto dto = new UserDto();
            BeanUtils.copyProperties(user, dto);
            logger.info("[findByEmailOrContact] UserDto created for: {}", emailOrContact);
            return dto;
        } catch (Exception e) {
            logger.error("[findByEmailOrContact] Exception for: {}", emailOrContact, e);
            return null;
        }
    }

    @Override
    public boolean checkPassword(UserLoginDto loginDto, String rawPassword) {
        logger.info("[checkPassword] Called for email/contact: {}", loginDto.getEmailOrContact());
        if (loginDto == null || rawPassword == null) {
            logger.warn("[checkPassword] Invalid input");
            return false;
        }
        boolean match = passwordEncoder.matches(rawPassword, loginDto.getPassword());
        logger.info("[checkPassword] Password match: {}", match);
        return match;
    }

    @Override
    public boolean userLogin(UserLoginDto loginDto) {
        logger.info("[userLogin] Called for: {}", loginDto.getEmailOrContact());
        if (loginDto == null) return false;

        try {
            UserLoginEntity loginEntity = new UserLoginEntity();
            BeanUtils.copyProperties(loginDto,loginEntity);
            loginEntity.setLoginDate(LocalDate.now());
            loginEntity.setLoginTime(LocalTime.now());

            boolean success = userRepository.userLogin(loginEntity);
            logger.info("[userLogin] Login saved: {}", success);
            return success;
        } catch (Exception e) {
            logger.error("[userLogin] Exception for: {}", loginDto.getEmailOrContact(), e);
            return false;
        }
    }

    @Override
    public boolean sendOtpToEmail(String emailId) {
        logger.info("[sendOtpToEmail] Called for: {}", emailId);
        try {
            UserEntity user = userRepository.findByEmailId(emailId);
            if (user == null) {
                logger.warn("[sendOtpToEmail] No user found for email: {}", emailId);
                return false;
            }

            String otp = otpGenerator.simpleMailMessage(emailId);
            logger.info("[sendOtpToEmail] OTP generated");

            String encodeOtp = passwordEncoder.encode(otp);
            user.setOtp(encodeOtp);
            user.setOtpCreatedAt(LocalDateTime.now());

            boolean updated = userRepository.updateUser(user);
            logger.info("[sendOtpToEmail] OTP saved: {}", updated);
            return updated;
        } catch (Exception e) {
            logger.error("[sendOtpToEmail] Exception for email: {}", emailId, e);
            return false;
        }
    }

    @Override
    public boolean verifyOtp(String email, String otp) {
        logger.info("[verifyOtp] Called for email: {}", email);
        try {
            UserEntity user = userRepository.findByEmailId(email);
            if (user == null) {
                logger.warn("[verifyOtp] No user found");
                return false;
            }
            if (user.getOtp() == null || user.getOtpCreatedAt() == null) {
                logger.warn("[verifyOtp] OTP is null or expired");
                return false;
            }
            // Extra safety: check if OTP is expired (older than 10 min)
            LocalDateTime now = LocalDateTime.now();
            if (user.getOtpCreatedAt().isBefore(now.minusMinutes(10))) {
                logger.warn("[verifyOtp] OTP expired");
                return false;
            }
            if (passwordEncoder.matches(otp, user.getOtp())) {
                logger.info("[verifyOtp] OTP verified successfully");
                return true;
            } else {
                logger.warn("[verifyOtp] OTP verification failed");
                return false;
            }
        } catch (Exception e) {
            logger.error("[verifyOtp] Exception for email: {}", email, e);
            return false;
        }
    }

    @Override
    public boolean updatePassword(String email, String password, List<String> errors) {
        logger.info("[updatePassword] Called for email: {}", email);
        try {
            if (!isPasswordValid(password)) {
                errors.add("Password must be 8–20 characters, include upper, lower, digit, special char");
            }
            if (!errors.isEmpty()) {
                return false;
            }
            UserEntity user = userRepository.findByEmailId(email);
            if (user == null) {
                errors.add("No user found for this email.");
                logger.warn("[updatePassword] No user found");
                return false;
            }
            String encodedPassword = passwordEncoder.encode(password);
            user.setPassword(encodedPassword);
            boolean updated = userRepository.updateUser(user);
            logger.info("[updatePassword] Password updated: {}", updated);
            return updated;
        } catch (Exception e) {
            e.printStackTrace();
            errors.add("Exception occurred while updating password: " + e.getMessage());
            logger.error("[updatePassword] Exception for email: {}", email, e);
            return false;
        }
    }

    @Override
    public boolean clearExpiredOtps() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime tenMinutesAgo = now.minusMinutes(10);
        logger.info("[clearExpiredOtps] Checking expired OTPs older than 10 min");
        List<UserEntity> expiredOtps = userRepository.findByOtpNotNullAndOtpCreatedAtBefore(tenMinutesAgo);
        logger.info("[clearExpiredOtps] Found {} expired OTPs", expiredOtps.size());
        boolean anyCleared = false;
        for (UserEntity user : expiredOtps) {
            logger.info("[clearExpiredOtps] Clearing OTP for user: {}", user.getEmailId());
            user.setOtp(null);
            user.setOtpCreatedAt(null);
            boolean updated = userRepository.updateUser(user);
            if (updated) anyCleared = true;
        }
        return anyCleared;
    }

    @Override
    public boolean updateUserProfile(UserDto userDto) {
        try {
            // Check email uniqueness
            UserEntity existingEmail = userRepository.findByEmailId(userDto.getEmailId());
            if (existingEmail != null && existingEmail.getUserId() != userDto.getUserId()) {
                logger.warn("[updateUserProfile] Email already exists for another user: {}", userDto.getEmailId());
                return false;
            }

            // Check contact uniqueness
            UserEntity existingContact = userRepository.findByContact(userDto.getContact());
            if (existingContact != null && existingContact.getUserId() != userDto.getUserId()) {
                logger.warn("[updateUserProfile] Contact already exists for another user: {}", userDto.getContact());
                return false;
            }

            // Find user to update
            UserEntity user = userRepository.findByEmailId(userDto.getEmailId());
            if (user == null) {
                logger.warn("[updateUserProfile] No user found for update: {}", userDto.getUserId());
                return false;
            }

            // Update fields
            user.setFirstName(userDto.getFirstName());
            user.setLastName(userDto.getLastName());
            user.setGender(userDto.getGender());
            user.setDateOfBirth(userDto.getDateOfBirth());
            user.setContact(userDto.getContact());
            user.setCountry(userDto.getCountry());
            user.setState(userDto.getState());
            user.setCity(userDto.getCity());
            user.setPincode(userDto.getPincode());

            // --- Handle profile image ---
            MultipartFile profileImageFile = userDto.getProfileImage();
            if (profileImageFile != null && !profileImageFile.isEmpty()) {
                // Generate unique file name
                String originalFilename = profileImageFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String newFileName = "profile_" + user.getUserId() + "_" + System.currentTimeMillis() + extension;

                // Save file to server folder (adjust path as needed)
                Path uploadPath = Paths.get("D:/xworks_programs/projectModels/kick-start-sports/src/main/webapp/images");
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                Path filePath = uploadPath.resolve(newFileName);
                profileImageFile.transferTo(filePath.toFile());

                // Save file name in DB
                user.setProfileName(newFileName);
            }

            return userRepository.updateUser(user);
        } catch (Exception e) {
            logger.error("[updateUserProfile] Exception for userId: {}", userDto.getUserId(), e);
            return false;
        }
    }
}
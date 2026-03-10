package com.xwworkz.sports.controller;

import com.xwworkz.sports.dto.UserDto;
import com.xwworkz.sports.dto.UserLoginDto;
import com.xwworkz.sports.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/")
public class UserController {


    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    //  Page Endpoints
    @GetMapping("homePage")
    public String homePage() {
        logger.info("Loading home page");
        return "index";
    }

    @GetMapping("userRegistrationPage")
    public String userRegisterPage() {
        logger.info("Loading user registration page");
        return "userRegister";
    }

    @GetMapping("loginPage")
    public String loginPage() {
        logger.info("Loading login page");
        return "login";
    }

    @GetMapping("forgotPasswordPage")
    public String forgotPasswordPage() {
        logger.info("Loading forgot password page");
        return "forgotPassword";
    }

    @GetMapping("storePage")
    public String storePage(@RequestParam(value = "email", required = false) String email, Model model) {
        logger.info("Accessing store page for email: {}", email);
        if (email != null && !email.isEmpty()) {
            UserDto user = userService.findByEmailId(email);
            if (user != null) {
                logger.debug("User found: {}", user.getFirstName());
                model.addAttribute("firstName", user.getFirstName());
                model.addAttribute("user", user);
            }
        }
        return "store";
    }

    // Load Profile Page
    @GetMapping("profilePage")
    public String profilePage(@RequestParam(value = "email", required = false) String email, Model model) {
        logger.info("Loading profile page for email: {}", email);
        UserDto user = null;
        if (email != null && !email.isEmpty()) {
            user = userService.findByEmailId(email);
        }
        if (user == null) {
            logger.warn("No user found for email: {}, creating empty UserDto", email);
            user = new UserDto();
        }
        model.addAttribute("userDto", user);
        return "profile";
    }

    // Update Profile
    @PostMapping("updateProfile")
    public String updateProfile(@ModelAttribute @Valid UserDto userDto,
                                BindingResult bindingResult, Model model) {
        logger.info("Updating profile for email: {}", userDto.getEmailId());

        // Handle validation errors
        if (bindingResult.hasErrors()) {
            logger.warn("Validation errors while updating profile for email: {}", userDto.getEmailId());
            bindingResult.getFieldErrors().forEach(error -> {
                model.addAttribute(error.getField() + "Error", error.getDefaultMessage());
                logger.debug("Validation error on field {}: {}", error.getField(), error.getDefaultMessage());
            });
            model.addAttribute("userDto", userDto);
            return "profile";
        }

        boolean updated = userService.updateUserProfile(userDto);
        if (updated) {
            logger.info("Profile updated successfully for email: {}", userDto.getEmailId());

            // Reload user to get updated profileName for image display
            UserDto updatedUser = userService.findByEmailId(userDto.getEmailId());
            if (updatedUser != null) {
                model.addAttribute("userDto", updatedUser);
            }
            // Redirect to profilePage with email after successful update
            return "redirect:/profilePage?email=" + userDto.getEmailId();
        } else {
            logger.error("Failed to update profile for email: {}", userDto.getEmailId());
            model.addAttribute("error", "Failed to update profile. Please try again.");
            // Reload user details for error case
            UserDto updatedUser = userService.findByEmailId(userDto.getEmailId());
            if (updatedUser != null) {
                model.addAttribute("userDto", updatedUser);
            }
            return "profile";
        }
    }

    // All errors
    public List<String> getErrorMessages(BindingResult bindingResult) {
        List<String> errors = new ArrayList<>();
        bindingResult.getAllErrors().forEach(error -> errors.add(error.getDefaultMessage()));
        return errors;
    }

    // Registration
    @PostMapping("register")
    public String registerUser(@Valid UserDto userDto, BindingResult bindingResult, Model model) {
        logger.info("Registering new user with email: {}", userDto.getEmailId());

        if (bindingResult.hasErrors()) {
            logger.warn("Validation errors during user registration for email: {}", userDto.getEmailId());

            List<String> errors = getErrorMessages(bindingResult);
            model.addAttribute("errors", errors);
            return "userRegister";
        }
        List<String> serviceErrors = new ArrayList<>();
        boolean registered = userService.createUser(userDto, serviceErrors);
        model.addAttribute("errors", serviceErrors);
        if (registered) {
            logger.info("User registered successfully with email: {}", userDto.getEmailId());
            return "redirect:/loginPage";
        } else {
            logger.error("User registration failed for email: {}", userDto.getEmailId());
            return "userRegister";
        }
    }

    // Check if contact exists
    @GetMapping("checkContact")
    @ResponseBody
    public Map<String, String> checkContact(@RequestParam("contact") String contact) {
        logger.info("Checking if contact exists: {}", contact);

        Map<String, String> response = new HashMap<>();
        if (contact == null || contact.trim().isEmpty()) {
            response.put("status", "INVALID");
        } else {
            try {
                boolean exists = userService.findByContact(contact.trim()) != null;
                response.put("status", exists ? "EXISTS" : "AVAILABLE");
                logger.debug("Contact {} status: {}", contact, response.get("status"));
            } catch (Exception e) {
                logger.error("Error during contact check for {}: {}", contact, e.getMessage(), e);
                response.put("status", "ERROR");
            }
        }
        return response;
    }

    // Check if email exists
    @GetMapping("checkEmailID")
    @ResponseBody
    public Map<String, String> checkEmailID(@RequestParam("emailId") String emailId) {
        logger.info("Checking if email exists: {}", emailId);

        Map<String, String> response = new HashMap<>();
        if (emailId == null || emailId.trim().isEmpty()) {
            response.put("status", "INVALID");
        } else {
            try {
                boolean exists = userService.findByEmailId(emailId.trim()) != null;
                response.put("status", exists ? "EXISTS" : "AVAILABLE");
                logger.debug("Email {} status: {}", emailId, response.get("status"));
            } catch (Exception e) {
                logger.error("Error during email check for {}: {}", emailId, e.getMessage(), e);
                response.put("status", "ERROR");
            }
        }
        return response;
    }

    // Check if user exists by email or contact
    @GetMapping("checkUserExist")
    @ResponseBody
    public Map<String, String> checkUserExist(@RequestParam("emailOrContact") String emailOrContact) {
        logger.info("Checking if user exists by email/contact: {}", emailOrContact);
        Map<String, String> response = new HashMap<>();
        if (emailOrContact == null || emailOrContact.trim().isEmpty()) {
            response.put("status", "INVALID");
        } else {
            try {
                UserDto user = userService.findByEmailOrContact(emailOrContact.trim());
                response.put("status", user != null ? "FOUND" : "NOT_FOUND");
                logger.debug("User existence status for {}: {}", emailOrContact, response.get("status"));
            } catch (Exception e) {
                logger.error("Error during user existence check for {}: {}", emailOrContact, e.getMessage(), e);
                response.put("status", "ERROR");
            }
        }
        return response;
    }

    // Login
    @PostMapping("loginUser")
    public String loginUser(@RequestParam("emailOrContact") String emailOrContact,
                            @RequestParam("password") String password) {
        logger.info("Attempting login for: {}", emailOrContact);

        UserDto userDto = userService.findByEmailOrContact(emailOrContact != null ? emailOrContact.trim() : null);

        if (userDto == null) {
            logger.warn("Login failed: user not found for {}", emailOrContact);
            return "redirect:/loginPage?error=USER_NOT_FOUND&emailOrContact=" + emailOrContact;
        }

        UserLoginDto loginDto = new UserLoginDto();
        loginDto.setEmailOrContact(emailOrContact);
        loginDto.setPassword(userDto.getPassword());

        if (!userService.checkPassword(loginDto, password)) {
            logger.warn("Login failed: invalid password for {}", emailOrContact);
            return "redirect:/loginPage?error=INVALID_PASSWORD&emailOrContact=" + emailOrContact;
        }

        userService.userLogin(loginDto);
        logger.info("Login successful for {}", emailOrContact);


        // Redirect to storePage with email as query parameter
        return "redirect:/storePage?email=" + userDto.getEmailId();
    }

    // Check Password
    @PostMapping("checkPassword")
    @ResponseBody
    public Map<String, String> checkPassword(@RequestParam("emailOrContact") String emailOrContact,
                                             @RequestParam("password") String password) {
        logger.info("Checking password for: {}", emailOrContact);

        Map<String, String> response = new HashMap<>();
        UserDto userDto = userService.findByEmailOrContact(emailOrContact);
        if (userDto == null) {
            response.put("status", "USER_NOT_FOUND");
        } else {
            UserLoginDto loginDto = new UserLoginDto();
            loginDto.setEmailOrContact(emailOrContact);
            loginDto.setPassword(userDto.getPassword());
            loginDto.setLocalDate(java.time.LocalDate.now());
            loginDto.setLocalTime(java.time.LocalTime.now());
            if (!userService.checkPassword(loginDto, password)) {
                response.put("status", "INVALID_PASSWORD");
            } else {
                response.put("status", "SUCCESS");
            }
        }

        logger.debug("Password check result for {}: {}", emailOrContact, response.get("status"));
        return response;
    }

    // Email check for Forgot Password
    @PostMapping("forgotPassword/checkEmail")
    @ResponseBody
    public Map<String, String> checkForgotEmail(@RequestParam("email") String email) {
        logger.info("Checking forgot password email: {}", email);

        Map<String, String> response = new HashMap<>();
        if (email == null || email.trim().isEmpty()) {
            response.put("status", "INVALID");
        } else {
            boolean exists = userService.findByEmailId(email.trim()) != null;
            response.put("status", exists ? "FOUND" : "NOT_FOUND");
        }
        logger.debug("Forgot password email {} status: {}", email, response.get("status"));
        return response;
    }

    // redirect forgot password
    @GetMapping("/forgotPassword")
    public String showForgotPasswordPage(@RequestParam(required = false) String email, Model model) {
        logger.info("Loading forgot password page with email: {}", email);
        model.addAttribute("email", email);
        return "forgotPassword";
    }

    // Send OTP
    @PostMapping("sendOtp")
    public String sendOtp(@RequestParam("email") String email, Model model) {
        logger.info("Sending OTP to email: {}", email);
        List<String> serviceErrors = new ArrayList<>();
        if (email == null || email.trim().isEmpty()) {
            serviceErrors.add("Email is required.");
            model.addAttribute("errors", serviceErrors);
            return "forgotPassword";
        }

        boolean otpSent = userService.sendOtpToEmail(email.trim());
        if (!otpSent) {
            logger.error("Failed to send OTP to email: {}", email);
            serviceErrors.add("Failed to send OTP. Please check the email and try again.");
            model.addAttribute("errors", serviceErrors);
            return "forgotPassword";
        }

        logger.info("OTP sent successfully to email: {}", email);
        model.addAttribute("email", email.trim());
        return "redirect:/forgotPassword?email=" + email.trim();
    }

    // verify otp
    @PostMapping("verifyOtp")
    public String verifyOtp(@RequestParam("email") String email,
                            @RequestParam("otp") String otp,
                            Model model) {

        logger.info("Verifying OTP for email: {}", email);
        boolean validOtp = userService.verifyOtp(email, otp);

        if (!validOtp) {
            logger.warn("Invalid OTP attempt for email: {}", email);
            model.addAttribute("otpError", "Invalid OTP. Please try again.");
            model.addAttribute("email", email);
            model.addAttribute("showOtpForm", true);
            return "forgotPassword";
        }

        logger.info("OTP verified successfully for email: {}", email);
        return "redirect:/resetPasswordPage?email=" + email;
    }

    //  Reset Password Page
    @GetMapping("resetPasswordPage")
    public String showResetPasswordPage(@RequestParam String email, Model model) {
        logger.info("Loading reset password page for email: {}", email);
        model.addAttribute("email", email);
        model.addAttribute("error", null);
        return "resetPassword";
    }

    // New Password Submission
    @PostMapping("updatePassword")
    public String resetPassword(@RequestParam("email") String email,
                                @RequestParam("password") String password,
                                @RequestParam("confirmPassword") String confirmPassword,
                                Model model) {
        logger.info("Updating password for email: {}", email);
        List<String> errors = new ArrayList<>();
        if (!password.equals(confirmPassword)) {
            logger.warn("Password mismatch for email: {}", email);
            errors.add("Passwords do not match");
        }
        boolean updated = userService.updatePassword(email, password, errors);
        model.addAttribute("errors", errors);
        model.addAttribute("email", email);
        if (!updated) {
            logger.error("Failed to update password for email: {}", email);
            return "resetPassword";
        }
        logger.info("Password updated successfully for email: {}", email);
        return "redirect:/loginPage?reset=SUCCESS";
    }
}
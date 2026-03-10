<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Reset Password - KickStart</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<style>
body {
    min-height: 100vh;
    background: url("https://i.pinimg.com/736x/b6/fe/fd/b6fefd27da22b48955e997a2e5e52180.jpg") no-repeat center center fixed;
    background-size: cover;
    padding-top: 100px;
    padding-bottom: 80px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: #fff;
    position: relative;
}
input[type="text"],
input[type="email"],
input[type="password"],
input[type="date"] {
    text-transform: none !important;
}
body::before { content: ""; position: fixed; top:0; left:0; right:0; bottom:0; background: rgba(0,0,0,0.65); z-index: -1; }
.navbar-custom, .footer-custom { background: linear-gradient(90deg, #000000, #8b0000); }
.navbar-custom .navbar-text, .footer-custom { color: #fff; }
.navbar-brand img { width: 65px; height: 65px; object-fit: cover; border-radius: 50%; border: 2px solid #fff; }
.card { background: rgba(0,0,0,0.85); border: 2px solid #8b0000; color: #fff; border-radius: 15px; padding: 30px; max-width: 500px; margin: auto; }
.form-label { color: #fff; font-weight: 600; }
    .form-control.is-invalid ~ .invalid-feedback { display: block; color:#dc3545; }
    .form-control.is-valid {
        border: 2px solid #28a745;
        box-shadow: 0 0 8px 1.5px #28a74599;
    }
.btn-classic { font-weight: 600; text-transform: uppercase; border-radius: 25px; border: 2px solid #fff; background-color: transparent; color: #fff; transition: all 0.3s ease; }
.btn-classic:hover { background-color: #8b0000; border-color: #8b0000; }
footer .datetime { position: absolute; right: 20px; bottom: 10px; font-size: 0.85rem; opacity: 0.9; }
</style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom fixed-top shadow-sm">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <a class="navbar-brand d-flex align-items-center" href="home">
            <img src="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" alt="Logo">
        </a>
        <span class="navbar-text fs-4 fw-bold mx-auto text-uppercase text-center">Kick Sports</span>
        <div class="d-flex">
            <a href="homePage" class="btn btn-light me-2">Home</a>
        </div>
    </div>
</nav>

<main class="container my-5">
    <div class="card shadow-lg">
        <h2 class="text-center mb-4 text-danger">Reset Password</h2>

        <p class="text-center mb-3">Resetting password for:
            <span class="fw-bold text-warning">${param.email}</span>
        </p>

        <form id="resetForm" method="post" action="updatePassword" novalidate>
            <input type="hidden" id="email" name="email" value="${param.email != null ? param.email : ''}">

            <div class="mb-3">
                <label class="form-label">New Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Enter new password" required>
                <div class="invalid-feedback" id="passwordError"></div>
            </div>

            <div class="mb-3">
                <label class="form-label">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm password" required>
                <div class="invalid-feedback" id="confirmPasswordError"></div>
            </div>

            <button type="submit" class="btn btn-classic w-100">Reset Password</button>
        </form>

        <p class="mt-3 text-center"><a href="loginPage" class="text-danger">Back to Login</a></p>
    </div>
    
</main>

<footer class="footer-custom text-white py-3 position-fixed bottom-0 w-100 shadow-sm">
    <div class="container text-center fw-semibold">&copy; 2025 Kick Sports</div>
    <div id="datetime" class="datetime"></div>
</footer>

<script>
// Elements
const resetForm = document.getElementById("resetForm");
const passwordInput = document.getElementById("password");
const confirmPasswordInput = document.getElementById("confirmPassword");
const emailInput = document.getElementById("email");
const passwordError = document.getElementById("passwordError");
const confirmPasswordError = document.getElementById("confirmPasswordError");
const resetBtn = document.querySelector('button[type="submit"]');

// Clear validation errors
function clearErrors() {
    passwordError.textContent = "";
    confirmPasswordError.textContent = "";
    passwordInput.classList.remove("is-invalid");
    confirmPasswordInput.classList.remove("is-invalid");
}

// Validate passwords
function validatePasswords() {
    clearErrors();
    let valid = true;
    if(passwordInput.value.length < 6) {
        passwordInput.classList.add("is-invalid");
        passwordError.textContent = "Password must be at least 6 characters";
        valid = false;
    }
    if(confirmPasswordInput.value !== passwordInput.value) {
        confirmPasswordInput.classList.add("is-invalid");
        confirmPasswordError.textContent = "Passwords do not match";
        valid = false;
    }
    return valid;
}

// Debounce input validation
function debounce(func, delay) {
    let timer;
    return function(...args){
        clearTimeout(timer);
        timer = setTimeout(()=>func.apply(this,args), delay);
    };
}

// Track if fields have been touched
let passwordTouched = false;
let confirmPasswordTouched = false;

passwordInput.addEventListener("blur", () => {
    passwordTouched = true;
    validatePassword();
});

confirmPasswordInput.addEventListener("blur", () => {
    confirmPasswordTouched = true;
    validateConfirmPassword();
});

passwordInput.addEventListener("input", () => {
    if(passwordTouched) validatePassword();
});

confirmPasswordInput.addEventListener("input", () => {
    if(confirmPasswordTouched) validateConfirmPassword();
});

// Initial state
updateButtonState();

// Track validity
let validationStatus = {
    password: false,
    confirmPassword: false
};

function updateButtonState() {
    resetBtn.disabled = !(validationStatus.password && validationStatus.confirmPassword);
}

function validatePassword() {
    const value = passwordInput.value.trim();
    // Pattern: 8-20 chars, at least 1 digit, 1 lowercase, 1 uppercase, 1 special char
    const pattern = /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!]).{8,20}$/;
    if (!pattern.test(value)) {
        passwordInput.classList.remove("is-valid");
        passwordInput.classList.add("is-invalid");
        passwordError.textContent = "Password must be 820 characters long, include at least one digit, one lowercase letter, one uppercase letter, and one special character";
        validationStatus.password = false;
    } else {
        passwordInput.classList.remove("is-invalid");
        passwordInput.classList.add("is-valid");
        passwordError.textContent = "";
        validationStatus.password = true;
    }
    validateConfirmPassword(); // Always re-validate confirm
    updateButtonState();
}

function validateConfirmPassword() {
    const value = confirmPasswordInput.value.trim();
    if (value !== passwordInput.value.trim()) {
        confirmPasswordInput.classList.remove("is-valid");
        confirmPasswordInput.classList.add("is-invalid");
        confirmPasswordError.textContent = "Passwords do not match";
        validationStatus.confirmPassword = false;
    } else if (value.length === 0) {
        confirmPasswordInput.classList.remove("is-invalid");
        confirmPasswordInput.classList.remove("is-valid");
        confirmPasswordError.textContent = "";
        validationStatus.confirmPassword = false;
    } else {
        confirmPasswordInput.classList.remove("is-invalid");
        confirmPasswordInput.classList.add("is-valid");
        confirmPasswordError.textContent = "";
        validationStatus.confirmPassword = true;
    }
    updateButtonState();
}

passwordInput.addEventListener("input", validatePassword);
confirmPasswordInput.addEventListener("input", validateConfirmPassword);

// Footer datetime
function updateDateTime() {
    const now = new Date();
    const opts = {year:'numeric', month:'short', day:'numeric', hour:'2-digit', minute:'2-digit', second:'2-digit'};
    document.getElementById("datetime").innerText = now.toLocaleString("en-US", opts);
}
setInterval(updateDateTime,1000);
window.onload = updateDateTime;
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

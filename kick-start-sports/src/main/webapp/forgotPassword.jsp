<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Forgot Password - KickStart</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<style>
body { min-height: 100vh; background: url("https://i.pinimg.com/736x/b6/fe/fd/b6fefd27da22b48955e997a2e5e52180.jpg") no-repeat center center fixed; background-size: cover; padding-top: 100px; padding-bottom: 80px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #fff; position: relative; }
body::before { content: ""; position: fixed; top:0; left:0; right:0; bottom:0; background: rgba(0,0,0,0.65); z-index: -1; }
.navbar-custom, .footer-custom { background: linear-gradient(90deg, #000000, #8b0000); }
.navbar-custom .navbar-text, .footer-custom { color: #fff; }
.navbar-brand img { width: 65px; height: 65px; object-fit: cover; border-radius: 50%; border: 2px solid #fff; }
.card { background: rgba(0,0,0,0.85); border: 2px solid #8b0000; color: #fff; border-radius: 15px; padding: 30px; max-width: 420px; margin: auto; }
.form-label { color: #fff; font-weight: 600; }
.form-control.is-invalid ~ .invalid-feedback { display: block; color:#dc3545; }
.form-control.is-valid {
    border: 2px solid #28a745;
    box-shadow: 0 0 8px 1.5px #28a74599;
}
.btn-classic { font-weight: 600; text-transform: uppercase; border-radius: 25px; border: 2px solid #fff; background-color: transparent; color: #fff; transition: all 0.3s ease; }
.btn-classic:hover { background-color: #8b0000; border-color: #8b0000; }
footer .datetime { position: absolute; right: 20px; bottom: 10px; font-size: 0.85rem; opacity: 0.9; }
.otp-container { display: flex; justify-content: space-between; gap: 10px; }
    .otp-box { width: 60px; height: 60px; font-size: 1.8rem; text-align: center; border-radius: 10px; border: 2px solid #fff; background: rgba(255,255,255,0.1); color: #fff; text-transform: none !important; }
.otp-box.is-invalid { border-color: #dc3545; }
.otp-box.is-valid { border-color: #28a745; }
</style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom fixed-top shadow-sm">
    <div class="container-fluid d-flex justify-content-between align-items-center">
    <a class="navbar-brand d-flex align-items-center" href="homePage">
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
        <h2 class="text-center mb-4 text-danger">Forgot Password</h2>

        <!-- Email Form -->
        <form id="emailForm" novalidate>
            <div class="mb-3">
                <label class="form-label">Registered Email</label>
                <input type="email" id="emailInput" class="form-control"
                       name="email"
                       value="${param.email != null ? param.email : (email != null ? email : '')}"
                       placeholder="Enter your email" required
                       ${showOtpForm == true ? 'disabled' : ''}>
                <div class="invalid-feedback" id="emailError">${not empty errors ? errors[0] : ''}</div>
            </div>
            <button type="button" id="sendOtpBtn" class="btn btn-classic w-100" ${showOtpForm == true ? 'disabled' : ''}>Send OTP</button>
        </form>

        <!-- OTP Form -->
        <c:set var="otpDisplay" value="${showOtpForm == true ? 'block' : 'none'}"/>
        <form id="otpForm" action="verifyOtp" method="post" class="mt-4"
            <c:if test="${showOtpForm == true}">style="display: block;"</c:if><c:if test="${showOtpForm != true}">style="display: none;"</c:if>
            novalidate>
                        <input type="hidden" name="email" id="otpEmail" value="${param.email != null ? param.email : (email != null ? email : '')}">

            <div class="mb-3">
                <label class="form-label">Enter OTP</label>
                <div class="otp-container">
                    <input type="password" name="otp1" maxlength="1" class="otp-box" required>
                    <input type="password" name="otp2" maxlength="1" class="otp-box" required>
                    <input type="password" name="otp3" maxlength="1" class="otp-box" required>
                    <input type="password" name="otp4" maxlength="1" class="otp-box" required>
                </div>
                <c:if test="${not empty otpError}">
                    <div class="invalid-feedback" style="display:block">${otpError}</div>
                </c:if>
            </div>
            <button type="submit" class="btn btn-classic w-100">Verify OTP</button>
        </form>

        <p class="mt-3 text-center"><a href="loginPage" class="text-danger">Back to Login</a></p>
    </div>
</main>

<footer class="footer-custom text-white py-3 position-fixed bottom-0 w-100 shadow-sm">
    <div class="container text-center fw-semibold">&copy; 2025 Kick Sports</div>
    <div id="datetime" class="datetime"></div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
// Elements
const emailInput = document.getElementById("emailInput");
const sendOtpBtn = document.getElementById("sendOtpBtn");
const emailError = document.getElementById("emailError");
const otpForm = document.getElementById("otpForm");
const otpEmail = document.getElementById("otpEmail");

// Debounce for email validation
function debounce(func, delay) {
    let timer;
    return function(...args){
        clearTimeout(timer);
        timer = setTimeout(() => func.apply(this, args), delay);
    };
}

// Live email validation
async function validateEmail() {
    const email = emailInput.value.trim();
    if(!email.match(/^[^@\s]+@[^@\s]+\.[^@\s]+$/)){
        emailInput.classList.remove("is-valid");
        emailInput.classList.add("is-invalid");
        emailError.textContent = "Enter a valid email address.";
        sendOtpBtn.disabled = true;
        return;
    }
    try {
        const params = new URLSearchParams();
        params.append("email", email);
        const resp = await axios.post("forgotPassword/checkEmail", params.toString(), {
            headers: {"Content-Type":"application/x-www-form-urlencoded"}
        });
        if(resp.data.status === "FOUND"){
            emailInput.classList.remove("is-invalid");
            emailInput.classList.add("is-valid");
            emailError.textContent = "";
            sendOtpBtn.disabled = false;
        } else {
            emailInput.classList.remove("is-valid");
            emailInput.classList.add("is-invalid");
            emailError.textContent = "Email not found.";
            sendOtpBtn.disabled = true;
        }
    } catch(e){ console.error(e); }
}
emailInput.addEventListener("input", debounce(validateEmail, 300));

// Send OTP
sendOtpBtn.addEventListener("click", async () => {
    const email = emailInput.value.trim();
    try {
        const params = new URLSearchParams();
        params.append("email", email);
        await axios.post("sendOtp", params.toString(), { headers: {"Content-Type": "application/x-www-form-urlencoded"} });

        // Disable email input and button
        emailInput.disabled = true;
        sendOtpBtn.disabled = true;

        // Show OTP form
        otpForm.style.display = "block";

        // Set hidden email dynamically
        otpEmail.value = email;
    } catch(e) {
        console.error(e);
        emailInput.classList.add("is-invalid");
        emailError.textContent = "Failed to send OTP. Please try again.";
    }
});

// OTP input auto-focus
const otpBoxes = document.querySelectorAll(".otp-box");
otpBoxes.forEach((box, index) => {
    box.addEventListener("input", () => {
        if(box.value.length === 1 && index < otpBoxes.length -1) otpBoxes[index+1].focus();
    });
    box.addEventListener("keydown", (e) => {
        if(e.key === "Backspace" && !box.value && index>0) otpBoxes[index-1].focus();
    });
});

// Combine OTP and set hidden email on submit
otpForm.addEventListener("submit", () => {
    const otpValue = Array.from(otpBoxes).map(box => box.value).join("");
    const existingOtpInput = otpForm.querySelector("input[name='otp']");
    if(existingOtpInput) existingOtpInput.remove();
    const hiddenOtp = document.createElement("input");
    hiddenOtp.type = "hidden";
    hiddenOtp.name = "otp";
    hiddenOtp.value = otpValue;
    otpForm.appendChild(hiddenOtp);

    // Hidden email already set dynamically
});

// Footer datetime
function updateDateTime(){
    const now = new Date();
    const opts={year:'numeric', month:'short', day:'numeric', hour:'2-digit', minute:'2-digit', second:'2-digit'};
    document.getElementById("datetime").innerText=now.toLocaleString("en-US",opts);
}
setInterval(updateDateTime,1000);
updateDateTime();
</script>
</body>
</html>

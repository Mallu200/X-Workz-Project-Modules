<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>

<%
    String emailPrefill = request.getParameter("emailOrContact") != null ? request.getParameter("emailOrContact") : "";
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Login - KickStart</title>
    <link rel="icon" href="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" type="image/jpg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <style>
        body { min-height:100vh; background:url("https://i.pinimg.com/736x/b6/fe/fd/b6fefd27da22b48955e997a2e5e52180.jpg") no-repeat center center fixed; background-size:cover; padding-top:100px; padding-bottom:80px; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color:#fff; position:relative;}
        body::before { content:""; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.65); z-index:-1;}
        .navbar-custom,.footer-custom{background:linear-gradient(90deg,#000,#8b0000);}
        .navbar-custom .navbar-text,.footer-custom{color:#fff;}
        .navbar-brand img{width:65px;height:65px;object-fit:cover;border-radius:50%;border:2px solid #fff;}
        .card{background:rgba(0,0,0,0.85);border:2px solid #8b0000;color:#fff;border-radius:15px;}
        .form-label{color:#fff;font-weight:600;}
    .form-control.is-invalid{border:1px solid #dc3545;}
    .form-control { text-transform: none !important; }
        .invalid-feedback{font-size:.875rem;color:#dc3545;display:block;}
        .btn-classic{font-weight:600;text-transform:uppercase;border-radius:25px;border:2px solid #fff;background-color:transparent;color:#fff;transition:all 0.3s ease;}
        .btn-classic:hover{background-color:#8b0000;border-color:#8b0000;}
        .btn-classic:disabled{opacity:.5;cursor:not-allowed;}
        footer .datetime{position:absolute;right:20px;bottom:10px;font-size:.85rem;opacity:.9;}
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
    <div class="card shadow-lg p-4 mx-auto" style="max-width:400px;">
        <h2 class="text-center mb-4 text-danger">User Login</h2>

        <form id="loginForm" method="post" action="loginUser" novalidate>
            <!-- Email / Contact -->
            <div class="mb-3">
                <label class="form-label">Email or Contact</label>
                <input type="text" name="emailOrContact" id="emailOrContact"
                       value="<%= emailPrefill %>"
                       class="form-control"
                       placeholder="Enter email or contact" required>
                <div class="invalid-feedback" id="emailError"></div>
            </div>

            <!-- Password -->
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" id="password" class="form-control" placeholder="Enter password" required>
                <div class="invalid-feedback" id="passwordError"></div>
            </div>

            <button type="submit" class="btn btn-classic w-100" id="loginButton">Login</button>
            <a href="forgotPasswordPage" class="text-white mt-2 d-block">Forgot Password?</a>
        </form>

        <p class="mt-3 text-center text-white">Don't have an account? <a href="userRegistrationPage" class="text-danger">Register here</a></p>
    </div>
</main>

<footer class="footer-custom text-white py-3 position-fixed bottom-0 w-100 shadow-sm">
    <div class="container text-center fw-semibold">&copy; 2025 Kick Sports</div>
    <div id="datetime" class="datetime"></div>
</footer>

<script>
const loginForm = document.getElementById("loginForm");
const emailInput = document.getElementById("emailOrContact");
const passwordInput = document.getElementById("password");
const emailErrorDiv = document.getElementById("emailError");
const passwordErrorDiv = document.getElementById("passwordError");
const loginButton = document.getElementById("loginButton");

// Enable/disable login button
function checkFormValidity() {
    loginButton.disabled = !(emailInput.value.trim() && passwordInput.value.trim());
}
emailInput.addEventListener("input", checkFormValidity);
passwordInput.addEventListener("input", checkFormValidity);
checkFormValidity();

// Live email check via axios
function debounce(func, delay) {
    let timer;
    return function(...args){
        clearTimeout(timer);
        timer = setTimeout(()=>func.apply(this,args), delay);
    }
}

async function checkUserExists() {
    const value = emailInput.value.trim();
    if(!value){
        emailInput.classList.remove("is-invalid");
        emailErrorDiv.textContent="";
        return;
    }
    try{
        const response = await axios.get("checkUserExist", { params: { emailOrContact: value } });
        if(response.data.status === "NOT_FOUND"){
            emailInput.classList.add("is-invalid");
            emailErrorDiv.textContent = "User not found";
        } else {
            emailInput.classList.remove("is-invalid");
            emailErrorDiv.textContent="";
        }
    } catch(err){
        console.error("Error checking user:",err);
    }
}
emailInput.addEventListener("input", debounce(checkUserExists,500));
emailInput.addEventListener("blur", checkUserExists);

// Submit-only password check
loginForm.addEventListener("submit", async function(e){
    e.preventDefault();
    emailInput.classList.remove("is-invalid");
    passwordInput.classList.remove("is-invalid");
    emailErrorDiv.textContent="";
    passwordErrorDiv.textContent="";

    const emailOrContact = emailInput.value.trim();
    const password = passwordInput.value.trim();
    if(!emailOrContact || !password) return;

    try{
        const params = new URLSearchParams();
        params.append("emailOrContact", emailOrContact);
        params.append("password", password);

        const response = await axios.post("checkPassword", params, { headers: { "Content-Type":"application/x-www-form-urlencoded" }});
        const status = response.data.status;

        if(status==="USER_NOT_FOUND"){
            emailInput.classList.add("is-invalid");
            emailErrorDiv.textContent="User not found";
            passwordInput.value="";
        } else if(status==="INVALID_PASSWORD"){
            passwordInput.classList.add("is-invalid");
            passwordErrorDiv.textContent="Invalid password";
            passwordInput.value="";
        } else if(status==="SUCCESS"){
            loginButton.disabled = true; // Prevent double submit
            loginForm.submit(); // Correct password → submit to loginUser
        }
    }catch(err){
        console.error("Login check failed:",err);
        alert("Something went wrong. Please try again.");
    }
});

// Footer datetime
function updateDateTime(){
    const now = new Date();
    const options={year:'numeric',month:'short',day:'numeric',hour:'2-digit',minute:'2-digit',second:'2-digit'};
    document.getElementById("datetime").innerText = now.toLocaleString("en-US", options);
}
setInterval(updateDateTime,1000);
window.onload=updateDateTime;
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

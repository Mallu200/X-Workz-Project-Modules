<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Registration - KickStart</title>
    <link rel="icon" href="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" type="image/jpg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <style>
    /* Your existing CSS here */
        body {
            min-height: 100vh;
            background: url("https://i.pinimg.com/736x/b6/fe/fd/b6fefd27da22b48955e997a2e5e52180.jpg") no-repeat center center fixed;
            background-size: cover;
            padding-top: 90px;
            padding-bottom: 70px;
        }

        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            z-index: -1;
        }

        .navbar-custom, .footer-custom {
            background: linear-gradient(90deg, #000000, #8b0000);
        }

        .navbar-custom .navbar-text, .footer-custom {
            color: #fff;
        }

        .navbar-brand img {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            border: 2px solid #fff;
        }

        .form-label {
            color: #fff;
            font-weight: 600;
        }

        .form-control.is-invalid {
            border: 1px solid #dc3545;
        }

        .form-control.is-valid {
            border: 2px solid #28a745;
            box-shadow: 0 0 8px 1.5px #28a74599;
        }

        .invalid-feedback {
            font-size: 0.875rem;
            color: #dc3545;
            display: none;
        }

        .form-check-label {
            color: #fff;
        }

        footer .datetime {
            position: absolute;
            right: 20px;
            bottom: 10px;
            font-size: 0.85rem;
        }

        .card {
            background: rgba(0, 0, 0, 0.85);
            border: 2px solid #8b0000;
            color: #fff;
            border-radius: 15px;
        }

        .btn-classic {
            font-weight: 600;
            text-transform: none;
            letter-spacing: 0.5px;
            padding: 8px 20px;
            border-radius: 25px;
            border: 2px solid #fff;
            background-color: transparent;
            color: #fff;
        }

        .btn-classic:hover {
            background-color: #8b0000;
            border-color: #8b0000;
            color: #fff;
        }

       input[type="text"],
       input[type="email"],
       input[type="password"],
       input[type="date"] {
           text-transform: none !important;
       }

       input::placeholder {
           text-transform: none !important;
       }

    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-custom fixed-top shadow-sm">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a class="navbar-brand" href="homePage">
                <img src="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" alt="Logo">
            </a>
            <span class="navbar-text fs-4 fw-bold mx-auto">KickStart Sports</span>
            <div class="d-flex">
                <a href="homePage" class="btn btn-light me-2">Home</a>
                <a href="loginPage" class="btn btn-light">User Login</a>
            </div>
        </div>
    </nav>
    <main class="container my-5">
        <div class="card shadow-lg p-4 mx-auto" style="max-width:700px;">
            <section class="container">
                <c:if test="${not empty errors}">
                    <div class="alert alert-danger">
                        <ul>
                            <c:forEach var="error" items="${errors}">
                                <li>${error}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>
            </section>
            <h2 class="text-center mb-4 text-danger">User Registration</h2>
            <form id="registerForm" action="register" method="post" novalidate>
                <div class="row mb-3">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">First Name</label>
                        <input type="text" name="firstName" class="form-control" placeholder="Enter First Name" required>
                        <div class="invalid-feedback">1–50 letters, spaces, hyphens or apostrophes allowed</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Last Name</label>
                        <input type="text" name="lastName" class="form-control" placeholder="Enter Last Name" required>
                        <div class="invalid-feedback">1–50 letters, spaces, hyphens or apostrophes allowed</div>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label d-block">Gender</label>
                    <div class="d-flex gap-4">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="gender" value="Male" required>
                            <label class="form-check-label">Male</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="gender" value="Female" required>
                            <label class="form-check-label">Female</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="gender" value="Other" required>
                            <label class="form-check-label">Other</label>
                        </div>
                    </div>
                    <div class="invalid-feedback">Gender required</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" name="dateOfBirth" class="form-control" required>
                    <div class="invalid-feedback">Date of birth required</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Contact Number</label>
                    <input type="text" name="contact" id="contact" class="form-control" placeholder="Enter Contact Number" required>
                    <div class="invalid-feedback">10–15 digits required / already registered</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="emailId" id="emailId" class="form-control" placeholder="Enter Email-ID" required>
                    <div class="invalid-feedback">Invalid email / already registered</div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Country</label>
                        <input type="text" name="country" class="form-control" placeholder="Enter Country" required>
                        <div class="invalid-feedback">Required</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">State</label>
                        <input type="text" name="state" class="form-control" placeholder="Enter State" required>
                        <div class="invalid-feedback">Required</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">City</label>
                        <input type="text" name="city" class="form-control" placeholder="Enter City" required>
                        <div class="invalid-feedback">Required</div>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Pincode</label>
                    <input type="text" name="pincode" class="form-control" placeholder="Enter Pincode" required>
                    <div class="invalid-feedback">5–10 digits required</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" id="password" class="form-control" placeholder="Enter Password" required>
                    <div class="invalid-feedback">8–20 chars, upper/lower/digit/special</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Confirm Password</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Re-Enter Password" required>
                    <div class="invalid-feedback">Passwords must match</div>
                </div>
                <button type="submit" id="registerBtn" class="btn btn-classic w-100" disabled>Register</button>
            </form>
        </div>
    </main>
    <footer class="footer-custom text-white py-3 position-fixed bottom-0 w-100 shadow-sm">
        <div class="container text-center fw-semibold">&copy; 2025 KickStart Sports</div>
        <div id="datetime" class="datetime"></div>
    </footer>
<script>
    const form = document.getElementById("registerForm");
    const registerBtn = document.getElementById("registerBtn");

    const patterns = {
        contact: /^[0-9]{10,15}$/,
        email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        pincode: /^[0-9]{5,10}$/,
        password: /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!]).{8,20}$/
    };

    function showError(input, message) {
    const feedback = input.nextElementSibling;
    input.classList.remove("is-valid");
    input.classList.add("is-invalid");
    feedback.style.display = "block";
    feedback.textContent = message;
    }

    function hideError(input) {
    const feedback = input.nextElementSibling;
    input.classList.remove("is-invalid");
    input.classList.add("is-valid");
    feedback.style.display = "none";
    }

    // Object to track the validity of all fields
    let validationStatus = {
        firstName: false,
        lastName: false,
        gender: false,
        dateOfBirth: false,
        contact: false,
        emailId: false,
        country: false,
        state: false,
        city: false,
        pincode: false,
        password: false,
        confirmPassword: false
    };

    // Master function to check form validity and update button state
    function updateButtonState() {
        let formIsValid = true;
        for (const field in validationStatus) {
            if (!validationStatus[field]) {
                formIsValid = false;
                break;
            }
        }
        registerBtn.disabled = !formIsValid;
    }

    // --- Validation Functions ---

    // Validates gender based on radio button selection
    function validateGender() {
        const genderInput = document.querySelector('input[name="gender"]:checked');
        if (genderInput) {
            validationStatus.gender = true;
        } else {
            validationStatus.gender = false;
        }
        updateButtonState();
    }

    // Validates a single input field
    function validateInput(input) {
        const name = input.name;
        const value = input.value.trim();
        let isValid = true;

        switch (name) {
           case 'firstName':
           case 'lastName':
               // Trim input and normalize quotes
               const cleanedValue = value.trim().replace(/[\u2018\u2019\u201C\u201D]/g, "'");
               if (!/^[A-Za-z' -]{1,50}$/.test(cleanedValue)) {
                   showError(input, "1-50 letters, spaces, hyphens or apostrophes allowed");
                   isValid = false;
               } else {
                   hideError(input);
               }
               break;
            case 'dateOfBirth':
                if (!value) {
                    showError(input, "Date of birth is required");
                    isValid = false;
                } else {
                    hideError(input);
                }
                break;
            case 'country':
            case 'state':
            case 'city':
                if (value.length < 1) {
                    showError(input, "Required");
                    isValid = false;
                } else {
                    hideError(input);
                }
                break;
            case 'pincode':
                if (!patterns.pincode.test(value)) {
                    showError(input, "5-10 digits required");
                    isValid = false;
                } else {
                    hideError(input);
                }
                break;
            case 'password':
                if (!patterns.password.test(value)) {
                    showError(input, "8-20 chars, upper/lower/digit/special");
                    isValid = false;
                } else {
                    hideError(input);
                }
                break;
            case 'confirmPassword':
                if (value !== form.password.value) {
                    showError(input, "Passwords must match");
                    isValid = false;
                } else {
                    hideError(input);
                }
                break;
        }
        validationStatus[name] = isValid;
        updateButtonState();
    }

    // --- Asynchronous Axios Validation ---
    const baseUrl = "${pageContext.request.contextPath}";
    async function validateContactAxios() {
        const input = form.contact;
        const val = input.value.trim();

        if (!patterns.contact.test(val)) {
            showError(input, "10-15 digits required");
            validationStatus.contact = false;
        } else {
            try {
                const res = await axios.get(baseUrl + "/checkContact", { params: { contact: val } });
                if (res.data.status === "EXISTS") {
                    showError(input, "Already registered");
                    validationStatus.contact = false;
                } else {
                    hideError(input);
                    validationStatus.contact = true;
                }
            } catch (e) {
                showError(input, "Unable to check contact. Try again.");
                validationStatus.contact = false; // Assume invalid on error to prevent submission
                console.error('Axios contact check error:', e);
            }
        }
        updateButtonState();
    }

    async function validateEmailAxios() {
        const input = form.emailId;
        const val = input.value.trim();

        if (!patterns.email.test(val)) {
            showError(input, "Invalid email format");
            validationStatus.emailId = false;
        } else {
            try {
                const res = await axios.get(baseUrl + "/checkEmailID", { params: { emailId: val } });
                if (res.data.status === "EXISTS") {
                    showError(input, "Already registered");
                    validationStatus.emailId = false;
                } else {
                    hideError(input);
                    validationStatus.emailId = true;
                }
            } catch (e) {
                showError(input, "Unable to check email. Try again.");
                validationStatus.emailId = false; // Assume invalid on error
                console.error('Axios email check error:', e);
            }
        }
        updateButtonState();
    }

    // --- Event Listeners ---
    form.addEventListener("input", (e) => {
        const target = e.target;
        if (target.type === 'radio' && target.name === 'gender') {
            validateGender();
        } else if (target.name !== 'contact' && target.name !== 'emailId') {
            validateInput(target);
        }
    });

    form.contact.addEventListener('blur', validateContactAxios);
    form.emailId.addEventListener('blur', validateEmailAxios);

    // Initial check for any pre-filled data and to disable the button
    document.addEventListener('DOMContentLoaded', () => {
        form.querySelectorAll('input').forEach(input => {
            if (input.value) {
                validateInput(input);
            }
        });
        validateGender();
        updateButtonState();
    });

    // Final validation on form submission
    form.addEventListener("submit", async e => {
        e.preventDefault();

        // Run all validations one last time
        form.querySelectorAll('input[required]').forEach(validateInput);
        await validateContactAxios();
        await validateEmailAxios();
        validateGender();

        if (!registerBtn.disabled) {
            form.submit();
        }
    });

    // DateTime
    function updateDateTime() {
        const now = new Date();
        document.getElementById("datetime").innerText = now.toLocaleString("en-US", { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' });
    }
    setInterval(updateDateTime, 1000);
    updateDateTime();
</script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
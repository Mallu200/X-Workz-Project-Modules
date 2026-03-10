<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>User Profile - Kick Sports</title>
    <link rel="icon" href="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" type="image/jpg">
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
        }

        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.65);
            z-index: -1;
        }

        .navbar-custom,
        .footer-custom {
            background: linear-gradient(90deg, #000000, #8b0000);
        }

        .navbar-custom .navbar-text,
        .footer-custom {
            color: #fff;
        }

        .navbar-brand img {
            width: 65px;
            height: 65px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #fff;
        }

        .card {
            background: rgba(0, 0, 0, 0.85);
            border: 2px solid #8b0000;
            color: #fff;
            border-radius: 15px;
        }

        .table th {
            width: 30%;
            text-align: right;
            padding-right: 15px;
            font-weight: 600;
            color: #ffb300;
        }

        .table td {
            width: 70%;
        }

        .form-control,
        select.form-control {
            background: rgba(30, 30, 30, 0.7);
            color: #fff;
            border: 1.5px solid #555;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-transform: none !important;
        }

        .form-control:focus,
        select.form-control:focus {
            background: rgba(30, 30, 30, 0.9);
            border-color: #ffb300;
            box-shadow: 0 0 8px rgba(255, 179, 0, 0.5);
            color: #fff;
        }

        .form-control.is-valid {
            border: 2px solid #28a745;
            box-shadow: 0 0 8px 1.5px #28a74599;
        }

        .form-control[readonly],
        select[disabled] {
            background: rgba(50, 50, 50, 0.6);
            color: #aaa;
            border-color: #444;
            cursor: not-allowed;
        }

        select.form-control option {
            background: #222;
            color: #fff;
        }

        .btn-warning,
        .btn-success,
        .btn-secondary {
            font-weight: 600;
            border-radius: 25px;
        }

        .btn-warning {
            background: #ffb300;
            border: none;
            color: #222;
        }

        .btn-warning:hover {
            background: #ff9800;
            color: #fff;
        }

        .btn-success {
            background: #388e3c;
            border: none;
        }

        .btn-success:hover {
            background: #2e7031;
        }

        .btn-secondary {
            background: #333;
            border: none;
        }

        .btn-secondary:hover {
            background: #555;
        }

        .invalid-feedback {
            font-size: 0.875rem;
            color: #dc3545;
            margin-top: 4px;
            display: none;
        }
    </style>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-custom fixed-top shadow-sm">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a class="navbar-brand d-flex align-items-center" href="storePage">
                <img src="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" alt="Logo">
            </a>
            <span class="navbar-text fs-4 fw-bold mx-auto text-uppercase text-center">Kick Sports Profile</span>
            <div class="d-flex">
                <a href="logout" class="btn btn-light">Logout</a>
            </div>
        </div>
    </nav>

    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-lg p-4">
                    <div class="card-header bg-transparent text-center mb-3">
                        <!-- Profile Image -->
                        <div class="text-center mb-3">
                            <c:choose>
                                <c:when test="${not empty userDto.profileName}">
                                    <img src="${pageContext.request.contextPath}/images/${userDto.profileName}" 
                                         alt="Profile Image" wclass="rounded-circle"
                                         style="width:120px;height:120px;object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" 
                                         alt="Default Profile" class="rounded-circle" 
                                         style="width:120px;height:120px;object-fit:cover;">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h3 class="fw-bold text-danger">User Profile</h3>
                    </div>

                    <div class="card-body">
                        <c:if test="${not empty success}">
                            <div class="alert alert-success text-center mt-3">${success}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger text-center mt-3">${error}</div>
                        </c:if>

                        <form id="profileForm" action="updateProfile" method="post" enctype="multipart/form-data" autocomplete="off" novalidate>
                            <input type="hidden" name="userId" value="${userDto.getUserId()}" />

                            <div class="row mb-3">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">First Name</label>
                                    <input type="text" name="firstName" class="form-control" value="${userDto.getFirstName()}" readonly>
                                    <div class="invalid-feedback">1–50 letters required</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Last Name</label>
                                    <input type="text" name="lastName" class="form-control" value="${userDto.getLastName()}" readonly>
                                    <div class="invalid-feedback">1–50 letters required</div>
                                </div>
                            </div>

                            <!-- Gender -->
                            <div class="mb-3">
                                <label class="form-label d-block">Gender</label>
                                <div id="genderGroup" class="d-flex gap-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gender" value="Male" ${userDto.getGender()=='Male' ?'checked':''} disabled>
                                        <label class="form-check-label">Male</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gender" value="Female" ${userDto.getGender()=='Female' ?'checked':''} disabled>
                                        <label class="form-check-label">Female</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gender" value="Other" ${userDto.getGender()=='Other' ?'checked':''} disabled>
                                        <label class="form-check-label">Other</label>
                                    </div>
                                </div>
                                <div class="invalid-feedback">Gender required</div>
                            </div>

                            <!-- Date of Birth, Contact, Email -->
                            <div class="mb-3">
                                <label class="form-label">Date of Birth</label>
                                <input type="date" name="dateOfBirth" class="form-control" value="${userDto.getDateOfBirth()}" readonly>
                                <div class="invalid-feedback">Date of birth required</div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Contact Number</label>
                                <input type="text" name="contact" id="contact" class="form-control" value="${userDto.getContact()}" readonly placeholder="Contact Number">
                                <div class="invalid-feedback" id="contactError">10–15 digits required / already registered</div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="emailId" id="emailId" class="form-control" value="${userDto.getEmailId()}" placeholder="Email">
                                <div class="invalid-feedback" id="emailError">Invalid email / already registered</div>
                            </div>

                            <!-- Address Fields -->
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label class="form-label">Country</label>
                                    <input type="text" name="country" class="form-control" value="${userDto.getCountry()}" readonly>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">State</label>
                                    <input type="text" name="state" class="form-control" value="${userDto.getState()}" readonly>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">City</label>
                                    <input type="text" name="city" class="form-control" value="${userDto.getCity()}" readonly>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Pincode</label>
                                <input type="text" name="pincode" class="form-control" value="${userDto.getPincode()}" readonly>
                            </div>

                            <input type="hidden" name="password" value="${userDto.getPassword()}" />

                            <!-- Profile Picture Upload -->
                            <div class="mb-3 d-none" id="fileUploadContainer">
                                <label class="form-label">Profile Picture</label>
                                <input type="file" name="profileImage" id="fileInput" accept="image/*" class="form-control" />
                                <div class="mt-2">
                                    <img id="filePreview" src="" alt="Preview"
                                         class="rounded-circle border border-2"
                                         style="width:100px; height:100px; object-fit:cover; display:none;">
                                </div>
                            </div>

                            <input type="hidden" name="profileName" value="${userDto.profileName}" />

                            <div class="text-center mt-4">
                                <button type="button" id="editBtn" class="btn btn-warning">Edit Profile</button>
                                <button type="submit" id="saveBtn" class="btn btn-success d-none" disabled>Save Changes</button>
                                <a href="storePage?email=${userDto.getEmailId()}" class="btn btn-secondary ms-2">Back to Store</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer-custom text-white py-3 position-fixed bottom-0 w-100 shadow-sm">
        <div class="container text-center fw-semibold">&copy; 2025 Kick Sports</div>
        <div id="datetime" style="position: fixed; right: 20px; bottom: 10px; font-size: 0.85rem; opacity: 0.9;"></div>
    </footer>

    <script>
        const form = document.getElementById('profileForm');
        const editBtn = document.getElementById('editBtn');
        const saveBtn = document.getElementById('saveBtn');

        // Enable fields on Edit
        editBtn.addEventListener('click', function () {
            form.querySelectorAll('input, select').forEach(el => {
                if (el.name !== 'userId') el.removeAttribute('readonly');
                el.removeAttribute('disabled');
            });
            document.getElementById('fileUploadContainer').classList.remove('d-none');
            editBtn.classList.add('d-none');
            saveBtn.classList.remove('d-none');
            saveBtn.disabled = false;
        });

        // File Preview
        const fileInput = document.getElementById('fileInput');
        const filePreview = document.getElementById('filePreview');
        fileInput.addEventListener('change', function () {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    filePreview.src = e.target.result;
                    filePreview.style.display = 'inline-block';
                }
                reader.readAsDataURL(file);
            } else {
                filePreview.src = '';
                filePreview.style.display = 'none';
            }
        });

        // Date & time
        function updateDateTime() {
            const now = new Date();
            document.getElementById("datetime").innerText = now.toLocaleString("en-US", {
                year: 'numeric', month: 'short', day: 'numeric',
                hour: '2-digit', minute: '2-digit', second: '2-digit'
            });
        }
        setInterval(updateDateTime, 1000);
        updateDateTime();
    </script>
</body>

</html>

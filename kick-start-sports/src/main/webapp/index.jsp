<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Kick Sports - Home</title>
    <link rel="icon" href="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" type="image/jpg">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-control.is-valid {
            border: 2px solid #28a745;
            box-shadow: 0 0 8px 1.5px #28a74599;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="date"] {
            text-transform: none !important;
        }
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
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.65);
            z-index: -1;
        }
        .navbar-custom, .footer-custom { background: linear-gradient(90deg, #000000, #8b0000); }
        .navbar-custom .navbar-text, .footer-custom { color: #fff; }
        .navbar-brand img {
            width: 65px; height: 65px; object-fit: cover;
            border-radius: 50%; border: 2px solid #fff;
        }
        main h1 { font-size: 3rem; text-shadow: 2px 2px 8px rgba(0,0,0,0.7); }
        main p { font-size: 1.2rem; }
        .card { background: rgba(0,0,0,0.5); text-align: center; padding: 20px; margin-bottom: 20px; border-radius: 10px; }
    </style>
</head>

<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-custom fixed-top shadow-sm">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a class="navbar-brand d-flex align-items-center" href="home">
                <img src="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" alt="Logo">
            </a>
            <span class="navbar-text fs-4 fw-bold mx-auto text-uppercase text-center">Kick Sports</span>
            <div class="d-flex">
                <a href="userRegistrationPage" class="btn btn-light me-2">Register</a>
                <a href="loginPage" class="btn btn-light">Login</a>
            </div>
        </div>
    </nav>
x
    <!-- Main Content -->
    <main class="container my-5 text-center">
        <h1>Welcome to Kick Sports</h1>
        <p>Your one-stop destination for premium sports equipment and accessories.</p>

        <div class="row mt-5">
            <div class="col-md-4">
                <div class="card">
                    <h4>High-Quality Gear</h4>
                    <p>Get the best sports equipment from top brands.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <h4>Accessories</h4>
                    <p>Find everything you need to enhance your game.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <h4>Exclusive Offers</h4>
                    <p>Enjoy special discounts and seasonal offers.</p>
                </div>
            </div>
        </div>
    </main>

<!-- Footer -->
<footer class="footer-custom text-white py-3 position-fixed bottom-0 w-100 shadow-sm">
    <div class="container text-center fw-semibold">&copy; 2025 Kick Sports</div>
    <div id="datetime" class="datetime" style="position: fixed; right: 20px; bottom: 10px; font-size: 0.85rem; opacity: 0.9;"></div>
</footer>

   <!-- Scripts -->
<script>
    function updateDateTime() {
        const now = new Date();
        const options = {
            year: 'numeric', month: 'short', day: 'numeric',
            hour: '2-digit', minute: '2-digit', second: '2-digit'
        };
        document.getElementById("datetime").innerText = now.toLocaleString("en-US", options);
    }
    setInterval(updateDateTime, 1000);
    window.onload = updateDateTime;
</script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Kick Sports - Store</title>
    <link rel="icon" href="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" type="image/jpg">
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
            position: relative;
        }
        body::before {
            content: "";
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.65);
            z-index: -1;
        }

        /* Navbar & Footer */
        .navbar-custom, .footer-custom { background: linear-gradient(90deg, #000000, #8b0000); }
        .navbar-custom .navbar-text, .footer-custom { color: #fff; }
        .navbar-brand img { width: 65px; height: 65px; border-radius: 50%; border: 2px solid #fff; }

        /* Buttons */
        .btn-classic {
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 10px 25px;
            border-radius: 30px;
            border: 2px solid #fff;
            background-color: transparent;
            color: #fff;
            transition: all 0.3s ease;
        }
        .btn-classic:hover { background-color: #8b0000; border-color: #fff; transform: scale(1.05); }

        /* Store Heading */
        main h1 { font-size: 3rem; text-shadow: 2px 2px 8px rgba(0,0,0,0.7); }
        main p { font-size: 1.2rem; }

        /* Product Cards */
        .card-hover {
            border-radius: 15px;
            background: rgba(0,0,0,0.85);
            border: 1px solid #8b0000;
            color: #fff;
        }
        .card-hover img {
            height: 250px;          /* uniform height */
            width: 100%;
            object-fit: contain;    /* no cropping, full product visible */
            background: #fff;       /* clean backdrop */
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            padding: 10px;          /* spacing inside */
        }
        .card-hover h5 { font-weight: bold; color: #ff0000; }
        .card-hover p { font-size: 0.9rem; color: #ccc; }

        footer .datetime {
            position: absolute;
            right: 20px;
            bottom: 10px;
            font-size: 0.85rem;
            opacity: 0.9;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-custom fixed-top shadow-sm" id="navbar">
    <div class="container-fluid">
        <!-- Left: Logo -->
        <a class="navbar-brand me-2" href="home">
            <img src="https://i.pinimg.com/474x/fd/a5/64/fda56489fabe92888d0da027e015b0df.jpg" alt="Logo">
        </a>

        <!-- Center: Title -->
        <span class="navbar-text fs-4 fw-bold mx-auto text-uppercase text-center">Kick Sports Store</span>

        <!-- Right: User Button -->
        <c:if test="${not empty firstName}">
            <a href="profilePage?email=${user.getEmailId()}" class="btn btn-light ms-auto" style="font-size:1.1rem; padding:8px 18px;">
                ${firstName}
            </a>
        </c:if>
    </div>
</nav>

<!-- Store Content -->
<main class="container my-5 text-center">
    <h1>Our Premium Products</h1>
    <p>Explore our high-quality sports gear collection.</p>

    <div class="row g-4 mt-5">
        <div class="col-md-4">
            <div class="card-hover shadow-lg position-relative">
                <img src="https://m.media-amazon.com/images/I/61EhmDc-eWL.jpg" class="card-img-top" alt="Cricket Bat">
                <div class="card-body text-center">
                    <h5 class="card-title">Cricket Bat</h5>
                    <p class="card-text">A "Kick" cricket bat, like the Sixer Kick Shot or Prokick models, is not a distinct type of bat.</p>
                    <a href="#" target="_blank" class="btn btn-classic w-100">Buy Now</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-hover shadow-lg position-relative">
                <img src="data:image/webp;base64,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" class="card-img-top" alt="Football">
                <div class="card-body text-center">
                    <h5 class="card-title">Football</h5>
                    <p class="card-text">Premium quality football for all weather conditions. Durable and perfect for matches and practice.</p>
                    <a href="#" target="_blank" class="btn btn-classic w-100">Buy Now</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-hover shadow-lg position-relative">
                <img src="data:image/jpeg;base64,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" class="card-img-top" alt="Badminton Racket">
                <div class="card-body text-center">
                    <h5 class="card-title">Badminton Racket</h5>
                    <p class="card-text">Lightweight and strong badminton racket for fast-paced play. Ideal for beginners and pros alike.</p>
                    <a href="https://www.amazon.in/Li-Ning-G-Force-Superlite-3600/dp/B07ZQJQ6J6/" target="_blank" class="btn btn-classic w-100">Buy Now</a>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="footer-custom text-white py-3 position-fixed bottom-0 w-100 shadow-sm">
    <div class="container text-center fw-semibold">&copy; 2025 Kick Sports</div>
    <div id="datetime" class="datetime"></div>
</footer>

<script>
    // Footer datetime
    function updateDateTime() {
        const now = new Date();
        const options = { year:'numeric', month:'short', day:'numeric', hour:'2-digit', minute:'2-digit', second:'2-digit' };
        document.getElementById("datetime").innerText = now.toLocaleString("en-US", options);
    }
    setInterval(updateDateTime, 1000);
    window.onload = updateDateTime;
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

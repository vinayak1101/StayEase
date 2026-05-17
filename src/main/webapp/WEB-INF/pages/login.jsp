<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - StayEase</title>
    <meta name="description" content="Login to your StayEase account to manage bookings and explore rooms.">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="min-h-screen flex items-center justify-center" style="background: linear-gradient(135deg, #0f1f33 0%, #1e3a5f 50%, #2d5a8e 100%);">
    <div class="w-full max-w-md mx-4 page-content">
        <!-- Logo -->
        <div class="text-center mb-8">
            <a href="${pageContext.request.contextPath}/home" class="inline-block">
                <h1 class="text-4xl font-bold text-white" style="font-family: 'Playfair Display', serif;">
                    <i class="fas fa-hotel mr-2" style="color: #c8a45a;"></i>StayEase
                </h1>
                <p class="text-gray-300 mt-2 text-sm tracking-wider uppercase">Premium Hotel Experience</p>
            </a>
        </div>

        <!-- Login Card -->
        <div class="bg-white/95 backdrop-blur-lg rounded-2xl shadow-2xl p-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-1" style="font-family: 'Playfair Display', serif;">Welcome Back</h2>
            <p class="text-gray-500 mb-6 text-sm">Sign in to your account</p>

            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>

            <form id="loginForm" method="POST" action="${pageContext.request.contextPath}/login">
                <div class="mb-5">
                    <label for="email" class="form-label"><i class="fas fa-envelope mr-1 text-gray-400"></i> Email Address</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="you@example.com"
                           value="${email}" required>
                </div>
                <div class="mb-6">
                    <label for="password" class="form-label"><i class="fas fa-lock mr-1 text-gray-400"></i> Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
                </div>
                <button type="submit" class="btn-primary w-full justify-center text-base py-3">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </button>
            </form>

            <div class="mt-6 text-center">
                <p class="text-gray-500 text-sm mb-2">
                    <a href="${pageContext.request.contextPath}/forgot-password" class="font-semibold" style="color: #1e3a5f;">Forgot Password?</a>
                </p>
                <p class="text-gray-500 text-sm">
                    Don't have an account?
                    <a href="${pageContext.request.contextPath}/register" class="font-semibold" style="color: #1e3a5f;">Create Account</a>
                </p>
            </div>
        </div>

        <!-- Demo Credentials -->
        <div class="mt-6 glass p-4 text-center text-white/80 text-xs">
            <p class="font-semibold text-white/90 mb-1">Demo Credentials</p>
            <p>Admin: admin@stayease.com / admin123</p>
            <p>Staff: emily@stayease.com / staff123</p>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

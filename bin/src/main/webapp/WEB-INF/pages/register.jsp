<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - StayEase</title>
    <meta name="description" content="Create a StayEase account to start booking premium hotel rooms.">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="min-h-screen flex items-center justify-center py-8" style="background: linear-gradient(135deg, #0f1f33 0%, #1e3a5f 50%, #2d5a8e 100%);">
    <div class="w-full max-w-md mx-4 page-content">
        <div class="text-center mb-8">
            <a href="${pageContext.request.contextPath}/home" class="inline-block">
                <h1 class="text-4xl font-bold text-white" style="font-family: 'Playfair Display', serif;">
                    <i class="fas fa-hotel mr-2" style="color: #c8a45a;"></i>StayEase
                </h1>
                <p class="text-gray-300 mt-2 text-sm tracking-wider uppercase">Create Your Account</p>
            </a>
        </div>

        <div class="bg-white/95 backdrop-blur-lg rounded-2xl shadow-2xl p-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-1" style="font-family: 'Playfair Display', serif;">Join StayEase</h2>
            <p class="text-gray-500 mb-6 text-sm">Fill in your details to get started</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <form id="registerForm" method="POST" action="${pageContext.request.contextPath}/register">
                <div class="mb-4">
                    <label for="fullName" class="form-label"><i class="fas fa-user mr-1 text-gray-400"></i> Full Name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-input" placeholder="John Doe"
                           value="${fullName}" required>
                </div>
                <div class="mb-4">
                    <label for="email" class="form-label"><i class="fas fa-envelope mr-1 text-gray-400"></i> Email Address *</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="you@example.com"
                           value="${email}" required>
                </div>
                <div class="mb-4">
                    <label for="phone" class="form-label"><i class="fas fa-phone mr-1 text-gray-400"></i> Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="+1-555-0100"
                           value="${phone}">
                </div>
                <div class="mb-4">
                    <label for="password" class="form-label"><i class="fas fa-lock mr-1 text-gray-400"></i> Password *</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Minimum 6 characters" required>
                </div>
                <div class="mb-6">
                    <label for="confirmPassword" class="form-label"><i class="fas fa-lock mr-1 text-gray-400"></i> Confirm Password *</label>
                    <input type="password" id="confirmPassword" class="form-input" placeholder="Re-enter your password" required>
                </div>
                <button type="submit" class="btn-primary w-full justify-center text-base py-3">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>

            <div class="mt-6 text-center">
                <p class="text-gray-500 text-sm">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login" class="font-semibold" style="color: #1e3a5f;">Sign In</a>
                </p>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

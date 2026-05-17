<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - StayEase</title>
    <meta name="description" content="Set a new password for your StayEase account.">
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
                <p class="text-gray-300 mt-2 text-sm tracking-wider uppercase">Set New Password</p>
            </a>
        </div>

        <!-- Reset Password Card -->
        <div class="bg-white/95 backdrop-blur-lg rounded-2xl shadow-2xl p-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-1" style="font-family: 'Playfair Display', serif;">New Password</h2>
            <p class="text-gray-500 mb-6 text-sm">Enter a strong new password for your account.</p>

            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <form id="resetPasswordForm" method="POST" action="${pageContext.request.contextPath}/reset-password">
                <!-- Keep the email passed from forgot password logic -->
                <input type="hidden" name="email" value="${email}">
                
                <div class="mb-5">
                    <label for="password" class="form-label"><i class="fas fa-lock mr-1 text-gray-400"></i> New Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="At least 6 characters" required>
                </div>
                <div class="mb-6">
                    <label for="confirmPassword" class="form-label"><i class="fas fa-lock mr-1 text-gray-400"></i> Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Re-enter password" required>
                </div>
                <button type="submit" class="btn-primary w-full justify-center text-base py-3">
                    <i class="fas fa-save"></i> Save New Password
                </button>
            </form>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

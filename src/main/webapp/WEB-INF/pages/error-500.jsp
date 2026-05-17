<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Something Went Wrong - StayEase</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="min-h-screen flex items-center justify-center" style="background: linear-gradient(135deg, #f8f9fa, #e8ecf1);">
    <div class="text-center page-content px-6">
        <div class="mb-8">
            <div class="text-9xl font-bold" style="color: #1e3a5f; font-family: 'Playfair Display', serif; opacity: 0.15;">500</div>
            <div class="relative -mt-20">
                <i class="fas fa-tools text-6xl" style="color: #c8a45a;"></i>
            </div>
        </div>
        <h1 class="text-3xl font-bold text-gray-800 mb-4" style="font-family: 'Playfair Display', serif;">Something Went Wrong</h1>
        <p class="text-gray-500 mb-8 max-w-md mx-auto">
            We encountered an unexpected issue. Our team has been notified. Please try again in a moment.
        </p>
        <div class="flex gap-4 justify-center flex-wrap">
            <a href="${pageContext.request.contextPath}/home" class="btn-primary">
                <i class="fas fa-home"></i> Back to Home
            </a>
            <a href="javascript:history.back()" class="btn-accent">
                <i class="fas fa-arrow-left"></i> Go Back
            </a>
        </div>
        <div class="mt-12">
            <a href="${pageContext.request.contextPath}/home" class="inline-block">
                <span class="text-2xl font-bold" style="color: #1e3a5f; font-family: 'Playfair Display', serif;">
                    <i class="fas fa-hotel mr-2" style="color: #c8a45a;"></i>StayEase
                </span>
            </a>
        </div>
    </div>
</body>
</html>

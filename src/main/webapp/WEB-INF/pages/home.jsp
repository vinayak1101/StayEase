<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StayEase - Premium Hotel Booking</title>
    <meta name="description" content="Book premium hotel rooms at StayEase. Explore Standard, Deluxe, and Suite accommodations.">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar px-6 py-4">
        <div class="max-w-7xl mx-auto flex items-center justify-between">
            <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-2 text-white text-xl font-bold" style="font-family: 'Playfair Display', serif;">
                <i class="fas fa-hotel" style="color: #c8a45a;"></i> StayEase
            </a>
            <!-- Desktop Nav -->
            <div class="hidden md:flex items-center gap-6">
                <a href="${pageContext.request.contextPath}/home" class="text-white/90 hover:text-white text-sm font-medium">Home</a>
                <a href="${pageContext.request.contextPath}/rooms" class="text-white/90 hover:text-white text-sm font-medium">Rooms</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/booking" class="text-white/90 hover:text-white text-sm font-medium">My Bookings</a>
                        <span class="text-gray-400 text-sm">Hello, ${sessionScope.userName}</span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-accent text-sm py-2 px-4">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="text-white/90 hover:text-white text-sm font-medium">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn-accent text-sm py-2 px-4">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- Mobile Menu Button -->
            <button id="mobileMenuBtn" class="md:hidden text-white text-xl"><i class="fas fa-bars"></i></button>
        </div>
        <!-- Mobile Menu -->
        <div id="mobileMenu" class="hidden md:hidden mt-4 pb-4 border-t border-white/10 pt-4">
            <div class="flex flex-col gap-3">
                <a href="${pageContext.request.contextPath}/home" class="text-white/90 text-sm">Home</a>
                <a href="${pageContext.request.contextPath}/rooms" class="text-white/90 text-sm">Rooms</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/booking" class="text-white/90 text-sm">My Bookings</a>
                        <a href="${pageContext.request.contextPath}/logout" class="text-white/90 text-sm">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="text-white/90 text-sm">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="text-white/90 text-sm">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="max-w-7xl mx-auto px-6 text-center relative z-10 w-full">
            <h1 class="text-5xl md:text-7xl font-bold text-white mb-6" style="font-family: 'Playfair Display', serif;">
                Experience <span style="color: #c8a45a;">Luxury</span><br>Like Never Before
            </h1>
            <p class="text-xl text-gray-200 mb-10 max-w-2xl mx-auto">
                Discover our handpicked selection of premium rooms designed for comfort, elegance, and unforgettable stays.
            </p>

            <!-- Search Box -->
            <div class="search-box max-w-4xl mx-auto">
                <form action="${pageContext.request.contextPath}/rooms" method="GET"
                      class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div>
                        <label class="block text-white/80 text-sm font-medium mb-2">Check In</label>
                        <input type="date" name="checkIn" id="checkIn" class="form-input" required>
                    </div>
                    <div>
                        <label class="block text-white/80 text-sm font-medium mb-2">Check Out</label>
                        <input type="date" name="checkOut" id="checkOut" class="form-input" required>
                    </div>
                    <div>
                        <label class="block text-white/80 text-sm font-medium mb-2">Guests</label>
                        <select name="guests" class="form-select">
                            <option value="1">1 Guest</option>
                            <option value="2" selected>2 Guests</option>
                            <option value="3">3 Guests</option>
                            <option value="4">4 Guests</option>
                        </select>
                    </div>
                    <div class="flex items-end">
                        <button type="submit" class="btn-accent w-full py-3 text-center font-bold">
                            <i class="fas fa-search mr-2"></i> Search Rooms
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <!-- Room Types Section -->
    <section class="py-20 px-6">
        <div class="max-w-7xl mx-auto">
            <div class="text-center mb-14">
                <h2 class="text-4xl font-bold text-gray-800 mb-4" style="font-family: 'Playfair Display', serif;">
                    Our <span style="color: #1e3a5f;">Room</span> Categories
                </h2>
                <p class="text-gray-500 max-w-xl mx-auto">Choose from our carefully curated room types, each designed to deliver an exceptional experience.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <c:forEach var="rt" items="${roomTypes}">
                    <div class="card">
                        <div class="h-52 relative overflow-hidden">
                            <c:choose>
                                <c:when test="${rt.typeName == 'Standard'}">
                                    <div class="w-full h-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center">
                                        <i class="fas fa-bed text-white/30 text-8xl"></i>
                                    </div>
                                </c:when>
                                <c:when test="${rt.typeName == 'Deluxe'}">
                                    <div class="w-full h-full bg-gradient-to-br from-purple-400 to-indigo-600 flex items-center justify-center">
                                        <i class="fas fa-star text-white/30 text-8xl"></i>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="w-full h-full bg-gradient-to-br from-amber-400 to-orange-600 flex items-center justify-center">
                                        <i class="fas fa-crown text-white/30 text-8xl"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="p-6">
                            <h3 class="text-2xl font-bold text-gray-800 mb-2">${rt.typeName}</h3>
                            <p class="text-gray-500 text-sm mb-4">${rt.description}</p>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-4 text-sm text-gray-400">
                                    <span><i class="fas fa-user-friends mr-1"></i> Up to ${rt.capacity}</span>
                                </div>
                                <div class="price text-2xl">
                                    <span class="currency">$</span>${rt.basePrice}<span class="per-night">/night</span>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn-primary w-full justify-center mt-4">
                                View Rooms <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-16 px-6" style="background: linear-gradient(135deg, #f8f9fa, #e8ecf1);">
        <div class="max-w-7xl mx-auto">
            <div class="text-center mb-14">
                <h2 class="text-4xl font-bold text-gray-800 mb-4" style="font-family: 'Playfair Display', serif;">Why Choose <span style="color: #c8a45a;">StayEase</span></h2>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                <div class="text-center p-6">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-2xl flex items-center justify-center" style="background: linear-gradient(135deg, #1e3a5f, #2d5a8e);">
                        <i class="fas fa-shield-alt text-white text-2xl"></i>
                    </div>
                    <h4 class="font-bold text-gray-800 mb-2">Secure Booking</h4>
                    <p class="text-gray-500 text-sm">Your data is protected with enterprise-grade security.</p>
                </div>
                <div class="text-center p-6">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-2xl flex items-center justify-center" style="background: linear-gradient(135deg, #c8a45a, #e6c96e);">
                        <i class="fas fa-concierge-bell text-white text-2xl"></i>
                    </div>
                    <h4 class="font-bold text-gray-800 mb-2">24/7 Service</h4>
                    <p class="text-gray-500 text-sm">Round-the-clock concierge and room service.</p>
                </div>
                <div class="text-center p-6">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-2xl flex items-center justify-center" style="background: linear-gradient(135deg, #10b981, #34d399);">
                        <i class="fas fa-undo text-white text-2xl"></i>
                    </div>
                    <h4 class="font-bold text-gray-800 mb-2">Free Cancellation</h4>
                    <p class="text-gray-500 text-sm">Cancel anytime before check-in with full refund.</p>
                </div>
                <div class="text-center p-6">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-2xl flex items-center justify-center" style="background: linear-gradient(135deg, #8b5cf6, #a78bfa);">
                        <i class="fas fa-wifi text-white text-2xl"></i>
                    </div>
                    <h4 class="font-bold text-gray-800 mb-2">Free Wi-Fi</h4>
                    <p class="text-gray-500 text-sm">High-speed internet in all rooms and common areas.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer py-12 px-6">
        <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-8">
            <div>
                <h3 class="text-white text-xl font-bold mb-4" style="font-family: 'Playfair Display', serif;">
                    <i class="fas fa-hotel mr-2" style="color: #c8a45a;"></i>StayEase
                </h3>
                <p class="text-sm">Premium hotel booking experience with world-class amenities and exceptional service.</p>
            </div>
            <div>
                <h4 class="text-white font-semibold mb-4">Quick Links</h4>
                <div class="flex flex-col gap-2 text-sm">
                    <a href="${pageContext.request.contextPath}/home" class="hover:text-white transition">Home</a>
                    <a href="${pageContext.request.contextPath}/rooms" class="hover:text-white transition">Our Rooms</a>
                    <a href="${pageContext.request.contextPath}/login" class="hover:text-white transition">Login</a>
                </div>
            </div>
            <div>
                <h4 class="text-white font-semibold mb-4">Contact Us</h4>
                <div class="flex flex-col gap-2 text-sm">
                    <span><i class="fas fa-envelope mr-2"></i> info@stayease.com</span>
                    <span><i class="fas fa-phone mr-2"></i> +1 (555) 123-4567</span>
                    <span><i class="fas fa-map-marker-alt mr-2"></i> 123 Luxury Ave, Suite 100</span>
                </div>
            </div>
        </div>
        <div class="max-w-7xl mx-auto mt-8 pt-8 border-t border-white/10 text-center text-sm">
            <p>&copy; 2026 StayEase. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

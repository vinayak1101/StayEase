<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rooms - StayEase</title>
    <meta name="description" content="Browse and search available hotel rooms at StayEase.">
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
            <div class="hidden md:flex items-center gap-6">
                <a href="${pageContext.request.contextPath}/home" class="text-white/90 text-sm font-medium">Home</a>
                <a href="${pageContext.request.contextPath}/rooms" class="text-white text-sm font-medium border-b-2 border-amber-400 pb-1">Rooms</a>
                <c:if test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/booking" class="text-white/90 text-sm font-medium">My Bookings</a>
                    <span class="text-gray-400 text-sm">Hello, ${sessionScope.userName}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-accent text-sm py-2 px-4">Logout</a>
                </c:if>
                <c:if test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/login" class="text-white/90 text-sm font-medium">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-accent text-sm py-2 px-4">Register</a>
                </c:if>
            </div>
            <button id="mobileMenuBtn" class="md:hidden text-white text-xl"><i class="fas fa-bars"></i></button>
        </div>
        <div id="mobileMenu" class="hidden md:hidden mt-4 pb-4 border-t border-white/10 pt-4">
            <div class="flex flex-col gap-3">
                <a href="${pageContext.request.contextPath}/home" class="text-white/90 text-sm">Home</a>
                <a href="${pageContext.request.contextPath}/rooms" class="text-white text-sm">Rooms</a>
                <c:if test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/booking" class="text-white/90 text-sm">My Bookings</a>
                    <a href="${pageContext.request.contextPath}/logout" class="text-white/90 text-sm">Logout</a>
                </c:if>
                <c:if test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/login" class="text-white/90 text-sm">Login</a>
                </c:if>
            </div>
        </div>
    </nav>

    <div class="page-content py-10 px-6">
        <div class="max-w-7xl mx-auto">
            <!-- Page Header -->
            <div class="mb-8">
                <h1 class="text-4xl font-bold text-gray-800 mb-2" style="font-family: 'Playfair Display', serif;">Our Rooms</h1>
                <p class="text-gray-500">Find the perfect room for your stay</p>
            </div>

            <!-- Search & Filter Bar -->
            <div class="card p-6 mb-8">
                <form action="${pageContext.request.contextPath}/rooms" method="GET" class="grid grid-cols-1 md:grid-cols-5 gap-4 items-end">
                    <div>
                        <label class="form-label">Check In</label>
                        <input type="date" name="checkIn" id="checkIn" class="form-input" value="${checkIn}">
                    </div>
                    <div>
                        <label class="form-label">Check Out</label>
                        <input type="date" name="checkOut" id="checkOut" class="form-input" value="${checkOut}">
                    </div>
                    <div>
                        <label class="form-label">Guests</label>
                        <select name="guests" class="form-select">
                            <option value="1" ${guests == '1' ? 'selected' : ''}>1 Guest</option>
                            <option value="2" ${guests == '2' || empty guests ? 'selected' : ''}>2 Guests</option>
                            <option value="3" ${guests == '3' ? 'selected' : ''}>3 Guests</option>
                            <option value="4" ${guests == '4' ? 'selected' : ''}>4 Guests</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">Room Type</label>
                        <select id="roomTypeFilter" class="form-select">
                            <option value="">All Types</option>
                            <c:forEach var="rt" items="${roomTypes}">
                                <option value="${rt.typeName}">${rt.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn-primary w-full justify-center py-3">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </div>
                </form>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <c:if test="${searchPerformed}">
                <div class="alert alert-info mb-6">
                    <i class="fas fa-info-circle"></i>
                    Showing ${fn:length(rooms)} available room(s) for your dates.
                </div>
            </c:if>

            <!-- Rooms Grid -->
            <c:choose>
                <c:when test="${empty rooms}">
                    <div class="text-center py-20">
                        <i class="fas fa-bed text-6xl text-gray-300 mb-4"></i>
                        <h3 class="text-xl font-bold text-gray-500 mb-2">No rooms found</h3>
                        <p class="text-gray-400">Try adjusting your search criteria.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="room" items="${rooms}">
                            <div class="card room-card room-item" data-type="${room.roomTypeName}">
                                <!-- Room Image Placeholder -->
                                <div class="h-48 relative overflow-hidden">
                                    <c:choose>
                                        <c:when test="${room.roomTypeName == 'Standard'}">
                                            <div class="w-full h-full bg-gradient-to-br from-sky-400 to-blue-600 flex items-center justify-center">
                                                <i class="fas fa-bed text-white/25 text-7xl"></i>
                                            </div>
                                        </c:when>
                                        <c:when test="${room.roomTypeName == 'Deluxe'}">
                                            <div class="w-full h-full bg-gradient-to-br from-violet-400 to-purple-600 flex items-center justify-center">
                                                <i class="fas fa-star text-white/25 text-7xl"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full h-full bg-gradient-to-br from-amber-400 to-orange-500 flex items-center justify-center">
                                                <i class="fas fa-crown text-white/25 text-7xl"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="room-badge badge badge-${room.status}">${room.status}</span>
                                </div>
                                <div class="p-5">
                                    <div class="flex items-center justify-between mb-2">
                                        <h3 class="text-lg font-bold text-gray-800">Room ${room.roomNumber}</h3>
                                        <span class="text-xs font-semibold px-3 py-1 rounded-full" style="background: #f0f4ff; color: #1e3a5f;">${room.roomTypeName}</span>
                                    </div>
                                    <p class="text-gray-500 text-sm mb-3">${room.typeDescription}</p>
                                    <div class="flex items-center gap-3 text-xs text-gray-400 mb-3">
                                        <span><i class="fas fa-layer-group mr-1"></i> Floor ${room.floor}</span>
                                        <span><i class="fas fa-user-friends mr-1"></i> Up to ${room.capacity}</span>
                                    </div>
                                    <!-- Amenities -->
                                    <div class="mb-4 flex flex-wrap gap-1">
                                        <c:forEach var="amenity" items="${fn:split(room.amenities, ',')}">
                                            <span class="amenity-tag"><i class="fas fa-check text-green-500"></i> ${fn:trim(amenity)}</span>
                                        </c:forEach>
                                    </div>
                                    <div class="flex items-center justify-between pt-3 border-t">
                                        <div class="price text-2xl">
                                            <span class="currency">$</span>${room.price}<span class="per-night">/night</span>
                                        </div>
                                        <c:if test="${room.status == 'available'}">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    <a href="${pageContext.request.contextPath}/booking?action=create&roomId=${room.id}&checkIn=${checkIn}&checkOut=${checkOut}&guests=${guests}"
                                                       class="btn-primary text-sm py-2 px-4">Book Now</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/login" class="btn-primary text-sm py-2 px-4">Login to Book</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer py-8 px-6">
        <div class="max-w-7xl mx-auto text-center text-sm">
            <p>&copy; 2026 StayEase. All rights reserved.</p>
        </div>
    </footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

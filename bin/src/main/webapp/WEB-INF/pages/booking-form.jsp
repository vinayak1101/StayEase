<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Room - StayEase</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar px-6 py-4">
        <div class="max-w-7xl mx-auto flex items-center justify-between">
            <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-2 text-white text-xl font-bold" style="font-family: 'Playfair Display', serif;">
                <i class="fas fa-hotel" style="color: #c8a45a;"></i> StayEase
            </a>
            <div class="flex items-center gap-6">
                <a href="${pageContext.request.contextPath}/home" class="text-white/90 text-sm font-medium">Home</a>
                <a href="${pageContext.request.contextPath}/rooms" class="text-white/90 text-sm font-medium">Rooms</a>
                <a href="${pageContext.request.contextPath}/booking" class="text-white/90 text-sm font-medium">My Bookings</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn-accent text-sm py-2 px-4">Logout</a>
            </div>
        </div>
    </nav>

    <div class="page-content py-10 px-6">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-3xl font-bold text-gray-800 mb-8" style="font-family: 'Playfair Display', serif;">
                <i class="fas fa-calendar-check mr-2" style="color: #c8a45a;"></i> Complete Your Booking
            </h1>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Booking Form -->
                <div class="md:col-span-2">
                    <div class="card p-6">
                        <h2 class="text-xl font-bold text-gray-800 mb-6">Booking Details</h2>
                        <form method="POST" action="${pageContext.request.contextPath}/booking" id="bookingForm">
                            <input type="hidden" name="action" value="create">
                            <input type="hidden" name="roomId" value="${room.id}">
                            <input type="hidden" id="pricePerNight" value="${room.price}">

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                                <div>
                                    <label class="form-label">Check-In Date *</label>
                                    <input type="date" name="checkIn" id="checkIn" class="form-input" value="${checkIn}" required>
                                </div>
                                <div>
                                    <label class="form-label">Check-Out Date *</label>
                                    <input type="date" name="checkOut" id="checkOut" class="form-input" value="${checkOut}" required>
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">Number of Guests *</label>
                                <select name="guests" class="form-select" required>
                                    <c:forEach var="i" begin="1" end="${room.capacity}">
                                        <option value="${i}" ${guests == String.valueOf(i) ? 'selected' : ''}>${i} Guest(s)</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-6">
                                <label class="form-label">Special Requests</label>
                                <textarea name="specialRequests" class="form-input" rows="3"
                                          placeholder="Any special requirements? (e.g., extra pillows, dietary needs, late check-in)">${specialRequests}</textarea>
                            </div>

                            <!-- Price Summary -->
                            <div class="bg-gray-50 rounded-xl p-4 mb-6">
                                <div class="flex justify-between text-sm text-gray-600 mb-2">
                                    <span>Price per night</span>
                                    <span class="font-semibold">$${room.price}</span>
                                </div>
                                <div class="flex justify-between text-sm text-gray-600 mb-2">
                                    <span>Number of nights</span>
                                    <span id="numberOfNights" class="font-semibold">-</span>
                                </div>
                                <div class="flex justify-between text-lg font-bold text-gray-800 pt-2 border-t">
                                    <span>Total</span>
                                    <span id="totalPrice" class="price">-</span>
                                </div>
                            </div>

                            <button type="submit" class="btn-primary w-full justify-center py-3 text-base">
                                <i class="fas fa-check-circle"></i> Confirm Booking
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Room Summary Sidebar -->
                <div>
                    <div class="card p-5">
                        <c:choose>
                            <c:when test="${room.roomTypeName == 'Standard'}">
                                <div class="h-36 rounded-xl mb-4 bg-gradient-to-br from-sky-400 to-blue-600 flex items-center justify-center">
                                    <i class="fas fa-bed text-white/30 text-6xl"></i>
                                </div>
                            </c:when>
                            <c:when test="${room.roomTypeName == 'Deluxe'}">
                                <div class="h-36 rounded-xl mb-4 bg-gradient-to-br from-violet-400 to-purple-600 flex items-center justify-center">
                                    <i class="fas fa-star text-white/30 text-6xl"></i>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="h-36 rounded-xl mb-4 bg-gradient-to-br from-amber-400 to-orange-500 flex items-center justify-center">
                                    <i class="fas fa-crown text-white/30 text-6xl"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <h3 class="text-lg font-bold text-gray-800 mb-1">Room ${room.roomNumber}</h3>
                        <p class="text-sm font-medium mb-3" style="color: #1e3a5f;">${room.roomTypeName}</p>
                        <p class="text-gray-500 text-sm mb-3">${room.typeDescription}</p>
                        <div class="text-sm text-gray-400 mb-3">
                            <span><i class="fas fa-layer-group mr-1"></i> Floor ${room.floor}</span>
                            <span class="ml-3"><i class="fas fa-user-friends mr-1"></i> Up to ${room.capacity}</span>
                        </div>
                        <div class="flex flex-wrap gap-1">
                            <c:forEach var="amenity" items="${fn:split(room.amenities, ',')}">
                                <span class="amenity-tag">${fn:trim(amenity)}</span>
                            </c:forEach>
                        </div>
                        <div class="price text-2xl mt-4 pt-3 border-t">
                            <span class="currency">$</span>${room.price}<span class="per-night">/night</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="footer py-8 px-6"><div class="max-w-7xl mx-auto text-center text-sm"><p>&copy; 2026 StayEase. All rights reserved.</p></div></footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

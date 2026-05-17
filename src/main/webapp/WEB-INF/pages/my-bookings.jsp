<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - StayEase</title>
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
                <a href="${pageContext.request.contextPath}/booking" class="text-white text-sm font-medium border-b-2 border-amber-400 pb-1">My Bookings</a>
                <span class="text-gray-400 text-sm">${sessionScope.userName}</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-accent text-sm py-2 px-4">Logout</a>
            </div>
        </div>
    </nav>

    <div class="page-content py-10 px-6">
        <div class="max-w-6xl mx-auto">
            <div class="flex items-center justify-between mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-gray-800" style="font-family: 'Playfair Display', serif;">My Bookings</h1>
                    <p class="text-gray-500 mt-1">View and manage your reservations</p>
                </div>
                <a href="${pageContext.request.contextPath}/rooms" class="btn-primary"><i class="fas fa-plus"></i> New Booking</a>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${empty bookings}">
                    <div class="card p-16 text-center">
                        <i class="fas fa-suitcase text-6xl text-gray-300 mb-4"></i>
                        <h3 class="text-xl font-bold text-gray-500 mb-2">No bookings yet</h3>
                        <p class="text-gray-400 mb-6">Start by exploring our rooms and making your first reservation.</p>
                        <a href="${pageContext.request.contextPath}/rooms" class="btn-primary">Browse Rooms</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-4">
                        <c:forEach var="b" items="${bookings}">
                            <div class="card p-6">
                                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                                    <div class="flex-1">
                                        <div class="flex items-center gap-3 mb-2">
                                            <h3 class="text-lg font-bold text-gray-800">${b.bookingReference}</h3>
                                            <span class="badge badge-${b.status}">${b.status}</span>
                                        </div>
                                        <div class="grid grid-cols-2 md:grid-cols-4 gap-3 text-sm text-gray-600">
                                            <div>
                                                <span class="text-gray-400 block text-xs">Room</span>
                                                <span class="font-medium">${b.roomNumber} (${b.roomTypeName})</span>
                                            </div>
                                            <div>
                                                <span class="text-gray-400 block text-xs">Check-In</span>
                                                <span class="font-medium">${b.checkInDate}</span>
                                            </div>
                                            <div>
                                                <span class="text-gray-400 block text-xs">Check-Out</span>
                                                <span class="font-medium">${b.checkOutDate}</span>
                                            </div>
                                            <div>
                                                <span class="text-gray-400 block text-xs">Total</span>
                                                <span class="font-bold" style="color: #1e3a5f;">$<fmt:formatNumber value="${b.totalPrice}" pattern="#,##0.00"/></span>
                                            </div>
                                        </div>
                                        <c:if test="${not empty b.specialRequests}">
                                            <p class="text-gray-400 text-xs mt-2"><i class="fas fa-comment mr-1"></i> ${b.specialRequests}</p>
                                        </c:if>
                                    </div>
                                    <div>
                                        <c:if test="${b.status == 'pending' || b.status == 'confirmed'}">
                                            <form method="POST" action="${pageContext.request.contextPath}/booking" class="inline">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                <button type="submit" class="btn-danger text-sm"
                                                        onclick="return confirm('Are you sure you want to cancel this booking?');">
                                                    <i class="fas fa-times mr-1"></i> Cancel
                                                </button>
                                            </form>
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
    <footer class="footer py-8 px-6"><div class="max-w-7xl mx-auto text-center text-sm"><p>&copy; 2026 StayEase. All rights reserved.</p></div></footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

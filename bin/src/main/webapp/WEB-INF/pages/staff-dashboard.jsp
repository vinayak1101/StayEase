<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - StayEase</title>
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
            <div class="flex items-center gap-4">
                <span class="text-gray-300 text-sm"><i class="fas fa-user-tie mr-1"></i> ${sessionScope.userName} (Staff)</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-accent text-sm py-2 px-4">Logout</a>
            </div>
        </div>
    </nav>

    <div class="flex">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="py-4">
                <a href="${pageContext.request.contextPath}/staff/dashboard" class="active">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/staff/bookings">
                    <i class="fas fa-calendar-alt"></i> Manage Bookings
                </a>
                <a href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-globe"></i> View Website
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-with-sidebar page-content">
            <h1 class="text-3xl font-bold text-gray-800 mb-2" style="font-family: 'Playfair Display', serif;">Staff Dashboard</h1>
            <p class="text-gray-500 mb-8">Welcome back, ${sessionScope.userName}!</p>

            <!-- Stats Row -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Total Bookings</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">${totalBookings}</p>
                        </div>
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center" style="background: #eff6ff;">
                            <i class="fas fa-calendar-check text-xl" style="color: #1e3a5f;"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Current Occupancy</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">${occupancy}</p>
                        </div>
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center" style="background: #f0fdf4;">
                            <i class="fas fa-door-open text-xl text-green-600"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Occupancy Rate</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">${occupancyRate}%</p>
                        </div>
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center" style="background: #fef3c7;">
                            <i class="fas fa-chart-pie text-xl text-amber-600"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Today's Check-Ins -->
            <div class="card p-6 mb-6">
                <h2 class="text-xl font-bold text-gray-800 mb-4">
                    <i class="fas fa-sign-in-alt mr-2 text-green-500"></i> Today's Check-Ins
                </h2>
                <c:choose>
                    <c:when test="${empty todayCheckIns}">
                        <p class="text-gray-400 text-center py-6">No check-ins scheduled for today.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Reference</th>
                                        <th>Guest</th>
                                        <th>Room</th>
                                        <th>Check-Out</th>
                                        <th>Guests</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${todayCheckIns}">
                                        <tr>
                                            <td class="font-semibold">${b.bookingReference}</td>
                                            <td>${b.userName}</td>
                                            <td>${b.roomNumber} (${b.roomTypeName})</td>
                                            <td>${b.checkOutDate}</td>
                                            <td>${b.numberOfGuests}</td>
                                            <td><span class="badge badge-${b.status}">${b.status}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Today's Check-Outs -->
            <div class="card p-6">
                <h2 class="text-xl font-bold text-gray-800 mb-4">
                    <i class="fas fa-sign-out-alt mr-2 text-red-500"></i> Today's Check-Outs
                </h2>
                <c:choose>
                    <c:when test="${empty todayCheckOuts}">
                        <p class="text-gray-400 text-center py-6">No check-outs scheduled for today.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Reference</th>
                                        <th>Guest</th>
                                        <th>Room</th>
                                        <th>Checked In</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${todayCheckOuts}">
                                        <tr>
                                            <td class="font-semibold">${b.bookingReference}</td>
                                            <td>${b.userName}</td>
                                            <td>${b.roomNumber} (${b.roomTypeName})</td>
                                            <td>${b.checkInDate}</td>
                                            <td><span class="badge badge-${b.status}">${b.status}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

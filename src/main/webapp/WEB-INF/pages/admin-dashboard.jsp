<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - StayEase</title>
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
            <div class="flex items-center gap-4">
                <span class="text-gray-300 text-sm"><i class="fas fa-user-shield mr-1"></i> ${sessionScope.userName} (Admin)</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-accent text-sm py-2 px-4">Logout</a>
            </div>
        </div>
    </nav>

    <div class="flex">
        <aside class="sidebar">
            <div class="py-4">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/rooms">
                    <i class="fas fa-door-closed"></i> Manage Rooms
                </a>
                <a href="${pageContext.request.contextPath}/admin/bookings">
                    <i class="fas fa-calendar-alt"></i> Manage Bookings
                </a>
                <a href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-users"></i> Manage Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports">
                    <i class="fas fa-chart-bar"></i> Reports
                </a>
                <a href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-globe"></i> View Website
                </a>
            </div>
        </aside>

        <main class="main-with-sidebar page-content">
            <h1 class="text-3xl font-bold text-gray-800 mb-2" style="font-family: 'Playfair Display', serif;">Admin Dashboard</h1>
            <p class="text-gray-500 mb-8">System overview and key metrics</p>

            <!-- Stats Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Total Revenue</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">$${totalRevenue}</p>
                        </div>
                        <div class="w-14 h-14 rounded-xl flex items-center justify-center" style="background: linear-gradient(135deg, #d4f0e1, #a7f3d0);">
                            <i class="fas fa-dollar-sign text-2xl text-green-700"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Total Bookings</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">${totalBookings}</p>
                        </div>
                        <div class="w-14 h-14 rounded-xl flex items-center justify-center" style="background: linear-gradient(135deg, #dbeafe, #bfdbfe);">
                            <i class="fas fa-calendar-check text-2xl text-blue-700"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Total Rooms</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">${totalRooms}</p>
                        </div>
                        <div class="w-14 h-14 rounded-xl flex items-center justify-center" style="background: linear-gradient(135deg, #fce7f3, #fbcfe8);">
                            <i class="fas fa-door-closed text-2xl text-pink-700"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Registered Users</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">${totalUsers}</p>
                        </div>
                        <div class="w-14 h-14 rounded-xl flex items-center justify-center" style="background: linear-gradient(135deg, #ede9fe, #ddd6fe);">
                            <i class="fas fa-users text-2xl text-purple-700"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Current Occupancy</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">${occupancy} rooms</p>
                        </div>
                        <div class="w-14 h-14 rounded-xl flex items-center justify-center" style="background: linear-gradient(135deg, #fef3c7, #fde68a);">
                            <i class="fas fa-bed text-2xl text-amber-700"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-400 text-sm font-medium">Occupancy Rate</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1">${occupancyRate}%</p>
                        </div>
                        <div class="w-14 h-14 rounded-xl flex items-center justify-center" style="background: linear-gradient(135deg, #ccfbf1, #99f6e4);">
                            <i class="fas fa-chart-pie text-2xl text-teal-700"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <a href="${pageContext.request.contextPath}/admin/rooms" class="card p-6 text-center hover:shadow-lg group">
                    <i class="fas fa-door-closed text-3xl mb-3 transition group-hover:scale-110" style="color: #1e3a5f;"></i>
                    <h3 class="font-bold text-gray-800">Manage Rooms</h3>
                    <p class="text-gray-400 text-sm mt-1">Add, edit, or remove rooms</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/bookings" class="card p-6 text-center hover:shadow-lg group">
                    <i class="fas fa-calendar-alt text-3xl mb-3 transition group-hover:scale-110" style="color: #c8a45a;"></i>
                    <h3 class="font-bold text-gray-800">Manage Bookings</h3>
                    <p class="text-gray-400 text-sm mt-1">View and update bookings</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="card p-6 text-center hover:shadow-lg group">
                    <i class="fas fa-users text-3xl mb-3 transition group-hover:scale-110 text-purple-600"></i>
                    <h3 class="font-bold text-gray-800">Manage Users</h3>
                    <p class="text-gray-400 text-sm mt-1">User roles and accounts</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="card p-6 text-center hover:shadow-lg group">
                    <i class="fas fa-chart-bar text-3xl mb-3 transition group-hover:scale-110 text-green-600"></i>
                    <h3 class="font-bold text-gray-800">Reports</h3>
                    <p class="text-gray-400 text-sm mt-1">Revenue and occupancy data</p>
                </a>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

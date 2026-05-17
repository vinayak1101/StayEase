<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Admin - StayEase</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
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
                <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/rooms"><i class="fas fa-door-closed"></i> Manage Rooms</a>
                <a href="${pageContext.request.contextPath}/admin/bookings"><i class="fas fa-calendar-alt"></i> Manage Bookings</a>
                <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Manage Users</a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="active"><i class="fas fa-chart-bar"></i> Reports</a>
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-globe"></i> View Website</a>
            </div>
        </aside>

        <main class="main-with-sidebar page-content">
            <h1 class="text-3xl font-bold text-gray-800 mb-2" style="font-family: 'Playfair Display', serif;">Reports & Analytics</h1>
            <p class="text-gray-500 mb-8">Revenue, occupancy, and system statistics</p>

            <!-- Summary Stats -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="stat-card">
                    <p class="text-gray-400 text-sm font-medium">Total Revenue</p>
                    <p class="text-3xl font-bold mt-1" style="color: #059669;">$${totalRevenue}</p>
                </div>
                <div class="stat-card">
                    <p class="text-gray-400 text-sm font-medium">Total Bookings</p>
                    <p class="text-3xl font-bold text-gray-800 mt-1">${totalBookings}</p>
                </div>
                <div class="stat-card">
                    <p class="text-gray-400 text-sm font-medium">Occupancy Rate</p>
                    <p class="text-3xl font-bold mt-1" style="color: #1e3a5f;">${occupancyRate}%</p>
                </div>
                <div class="stat-card">
                    <p class="text-gray-400 text-sm font-medium">Registered Users</p>
                    <p class="text-3xl font-bold text-gray-800 mt-1">${totalUsers}</p>
                </div>
            </div>

            <!-- Charts -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                <!-- Monthly Revenue Chart -->
                <div class="card p-6">
                    <h2 class="text-xl font-bold text-gray-800 mb-4">
                        <i class="fas fa-chart-line mr-2" style="color: #c8a45a;"></i> Monthly Revenue
                    </h2>
                    <div style="height: 300px;">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <!-- Occupancy Gauge -->
                <div class="card p-6">
                    <h2 class="text-xl font-bold text-gray-800 mb-4">
                        <i class="fas fa-chart-pie mr-2" style="color: #1e3a5f;"></i> Room Occupancy
                    </h2>
                    <div style="height: 300px;">
                        <canvas id="occupancyChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Key Metrics Table -->
            <div class="card p-6">
                <h2 class="text-xl font-bold text-gray-800 mb-4">
                    <i class="fas fa-table mr-2 text-gray-400"></i> Key Metrics Summary
                </h2>
                <div class="overflow-x-auto">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Metric</th>
                                <th>Value</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="font-semibold">Total Revenue</td>
                                <td class="font-bold text-green-600">$${totalRevenue}</td>
                                <td class="text-sm text-gray-500">Sum of all non-cancelled bookings</td>
                            </tr>
                            <tr>
                                <td class="font-semibold">Total Bookings</td>
                                <td class="font-bold">${totalBookings}</td>
                                <td class="text-sm text-gray-500">All bookings including cancelled</td>
                            </tr>
                            <tr>
                                <td class="font-semibold">Total Rooms</td>
                                <td class="font-bold">${totalRooms}</td>
                                <td class="text-sm text-gray-500">All rooms in the system</td>
                            </tr>
                            <tr>
                                <td class="font-semibold">Current Occupancy Rate</td>
                                <td class="font-bold" style="color: #1e3a5f;">${occupancyRate}%</td>
                                <td class="text-sm text-gray-500">Active bookings today vs total rooms</td>
                            </tr>
                            <tr>
                                <td class="font-semibold">Registered Users</td>
                                <td class="font-bold">${totalUsers}</td>
                                <td class="text-sm text-gray-500">Guests, staff, and admin accounts</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Monthly Revenue Bar Chart
        const revenueData = ${monthlyRevenueJson};
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

        new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: {
                labels: months,
                datasets: [{
                    label: 'Revenue ($)',
                    data: revenueData,
                    backgroundColor: 'rgba(30, 58, 95, 0.7)',
                    borderColor: 'rgba(30, 58, 95, 1)',
                    borderWidth: 1,
                    borderRadius: 8,
                    hoverBackgroundColor: 'rgba(200, 164, 90, 0.8)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { callback: function(v) { return '$' + v; } },
                        grid: { color: 'rgba(0,0,0,0.05)' }
                    },
                    x: { grid: { display: false } }
                }
            }
        });

        // Occupancy Doughnut Chart
        const occupancyRate = parseFloat('${occupancyRate}');
        new Chart(document.getElementById('occupancyChart'), {
            type: 'doughnut',
            data: {
                labels: ['Occupied', 'Available'],
                datasets: [{
                    data: [occupancyRate, 100 - occupancyRate],
                    backgroundColor: ['rgba(30, 58, 95, 0.8)', 'rgba(229, 231, 235, 0.8)'],
                    borderWidth: 0,
                    hoverBackgroundColor: ['rgba(200, 164, 90, 0.9)', 'rgba(229, 231, 235, 1)']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: { position: 'bottom' },
                    tooltip: {
                        callbacks: {
                            label: function(ctx) { return ctx.label + ': ' + ctx.raw.toFixed(1) + '%'; }
                        }
                    }
                }
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

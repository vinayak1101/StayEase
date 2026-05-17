<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - Admin - StayEase</title>
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
                <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/rooms"><i class="fas fa-door-closed"></i> Manage Rooms</a>
                <a href="${pageContext.request.contextPath}/admin/bookings" class="active"><i class="fas fa-calendar-alt"></i> Manage Bookings</a>
                <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Manage Users</a>
                <a href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar"></i> Reports</a>
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-globe"></i> View Website</a>
            </div>
        </aside>

        <main class="main-with-sidebar page-content">
            <h1 class="text-3xl font-bold text-gray-800 mb-2" style="font-family: 'Playfair Display', serif;">Manage Bookings</h1>
            <p class="text-gray-500 mb-8">View, update, and manage all system bookings</p>

            <c:if test="${not empty success}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <div class="card overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Reference</th>
                                <th>Guest</th>
                                <th>Room</th>
                                <th>Check-In</th>
                                <th>Check-Out</th>
                                <th>Guests</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Special Requests</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td class="font-semibold text-sm">${b.bookingReference}</td>
                                    <td>
                                        <div class="text-sm font-medium">${b.userName}</div>
                                        <div class="text-xs text-gray-400">${b.userEmail}</div>
                                    </td>
                                    <td class="text-sm">${b.roomNumber}<br><span class="text-xs text-gray-400">${b.roomTypeName}</span></td>
                                    <td class="text-sm">${b.checkInDate}</td>
                                    <td class="text-sm">${b.checkOutDate}</td>
                                    <td class="text-sm text-center">${b.numberOfGuests}</td>
                                    <td class="text-sm font-bold">$<fmt:formatNumber value="${b.totalPrice}" pattern="#,##0.00"/></td>
                                    <td><span class="badge badge-${b.status}">${b.status}</span></td>
                                    <td class="text-xs text-gray-500 max-w-[150px] truncate">${b.specialRequests != null ? b.specialRequests : '-'}</td>
                                    <td>
                                        <c:if test="${b.status != 'cancelled' && b.status != 'checked_out'}">
                                            <form method="POST" action="${pageContext.request.contextPath}/admin/bookings" class="space-y-1">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                <select name="status" class="text-xs border rounded-lg px-2 py-1 w-full">
                                                    <option value="pending" ${b.status == 'pending' ? 'selected' : ''}>Pending</option>
                                                    <option value="confirmed" ${b.status == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                                    <option value="checked_in" ${b.status == 'checked_in' ? 'selected' : ''}>Checked In</option>
                                                    <option value="checked_out">Checked Out</option>
                                                    <option value="cancelled">Cancel</option>
                                                </select>
                                                <button type="submit" class="bg-blue-600 text-white text-xs px-3 py-1 rounded-lg hover:bg-blue-700 transition w-full">
                                                    Update
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${b.status == 'cancelled' || b.status == 'checked_out'}">
                                            <span class="text-xs text-gray-400 italic">Closed</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin - StayEase</title>
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
                <a href="${pageContext.request.contextPath}/admin/bookings"><i class="fas fa-calendar-alt"></i> Manage Bookings</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="active"><i class="fas fa-users"></i> Manage Users</a>
                <a href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar"></i> Reports</a>
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-globe"></i> View Website</a>
            </div>
        </aside>

        <main class="main-with-sidebar page-content">
            <h1 class="text-3xl font-bold text-gray-800 mb-2" style="font-family: 'Playfair Display', serif;">Manage Users</h1>
            <p class="text-gray-500 mb-8">View all registered users and manage their roles</p>

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
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Registered</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td class="text-sm text-gray-400">#${u.id}</td>
                                    <td>
                                        <div class="flex items-center gap-3">
                                            <div class="w-8 h-8 rounded-full flex items-center justify-center text-white text-xs font-bold"
                                                 style="background: linear-gradient(135deg, #1e3a5f, #2d5a8e);">
                                                ${u.fullName.substring(0,1)}
                                            </div>
                                            <span class="font-medium text-sm">${u.fullName}</span>
                                        </div>
                                    </td>
                                    <td class="text-sm">${u.email}</td>
                                    <td class="text-sm text-gray-500">${u.phone != null ? u.phone : '-'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 'admin'}">
                                                <span class="badge" style="background: #fee2e2; color: #991b1b;">Admin</span>
                                            </c:when>
                                            <c:when test="${u.role == 'staff'}">
                                                <span class="badge" style="background: #dbeafe; color: #1e40af;">Staff</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge" style="background: #f3f4f6; color: #374151;">Guest</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-sm text-gray-500">
                                        <fmt:formatDate value="${u.createdAt}" pattern="MMM dd, yyyy"/>
                                    </td>
                                    <td>
                                        <div class="flex gap-1">
                                            <form method="POST" action="${pageContext.request.contextPath}/admin/users" class="flex gap-1">
                                                <input type="hidden" name="action" value="updateRole">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <select name="role" class="text-xs border rounded-lg px-2 py-1">
                                                    <option value="guest" ${u.role == 'guest' ? 'selected' : ''}>Guest</option>
                                                    <option value="staff" ${u.role == 'staff' ? 'selected' : ''}>Staff</option>
                                                    <option value="admin" ${u.role == 'admin' ? 'selected' : ''}>Admin</option>
                                                </select>
                                                <button type="submit" class="bg-blue-600 text-white text-xs px-3 py-1 rounded-lg hover:bg-blue-700 transition">
                                                    Update
                                                </button>
                                            </form>
                                            <form method="POST" action="${pageContext.request.contextPath}/admin/users" onsubmit="return confirm('Are you sure you want to delete this user?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <button type="submit" class="bg-red-500 text-white text-xs px-3 py-1 rounded-lg hover:bg-red-600 transition h-full">
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
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

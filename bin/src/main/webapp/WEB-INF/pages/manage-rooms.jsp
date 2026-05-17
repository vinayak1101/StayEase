<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Rooms - Admin - StayEase</title>
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
                <a href="${pageContext.request.contextPath}/admin/rooms" class="active"><i class="fas fa-door-closed"></i> Manage Rooms</a>
                <a href="${pageContext.request.contextPath}/admin/bookings"><i class="fas fa-calendar-alt"></i> Manage Bookings</a>
                <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Manage Users</a>
                <a href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar"></i> Reports</a>
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-globe"></i> View Website</a>
            </div>
        </aside>

        <main class="main-with-sidebar page-content">
            <h1 class="text-3xl font-bold text-gray-800 mb-2" style="font-family: 'Playfair Display', serif;">Manage Rooms</h1>
            <p class="text-gray-500 mb-8">Add, edit, or remove hotel rooms</p>

            <c:if test="${not empty success}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <!-- Add / Edit Room Form -->
            <div class="card p-6 mb-8">
                <h2 class="text-xl font-bold text-gray-800 mb-4">
                    <c:choose>
                        <c:when test="${not empty editRoom}"><i class="fas fa-edit mr-2"></i> Edit Room</c:when>
                        <c:otherwise><i class="fas fa-plus-circle mr-2"></i> Add New Room</c:otherwise>
                    </c:choose>
                </h2>
                <form method="POST" action="${pageContext.request.contextPath}/admin/rooms" class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <c:choose>
                        <c:when test="${not empty editRoom}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="roomId" value="${editRoom.id}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="add">
                        </c:otherwise>
                    </c:choose>

                    <div>
                        <label class="form-label">Room Number *</label>
                        <input type="text" name="roomNumber" class="form-input" placeholder="e.g., 401"
                               value="${not empty editRoom ? editRoom.roomNumber : ''}" required>
                    </div>
                    <div>
                        <label class="form-label">Room Type *</label>
                        <select name="roomTypeId" class="form-select" required>
                            <c:forEach var="rt" items="${roomTypes}">
                                <option value="${rt.id}" ${not empty editRoom && editRoom.roomTypeId == rt.id ? 'selected' : ''}>${rt.typeName} ($${rt.basePrice}/night)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">Floor *</label>
                        <input type="number" name="floor" class="form-input" min="1" max="50" placeholder="e.g., 4"
                               value="${not empty editRoom ? editRoom.floor : ''}" required>
                    </div>
                    <div>
                        <label class="form-label">Status *</label>
                        <select name="status" class="form-select" required>
                            <option value="available" ${not empty editRoom && editRoom.status == 'available' ? 'selected' : ''}>Available</option>
                            <option value="occupied" ${not empty editRoom && editRoom.status == 'occupied' ? 'selected' : ''}>Occupied</option>
                            <option value="maintenance" ${not empty editRoom && editRoom.status == 'maintenance' ? 'selected' : ''}>Maintenance</option>
                        </select>
                    </div>
                    <div class="md:col-span-2">
                        <label class="form-label">Amenities</label>
                        <input type="text" name="amenities" class="form-input" placeholder="Wi-Fi, TV, Mini Bar, Jacuzzi"
                               value="${not empty editRoom ? editRoom.amenities : ''}">
                    </div>
                    <div class="flex items-end gap-2">
                        <button type="submit" class="btn-primary flex-1 justify-center">
                            <c:choose>
                                <c:when test="${not empty editRoom}"><i class="fas fa-save"></i> Update</c:when>
                                <c:otherwise><i class="fas fa-plus"></i> Add Room</c:otherwise>
                            </c:choose>
                        </button>
                        <c:if test="${not empty editRoom}">
                            <a href="${pageContext.request.contextPath}/admin/rooms" class="btn-danger py-3 px-4">Cancel</a>
                        </c:if>
                    </div>
                </form>
            </div>

            <!-- Room List -->
            <div class="card overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Room #</th>
                                <th>Type</th>
                                <th>Floor</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Amenities</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="room" items="${rooms}">
                                <tr>
                                    <td class="font-bold">${room.roomNumber}</td>
                                    <td>${room.roomTypeName}</td>
                                    <td>${room.floor}</td>
                                    <td class="font-semibold">$${room.price}</td>
                                    <td><span class="badge badge-${room.status}">${room.status}</span></td>
                                    <td class="text-xs text-gray-500 max-w-xs truncate">${room.amenities}</td>
                                    <td>
                                        <div class="flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/rooms?edit=${room.id}"
                                               class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            <form method="POST" action="${pageContext.request.contextPath}/admin/rooms" class="inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="roomId" value="${room.id}">
                                                <button type="submit" class="text-red-600 hover:text-red-800 text-sm font-medium"
                                                        onclick="return confirm('Delete room ${room.roomNumber}? This cannot be undone.');">
                                                    <i class="fas fa-trash"></i> Delete
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

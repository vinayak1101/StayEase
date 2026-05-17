package com.stayease.controllers;

import com.stayease.dao.UserDAO;
import com.stayease.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/pages/manage-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateRole".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String role = request.getParameter("role");
            if (userDAO.updateUserRole(userId, role)) {
                request.setAttribute("success", "User role updated.");
            } else {
                request.setAttribute("error", "Failed to update user role.");
            }
        } else if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            if (userDAO.deleteUser(userId)) {
                request.setAttribute("success", "User deleted successfully.");
            } else {
                request.setAttribute("error", "Failed to delete user. They might have active bookings.");
            }
        }
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/pages/manage-users.jsp").forward(request, response);
    }
}

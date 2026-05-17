package com.stayease.controllers;

import com.stayease.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);
            return;
        }

        String error = authService.resetPassword(email, password);
        if (error == null) {
            request.setAttribute("success", "Password successfully reset! Please login with your new password.");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", error);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);
        }
    }
}

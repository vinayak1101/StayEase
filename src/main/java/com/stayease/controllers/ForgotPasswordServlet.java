package com.stayease.controllers;

import com.stayease.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        boolean verified = authService.verifyUserForPasswordReset(email, phone);
        if (verified) {
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Verification failed. Please check your email and phone number.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(request, response);
        }
    }
}

package com.stayease.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.stayease.model.User;

import java.io.IOException;

/**
 * Authentication filter that protects admin, staff, and booking URLs.
 * Checks session for a logged-in user and verifies role-based access.
 */
@WebFilter(urlPatterns = {"/admin/*", "/staff/*", "/booking"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Role-based access control
        if (uri.startsWith(contextPath + "/admin") && !"admin".equals(user.getRole())) {
            httpResponse.sendRedirect(contextPath + "/home");
            return;
        }
        if (uri.startsWith(contextPath + "/staff") && !"staff".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            httpResponse.sendRedirect(contextPath + "/home");
            return;
        }

        chain.doFilter(request, response);
    }
}

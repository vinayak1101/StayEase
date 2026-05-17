package com.stayease.controllers;

import com.stayease.service.ReportService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("totalBookings", reportService.getTotalBookings());
        request.setAttribute("totalRooms", reportService.getTotalRooms());
        request.setAttribute("totalUsers", reportService.getTotalUsers());
        request.setAttribute("totalRevenue", String.format("%.2f", reportService.getTotalRevenue()));
        request.setAttribute("occupancy", reportService.getCurrentOccupancy());
        request.setAttribute("occupancyRate", String.format("%.1f", reportService.getOccupancyRate()));
        request.getRequestDispatcher("/WEB-INF/pages/admin-dashboard.jsp").forward(request, response);
    }
}

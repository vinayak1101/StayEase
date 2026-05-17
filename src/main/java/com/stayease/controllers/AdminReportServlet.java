package com.stayease.controllers;

import com.stayease.service.ReportService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("totalBookings", reportService.getTotalBookings());
        request.setAttribute("totalRevenue", String.format("%.2f", reportService.getTotalRevenue()));
        request.setAttribute("occupancyRate", String.format("%.1f", reportService.getOccupancyRate()));
        request.setAttribute("totalRooms", reportService.getTotalRooms());
        request.setAttribute("totalUsers", reportService.getTotalUsers());

        double[] monthlyRevenue = reportService.getMonthlyRevenue();
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < monthlyRevenue.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(monthlyRevenue[i]);
        }
        sb.append("]");
        request.setAttribute("monthlyRevenueJson", sb.toString());

        request.getRequestDispatcher("/WEB-INF/pages/reports.jsp").forward(request, response);
    }
}

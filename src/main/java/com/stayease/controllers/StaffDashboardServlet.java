package com.stayease.controllers;

import com.stayease.dao.BookingDAO;
import com.stayease.model.Booking;
import com.stayease.service.ReportService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Booking> todayCheckIns = bookingDAO.getTodayCheckIns();
        List<Booking> todayCheckOuts = bookingDAO.getTodayCheckOuts();
        request.setAttribute("todayCheckIns", todayCheckIns);
        request.setAttribute("todayCheckOuts", todayCheckOuts);
        request.setAttribute("totalBookings", reportService.getTotalBookings());
        request.setAttribute("occupancy", reportService.getCurrentOccupancy());
        request.setAttribute("occupancyRate", String.format("%.1f", reportService.getOccupancyRate()));
        request.getRequestDispatcher("/WEB-INF/pages/staff-dashboard.jsp").forward(request, response);
    }
}

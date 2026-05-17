package com.stayease.controllers;

import com.stayease.dao.BookingDAO;
import com.stayease.dao.PaymentDAO;
import com.stayease.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/bookings")
public class StaffBookingServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Booking> bookings = bookingDAO.getAllBookings();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/pages/staff-bookings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        if ("updateStatus".equals(action)) {
            String status = request.getParameter("status");
            bookingDAO.updateBookingStatus(bookingId, status);
            request.setAttribute("success", "Booking status updated to " + status + ".");
        } else if ("updatePayment".equals(action)) {
            String paymentStatus = request.getParameter("paymentStatus");
            String paymentMethod = request.getParameter("paymentMethod");
            String transactionId = request.getParameter("transactionId");
            paymentDAO.updatePaymentStatus(bookingId, paymentStatus, paymentMethod, transactionId);
            request.setAttribute("success", "Payment status updated.");
        }

        List<Booking> bookings = bookingDAO.getAllBookings();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/pages/staff-bookings.jsp").forward(request, response);
    }
}

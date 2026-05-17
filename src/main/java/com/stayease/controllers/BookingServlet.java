package com.stayease.controllers;

import com.stayease.dao.BookingDAO;
import com.stayease.dao.RoomDAO;
import com.stayease.model.Booking;
import com.stayease.model.Room;
import com.stayease.model.User;
import com.stayease.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    private final BookingService bookingService = new BookingService();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            // Show booking form for a specific room
            String roomIdStr = request.getParameter("roomId");
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            String guests = request.getParameter("guests");
            if (roomIdStr != null) {
                Room room = roomDAO.getRoomById(Integer.parseInt(roomIdStr));
                request.setAttribute("room", room);
                request.setAttribute("checkIn", checkIn);
                request.setAttribute("checkOut", checkOut);
                request.setAttribute("guests", guests);
            }
            request.getRequestDispatcher("/WEB-INF/pages/booking-form.jsp").forward(request, response);
        } else if ("view".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                Booking booking = bookingDAO.getBookingById(Integer.parseInt(idStr));
                if (booking != null && booking.getUserId() == user.getId()) {
                    request.setAttribute("booking", booking);
                }
            }
            request.getRequestDispatcher("/WEB-INF/pages/my-bookings.jsp").forward(request, response);
        } else {
            // Default: list user's bookings
            List<Booking> bookings = bookingDAO.getBookingsByUser(user.getId());
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/pages/my-bookings.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            int guests = Integer.parseInt(request.getParameter("guests"));
            String specialRequests = request.getParameter("specialRequests");

            String error = bookingService.createBooking(user.getId(), roomId, checkIn, checkOut, guests, specialRequests);
            if (error == null) {
                request.setAttribute("success", "Booking created successfully! You can view it in My Bookings.");
                List<Booking> bookings = bookingDAO.getBookingsByUser(user.getId());
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/pages/my-bookings.jsp").forward(request, response);
            } else {
                request.setAttribute("error", error);
                Room room = roomDAO.getRoomById(roomId);
                request.setAttribute("room", room);
                request.setAttribute("checkIn", checkIn);
                request.setAttribute("checkOut", checkOut);
                request.setAttribute("guests", String.valueOf(guests));
                request.getRequestDispatcher("/WEB-INF/pages/booking-form.jsp").forward(request, response);
            }
        } else if ("cancel".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String error = bookingService.cancelBooking(bookingId, user.getId());
            if (error == null) {
                request.setAttribute("success", "Booking cancelled successfully.");
            } else {
                request.setAttribute("error", error);
            }
            List<Booking> bookings = bookingDAO.getBookingsByUser(user.getId());
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/pages/my-bookings.jsp").forward(request, response);
        }
    }
}

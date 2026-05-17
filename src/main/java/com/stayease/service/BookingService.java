package com.stayease.service;

import com.stayease.dao.BookingDAO;
import com.stayease.dao.PaymentDAO;
import com.stayease.dao.RoomDAO;
import com.stayease.model.Booking;
import com.stayease.model.Payment;
import com.stayease.model.Room;
import com.stayease.utils.ValidationUtil;

import java.sql.Date;
import java.util.UUID;

/**
 * Service layer for booking business logic including validation and price calculation.
 */
public class BookingService {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    /**
     * Creates a booking after validating all inputs and checking availability.
     * Also creates a pending payment record.
     * @return null on success, or an error message on failure
     */
    public String createBooking(int userId, int roomId, String checkInStr, String checkOutStr,
                                 int numberOfGuests, String specialRequests) {
        // Validate dates
        if (!ValidationUtil.isValidDateString(checkInStr) || !ValidationUtil.isValidDateString(checkOutStr)) {
            return "Please provide valid check-in and check-out dates.";
        }
        Date checkIn = Date.valueOf(checkInStr);
        Date checkOut = Date.valueOf(checkOutStr);
        if (!ValidationUtil.isValidDateRange(checkIn, checkOut)) {
            return "Check-out date must be after check-in date, and dates cannot be in the past.";
        }

        // Validate room exists
        Room room = roomDAO.getRoomById(roomId);
        if (room == null) {
            return "Selected room does not exist.";
        }

        // Validate guest count against room capacity
        if (!ValidationUtil.isValidGuestCount(numberOfGuests, room.getCapacity())) {
            return "Number of guests exceeds room capacity of " + room.getCapacity() + ".";
        }

        // Check room availability for the date range
        if (!roomDAO.isRoomAvailable(roomId, checkIn, checkOut)) {
            return "This room is already booked for the selected dates. Please choose different dates or another room.";
        }

        // Calculate total price: price per night * number of nights
        long nights = (checkOut.getTime() - checkIn.getTime()) / (1000 * 60 * 60 * 24);
        double totalPrice = room.getPrice() * nights;

        // Generate unique booking reference
        String bookingRef = "STY-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // Create booking
        Booking booking = new Booking();
        booking.setBookingReference(bookingRef);
        booking.setUserId(userId);
        booking.setRoomId(roomId);
        booking.setCheckInDate(checkIn);
        booking.setCheckOutDate(checkOut);
        booking.setNumberOfGuests(numberOfGuests);
        booking.setTotalPrice(totalPrice);
        booking.setStatus("pending");
        booking.setSpecialRequests(specialRequests);

        int bookingId = bookingDAO.createBooking(booking);
        if (bookingId == -1) {
            return "Something went wrong while creating the booking. Please try again.";
        }

        // Create a pending payment record
        Payment payment = new Payment(bookingId, totalPrice, "pending", null, null);
        paymentDAO.createPayment(payment);

        return null; // Success
    }

    /**
     * Cancels a booking if it belongs to the user and is in a cancellable state.
     */
    public String cancelBooking(int bookingId, int userId) {
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            return "Booking not found.";
        }
        if (booking.getUserId() != userId) {
            return "You don't have permission to cancel this booking.";
        }
        if ("checked_in".equals(booking.getStatus()) || "checked_out".equals(booking.getStatus())) {
            return "Cannot cancel a booking that is already checked in or checked out.";
        }
        if ("cancelled".equals(booking.getStatus())) {
            return "This booking is already cancelled.";
        }
        boolean updated = bookingDAO.updateBookingStatus(bookingId, "cancelled");
        if (updated) {
            // Refund payment
            paymentDAO.updatePaymentStatus(bookingId, "refunded", null, null);
            return null;
        }
        return "Failed to cancel booking. Please try again.";
    }

    /**
     * Calculates price for a room over a date range.
     */
    public double calculatePrice(int roomId, Date checkIn, Date checkOut) {
        Room room = roomDAO.getRoomById(roomId);
        if (room == null || checkIn == null || checkOut == null) return 0;
        long nights = (checkOut.getTime() - checkIn.getTime()) / (1000 * 60 * 60 * 24);
        return room.getPrice() * Math.max(nights, 0);
    }
}

package com.stayease.dao;

import com.stayease.config.DBConfig;
import com.stayease.model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Booking operations.
 */
public class BookingDAO {

    /**
     * Creates a new booking and returns the generated booking ID, or -1 on failure.
     */
    public int createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (booking_reference, user_id, room_id, check_in_date, check_out_date, " +
                     "number_of_guests, total_price, status, special_requests) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, booking.getBookingReference());
            ps.setInt(2, booking.getUserId());
            ps.setInt(3, booking.getRoomId());
            ps.setDate(4, booking.getCheckInDate());
            ps.setDate(5, booking.getCheckOutDate());
            ps.setInt(6, booking.getNumberOfGuests());
            ps.setDouble(7, booking.getTotalPrice());
            ps.setString(8, booking.getStatus() != null ? booking.getStatus() : "pending");
            ps.setString(9, booking.getSpecialRequests());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Returns all bookings for a specific user, with room and type info.
     */
    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS user_name, u.email AS user_email, " +
                     "r.room_number, rt.type_name AS room_type_name " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id " +
                     "JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE b.user_id = ? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) bookings.add(mapResultSetToBooking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Returns all bookings in the system with user and room info.
     */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS user_name, u.email AS user_email, " +
                     "r.room_number, rt.type_name AS room_type_name " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id " +
                     "JOIN room_types rt ON r.room_type_id = rt.id " +
                     "ORDER BY b.booking_date DESC";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) bookings.add(mapResultSetToBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /** Updates the status of a booking. */
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Returns a single booking by its ID with user and room info. */
    public Booking getBookingById(int id) {
        String sql = "SELECT b.*, u.full_name AS user_name, u.email AS user_email, " +
                     "r.room_number, rt.type_name AS room_type_name " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id " +
                     "JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE b.id = ?";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToBooking(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Returns the count of active bookings overlapping with today (for occupancy). */
    public int getOccupancyCount() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status IN ('confirmed', 'checked_in') " +
                     "AND check_in_date <= CURDATE() AND check_out_date > CURDATE()";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Returns total booking count. */
    public int getBookingCount() {
        String sql = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Returns total revenue from non-cancelled bookings. */
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_price), 0) FROM bookings WHERE status != 'cancelled'";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Returns today's check-in bookings. */
    public List<Booking> getTodayCheckIns() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS user_name, u.email AS user_email, " +
                     "r.room_number, rt.type_name AS room_type_name " +
                     "FROM bookings b JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE b.check_in_date = CURDATE() AND b.status IN ('confirmed', 'pending') " +
                     "ORDER BY b.booking_date DESC";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) bookings.add(mapResultSetToBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /** Returns today's check-out bookings. */
    public List<Booking> getTodayCheckOuts() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS user_name, u.email AS user_email, " +
                     "r.room_number, rt.type_name AS room_type_name " +
                     "FROM bookings b JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE b.check_out_date = CURDATE() AND b.status = 'checked_in' " +
                     "ORDER BY b.booking_date DESC";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) bookings.add(mapResultSetToBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /** Returns monthly revenue for a given year (array of 12 doubles, Jan-Dec). */
    public double[] getMonthlyRevenue(int year) {
        double[] monthly = new double[12];
        String sql = "SELECT MONTH(booking_date) AS m, SUM(total_price) AS revenue " +
                     "FROM bookings WHERE YEAR(booking_date) = ? AND status != 'cancelled' " +
                     "GROUP BY MONTH(booking_date)";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    monthly[rs.getInt("m") - 1] = rs.getDouble("revenue");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return monthly;
    }

    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setBookingReference(rs.getString("booking_reference"));
        b.setUserId(rs.getInt("user_id"));
        b.setRoomId(rs.getInt("room_id"));
        b.setCheckInDate(rs.getDate("check_in_date"));
        b.setCheckOutDate(rs.getDate("check_out_date"));
        b.setNumberOfGuests(rs.getInt("number_of_guests"));
        b.setTotalPrice(rs.getDouble("total_price"));
        b.setStatus(rs.getString("status"));
        b.setSpecialRequests(rs.getString("special_requests"));
        b.setBookingDate(rs.getTimestamp("booking_date"));
        b.setUserName(rs.getString("user_name"));
        b.setUserEmail(rs.getString("user_email"));
        b.setRoomNumber(rs.getString("room_number"));
        b.setRoomTypeName(rs.getString("room_type_name"));
        return b;
    }
}

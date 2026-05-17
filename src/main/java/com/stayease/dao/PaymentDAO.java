package com.stayease.dao;

import com.stayease.config.DBConfig;
import com.stayease.model.Payment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Payment operations.
 */
public class PaymentDAO {

    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO payments (booking_id, amount, payment_status, payment_method, transaction_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "pending");
            ps.setString(4, payment.getPaymentMethod());
            ps.setString(5, payment.getTransactionId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePaymentStatus(int bookingId, String status, String method, String transactionId) {
        String sql = "UPDATE payments SET payment_status = ?, payment_method = ?, transaction_id = ? WHERE booking_id = ?";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, method);
            ps.setString(3, transactionId);
            ps.setInt(4, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Payment getPaymentByBookingId(int bookingId) {
        String sql = "SELECT p.*, b.booking_reference FROM payments p JOIN bookings b ON p.booking_id = b.id WHERE p.booking_id = ?";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment p = new Payment();
                    p.setId(rs.getInt("id"));
                    p.setBookingId(rs.getInt("booking_id"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setPaymentStatus(rs.getString("payment_status"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setTransactionId(rs.getString("transaction_id"));
                    p.setPaymentDate(rs.getTimestamp("payment_date"));
                    p.setBookingReference(rs.getString("booking_reference"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, b.booking_reference FROM payments p JOIN bookings b ON p.booking_id = b.id ORDER BY p.payment_date DESC";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment p = new Payment();
                p.setId(rs.getInt("id"));
                p.setBookingId(rs.getInt("booking_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setTransactionId(rs.getString("transaction_id"));
                p.setPaymentDate(rs.getTimestamp("payment_date"));
                p.setBookingReference(rs.getString("booking_reference"));
                payments.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
}

package com.stayease.service;

import com.stayease.dao.BookingDAO;
import com.stayease.dao.RoomDAO;
import com.stayease.dao.UserDAO;

import java.time.Year;

/**
 * Service layer for generating reports and statistics.
 */
public class ReportService {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final UserDAO userDAO = new UserDAO();

    public int getTotalBookings() {
        return bookingDAO.getBookingCount();
    }

    public int getTotalRooms() {
        return roomDAO.getRoomCount();
    }

    public int getTotalUsers() {
        return userDAO.getUserCount();
    }

    public double getTotalRevenue() {
        return bookingDAO.getTotalRevenue();
    }

    public int getCurrentOccupancy() {
        return bookingDAO.getOccupancyCount();
    }

    /**
     * Calculates occupancy rate as a percentage.
     */
    public double getOccupancyRate() {
        int totalRooms = getTotalRooms();
        if (totalRooms == 0) return 0;
        int occupied = getCurrentOccupancy();
        return (double) occupied / totalRooms * 100;
    }

    /**
     * Returns monthly revenue for the current year.
     */
    public double[] getMonthlyRevenue() {
        return bookingDAO.getMonthlyRevenue(Year.now().getValue());
    }
}

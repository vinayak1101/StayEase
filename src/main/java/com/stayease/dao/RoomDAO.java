package com.stayease.dao;

import com.stayease.config.DBConfig;
import com.stayease.model.Room;
import com.stayease.model.RoomType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Room and RoomType operations.
 */
public class RoomDAO {

    /**
     * Returns all rooms joined with their room type information.
     */
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, rt.base_price, rt.capacity, rt.description AS type_desc " +
                     "FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id ORDER BY r.room_number";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    /**
     * Returns rooms available for a given date range and minimum capacity.
     * Excludes rooms that have an active (non-cancelled) booking overlapping the dates,
     * and rooms in maintenance status.
     */
    public List<Room> getAvailableRooms(Date checkIn, Date checkOut, int guests) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, rt.base_price, rt.capacity, rt.description AS type_desc " +
                     "FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE r.status != 'maintenance' " +
                     "AND rt.capacity >= ? " +
                     "AND r.id NOT IN (" +
                     "  SELECT b.room_id FROM bookings b " +
                     "  WHERE b.status NOT IN ('cancelled', 'checked_out') " +
                     "  AND b.check_in_date < ? AND b.check_out_date > ?" +
                     ") ORDER BY rt.base_price ASC";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guests);
            ps.setDate(2, checkOut);
            ps.setDate(3, checkIn);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    /**
     * Returns a single room by its ID with type information.
     */
    public Room getRoomById(int id) {
        String sql = "SELECT r.*, rt.type_name, rt.base_price, rt.capacity, rt.description AS type_desc " +
                     "FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id WHERE r.id = ?";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRoom(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Adds a new room to the database.
     */
    public boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_number, room_type_id, floor, status, amenities) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomTypeId());
            ps.setInt(3, room.getFloor());
            ps.setString(4, room.getStatus() != null ? room.getStatus() : "available");
            ps.setString(5, room.getAmenities());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing room.
     */
    public boolean updateRoom(Room room) {
        String sql = "UPDATE rooms SET room_number = ?, room_type_id = ?, floor = ?, status = ?, amenities = ? WHERE id = ?";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomTypeId());
            ps.setInt(3, room.getFloor());
            ps.setString(4, room.getStatus());
            ps.setString(5, room.getAmenities());
            ps.setInt(6, room.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a room by ID.
     */
    public boolean deleteRoom(int id) {
        String sql = "DELETE FROM rooms WHERE id = ?";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns all room types.
     */
    public List<RoomType> getAllRoomTypes() {
        List<RoomType> types = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY base_price ASC";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getInt("id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setDescription(rs.getString("description"));
                rt.setCapacity(rs.getInt("capacity"));
                rt.setBasePrice(rs.getDouble("base_price"));
                types.add(rt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return types;
    }

    /**
     * Returns total count of rooms.
     */
    public int getRoomCount() {
        String sql = "SELECT COUNT(*) FROM rooms";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Checks if a room is available for the given date range (no overlapping active bookings).
     */
    public boolean isRoomAvailable(int roomId, Date checkIn, Date checkOut) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE room_id = ? " +
                     "AND status NOT IN ('cancelled', 'checked_out') " +
                     "AND check_in_date < ? AND check_out_date > ?";
        try (Connection conn = DBConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, checkOut);
            ps.setDate(3, checkIn);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setId(rs.getInt("id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomTypeId(rs.getInt("room_type_id"));
        room.setFloor(rs.getInt("floor"));
        room.setStatus(rs.getString("status"));
        room.setAmenities(rs.getString("amenities"));
        room.setRoomTypeName(rs.getString("type_name"));
        room.setPrice(rs.getDouble("base_price"));
        room.setCapacity(rs.getInt("capacity"));
        room.setTypeDescription(rs.getString("type_desc"));
        return room;
    }
}

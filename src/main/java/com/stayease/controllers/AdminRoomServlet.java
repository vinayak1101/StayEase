package com.stayease.controllers;

import com.stayease.dao.RoomDAO;
import com.stayease.model.Room;
import com.stayease.model.RoomType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/rooms")
public class AdminRoomServlet extends HttpServlet {
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Room> rooms = roomDAO.getAllRooms();
        List<RoomType> roomTypes = roomDAO.getAllRoomTypes();
        request.setAttribute("rooms", rooms);
        request.setAttribute("roomTypes", roomTypes);

        // If editing, load the room
        String editId = request.getParameter("edit");
        if (editId != null) {
            Room editRoom = roomDAO.getRoomById(Integer.parseInt(editId));
            request.setAttribute("editRoom", editRoom);
        }

        request.getRequestDispatcher("/WEB-INF/pages/manage-rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Room room = new Room();
            room.setRoomNumber(request.getParameter("roomNumber"));
            room.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
            room.setFloor(Integer.parseInt(request.getParameter("floor")));
            room.setStatus(request.getParameter("status"));
            room.setAmenities(request.getParameter("amenities"));
            if (roomDAO.addRoom(room)) {
                request.setAttribute("success", "Room added successfully.");
            } else {
                request.setAttribute("error", "Failed to add room. Room number may already exist.");
            }
        } else if ("update".equals(action)) {
            Room room = new Room();
            room.setId(Integer.parseInt(request.getParameter("roomId")));
            room.setRoomNumber(request.getParameter("roomNumber"));
            room.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
            room.setFloor(Integer.parseInt(request.getParameter("floor")));
            room.setStatus(request.getParameter("status"));
            room.setAmenities(request.getParameter("amenities"));
            if (roomDAO.updateRoom(room)) {
                request.setAttribute("success", "Room updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update room.");
            }
        } else if ("delete".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            if (roomDAO.deleteRoom(roomId)) {
                request.setAttribute("success", "Room deleted successfully.");
            } else {
                request.setAttribute("error", "Failed to delete room. It may have existing bookings.");
            }
        }

        List<Room> rooms = roomDAO.getAllRooms();
        List<RoomType> roomTypes = roomDAO.getAllRoomTypes();
        request.setAttribute("rooms", rooms);
        request.setAttribute("roomTypes", roomTypes);
        request.getRequestDispatcher("/WEB-INF/pages/manage-rooms.jsp").forward(request, response);
    }
}

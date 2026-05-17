package com.stayease.controllers;

import com.stayease.dao.RoomDAO;
import com.stayease.model.Room;
import com.stayease.model.RoomType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/rooms")
public class RoomServlet extends HttpServlet {
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String guestsStr = request.getParameter("guests");

        List<Room> rooms;
        if (checkIn != null && checkOut != null && guestsStr != null &&
            !checkIn.isEmpty() && !checkOut.isEmpty() && !guestsStr.isEmpty()) {
            try {
                Date checkInDate = Date.valueOf(checkIn);
                Date checkOutDate = Date.valueOf(checkOut);
                int guests = Integer.parseInt(guestsStr);
                rooms = roomDAO.getAvailableRooms(checkInDate, checkOutDate, guests);
                request.setAttribute("checkIn", checkIn);
                request.setAttribute("checkOut", checkOut);
                request.setAttribute("guests", guestsStr);
                request.setAttribute("searchPerformed", true);
            } catch (Exception e) {
                rooms = roomDAO.getAllRooms();
                request.setAttribute("error", "Invalid search parameters. Showing all rooms.");
            }
        } else {
            rooms = roomDAO.getAllRooms();
        }

        List<RoomType> roomTypes = roomDAO.getAllRoomTypes();
        request.setAttribute("rooms", rooms);
        request.setAttribute("roomTypes", roomTypes);
        request.getRequestDispatcher("/WEB-INF/pages/rooms.jsp").forward(request, response);
    }
}

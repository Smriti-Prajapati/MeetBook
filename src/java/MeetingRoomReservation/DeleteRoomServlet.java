package MeetingRoomReservation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteRoomServlet")
public class DeleteRoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int roomId = Integer.parseInt(request.getParameter("room_id"));

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Delete related amenities entries for this room
            String deleteAmenitiesSQL = "DELETE FROM room_amenities_link WHERE room_id = ?";
            try (PreparedStatement psAmenities = conn.prepareStatement(deleteAmenitiesSQL)) {
                psAmenities.setInt(1, roomId);
                psAmenities.executeUpdate();
            }

            // 2. Delete the room itself
            String deleteRoomSQL = "DELETE FROM meeting_room_master WHERE room_id = ?";
            try (PreparedStatement psRoom = conn.prepareStatement(deleteRoomSQL)) {
                psRoom.setInt(1, roomId);
                psRoom.executeUpdate();
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("manageRooms.jsp");
    }
}

package MeetingRoomReservation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddRoomServlet")
public class AddRoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String roomName = request.getParameter("room_name");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        int buildingId = Integer.parseInt(request.getParameter("building_id"));
        boolean isAvailable = "1".equals(request.getParameter("is_available"));

        String[] amenities = request.getParameterValues("amenities");

        String redirectURL = "manageRooms.jsp?status=success";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);  // Start transaction

            String insertRoomSQL = "INSERT INTO meeting_room_master (room_name, capacity, building_id, is_available) VALUES (?, ?, ?, ?)";
            int roomId = -1;

            try (PreparedStatement ps = conn.prepareStatement(insertRoomSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, roomName);
                ps.setInt(2, capacity);
                ps.setInt(3, buildingId);
                ps.setBoolean(4, isAvailable);
                int affectedRows = ps.executeUpdate();

                if (affectedRows == 0) {
                    throw new Exception("Creating room failed, no rows affected.");
                }

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        roomId = generatedKeys.getInt(1);
                    } else {
                        throw new Exception("Creating room failed, no ID obtained.");
                    }
                }
            }

            // Insert amenities if any selected
            if (amenities != null && roomId != -1) {
                String insertAmenitySQL = "INSERT INTO room_amenities_link (room_id, amenity_id) VALUES (?, ?)";
                try (PreparedStatement psAmenity = conn.prepareStatement(insertAmenitySQL)) {
                    for (String amenityIdStr : amenities) {
                        int amenityId = Integer.parseInt(amenityIdStr);
                        psAmenity.setInt(1, roomId);
                        psAmenity.setInt(2, amenityId);
                        psAmenity.addBatch();
                    }
                    psAmenity.executeBatch();
                }
            }

            conn.commit();  // Commit transaction

        } catch (Exception e) {
            e.printStackTrace();
            redirectURL = "manageRooms.jsp?status=error";
            // Rollback on error
            try (Connection conn = DBConnection.getConnection()) {
                conn.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }

        response.sendRedirect(redirectURL);
    }
}

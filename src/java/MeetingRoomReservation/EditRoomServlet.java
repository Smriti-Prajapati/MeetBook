package MeetingRoomReservation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditRoomServlet")
public class EditRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int roomId = Integer.parseInt(request.getParameter("room_id"));
        String roomName = request.getParameter("room_name");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        int buildingId = Integer.parseInt(request.getParameter("building_id"));
        boolean isAvailable = "1".equals(request.getParameter("is_available"));

        // Get selected amenities from form (can be null if none selected)
        String[] amenities = request.getParameterValues("amenities");

        String redirectURL = "manageRooms.jsp?status=edited";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);  // Start transaction

            // 1. Update room details
            String updateRoomSQL = "UPDATE meeting_room_master SET room_name = ?, capacity = ?, building_id = ?, is_available = ? WHERE room_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateRoomSQL)) {
                ps.setString(1, roomName);
                ps.setInt(2, capacity);
                ps.setInt(3, buildingId);
                ps.setBoolean(4, isAvailable);
                ps.setInt(5, roomId);
                ps.executeUpdate();
            }

            // 2. Delete existing amenities linked to this room
            String deleteAmenitiesSQL = "DELETE FROM room_amenities_link WHERE room_id = ?";
            try (PreparedStatement psDelete = conn.prepareStatement(deleteAmenitiesSQL)) {
                psDelete.setInt(1, roomId);
                psDelete.executeUpdate();
            }

            // 3. Insert newly selected amenities, if any
            if (amenities != null) {
                String insertAmenitySQL = "INSERT INTO room_amenities_link (room_id, amenity_id) VALUES (?, ?)";
                try (PreparedStatement psInsert = conn.prepareStatement(insertAmenitySQL)) {
                    for (String amenityIdStr : amenities) {
                        int amenityId = Integer.parseInt(amenityIdStr);
                        psInsert.setInt(1, roomId);
                        psInsert.setInt(2, amenityId);
                        psInsert.addBatch();
                    }
                    psInsert.executeBatch();
                }
            }

            conn.commit();  // Commit transaction

        } catch (Exception e) {
            e.printStackTrace();
            redirectURL = "manageRooms.jsp?status=error";
            try {
                if (conn != null) {
                    conn.rollback();  // Rollback on error
                }
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) {
                    conn.close();  // Close connection
                }
            } catch (Exception closeEx) {
                closeEx.printStackTrace();
            }
        }

        response.sendRedirect(redirectURL);
    }
}

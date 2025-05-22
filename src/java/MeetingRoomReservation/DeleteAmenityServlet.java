package MeetingRoomReservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/DeleteAmenityServlet")
public class DeleteAmenityServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int amenityId = Integer.parseInt(request.getParameter("amenity_id"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM amenities_master WHERE amenity_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, amenityId);
                ps.executeUpdate();
            }
            response.sendRedirect("manageAmenities.jsp?status=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageAmenities.jsp?status=error");
        }
    }
}

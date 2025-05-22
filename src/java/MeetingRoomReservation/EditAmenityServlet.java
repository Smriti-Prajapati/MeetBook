package MeetingRoomReservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/EditAmenityServlet")
public class EditAmenityServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int amenityId = Integer.parseInt(request.getParameter("amenity_id"));
        String amenityName = request.getParameter("amenity_name");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE amenities_master SET amenity_name = ? WHERE amenity_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, amenityName);
                ps.setInt(2, amenityId);
                ps.executeUpdate();
            }
            response.sendRedirect("manageAmenities.jsp?status=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageAmenities.jsp?status=error");
        }
    }
}

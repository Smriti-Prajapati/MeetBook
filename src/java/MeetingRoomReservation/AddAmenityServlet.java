package MeetingRoomReservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AddAmenityServlet")
public class AddAmenityServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String amenityName = request.getParameter("amenity_name");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO amenities_master (amenity_name) VALUES (?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, amenityName);
                ps.executeUpdate();
            }
            response.sendRedirect("manageAmenities.jsp?status=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageAmenities.jsp?status=error");
        }
    }
}

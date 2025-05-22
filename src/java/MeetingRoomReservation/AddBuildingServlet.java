package MeetingRoomReservation;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AddBuildingServlet")
public class AddBuildingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String buildingName = request.getParameter("building_name");
        String city = request.getParameter("city");

        if (buildingName == null || buildingName.isEmpty() || city == null || city.isEmpty()) {
            response.sendRedirect("manageBuildings.jsp?status=error&msg=Missing+fields");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO building_master (building_name, city) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, buildingName);
            ps.setString(2, city);
            ps.executeUpdate();

            response.sendRedirect("manageBuildings.jsp?status=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageBuildings.jsp?status=error");
        }
    }
}

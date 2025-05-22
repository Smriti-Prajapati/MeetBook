package MeetingRoomReservation;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DeleteBuildingServlet")
public class DeleteBuildingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int buildingId = Integer.parseInt(request.getParameter("building_id"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM building_master WHERE building_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, buildingId);
            ps.executeUpdate();

            response.sendRedirect("manageBuildings.jsp?status=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageBuildings.jsp?status=error");
        }
    }
}

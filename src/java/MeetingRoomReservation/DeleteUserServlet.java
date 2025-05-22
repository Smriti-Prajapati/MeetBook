package MeetingRoomReservation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = DBConnection.getConnection()) {

            int userId = Integer.parseInt(request.getParameter("user_id"));

            PreparedStatement ps = conn.prepareStatement("DELETE FROM user_master WHERE user_id = ?");
            ps.setInt(1, userId);
            ps.executeUpdate();

            response.sendRedirect("manageUsers.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

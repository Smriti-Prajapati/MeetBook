package MeetingRoomReservation;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("user_id"));
        String loginName = request.getParameter("login_name");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        int roleId = Integer.parseInt(request.getParameter("role_id"));
        boolean isActive = "1".equals(request.getParameter("is_active"));

        try (Connection conn = DBConnection.getConnection()) {

            if (password != null && !password.trim().isEmpty()) {
                // Update with password
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE user_master SET login_name=?, first_name=?, last_name=?, email=?, mobile=?, password=?, role_id=?, is_active=? WHERE user_id=?"
                );
                ps.setString(1, loginName);
                ps.setString(2, firstName);
                ps.setString(3, lastName);
                ps.setString(4, email);
                ps.setString(5, mobile);
                ps.setString(6, password);
                ps.setInt(7, roleId);
                ps.setBoolean(8, isActive);
                ps.setInt(9, userId);
                ps.executeUpdate();
            } else {
                // Update without password
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE user_master SET login_name=?, first_name=?, last_name=?, email=?, mobile=?, role_id=?, is_active=? WHERE user_id=?"
                );
                ps.setString(1, loginName);
                ps.setString(2, firstName);
                ps.setString(3, lastName);
                ps.setString(4, email);
                ps.setString(5, mobile);
                ps.setInt(6, roleId);
                ps.setBoolean(7, isActive);
                ps.setInt(8, userId);
                ps.executeUpdate();
            }

            response.sendRedirect("manageUsers.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

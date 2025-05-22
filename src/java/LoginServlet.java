import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import MeetingRoomReservation.DBConnection;

@WebServlet(urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("login_name");
        String password = request.getParameter("password");

        PrintWriter out = response.getWriter();

        try (Connection conn = DBConnection.getConnection()) {

            String sql = "SELECT user_id, role_id FROM user_master WHERE login_name = ? AND password = ? AND is_active = TRUE";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int roleId = rs.getInt("role_id");
                int userId = rs.getInt("user_id");

                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role_id", roleId); 
                session.setAttribute("user_id", userId);

                // Redirect based on role
                switch (roleId) {
                    case 1:
                        response.sendRedirect("admin.jsp");
                        break;
                    case 2:
                        response.sendRedirect("support.jsp");
                        break;
                    case 3:
                        response.sendRedirect("user.jsp");
                        break;
                    default:
                        response.sendRedirect("index.jsp?error=invalid_role");
                }
            } else {
                response.sendRedirect("index.jsp?error=invalid_credentials");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h3>Database Error:</h3>");
            out.println("<pre>" + e.getMessage() + "</pre>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}

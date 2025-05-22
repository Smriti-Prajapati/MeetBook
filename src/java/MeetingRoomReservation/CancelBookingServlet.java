package MeetingRoomReservation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM reservation_master WHERE reservation_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, reservationId);
                ps.executeUpdate();
            }
            response.sendRedirect("viewMyBookings.jsp?status=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewMyBookings.jsp?status=error");
        }
    }
}

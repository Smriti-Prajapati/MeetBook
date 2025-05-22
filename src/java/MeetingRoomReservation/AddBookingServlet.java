package MeetingRoomReservation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddBookingServlet")
public class AddBookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        int roomId = Integer.parseInt(request.getParameter("room_id"));
        int slotId = Integer.parseInt(request.getParameter("slot_id"));
        String reservationDateStr = request.getParameter("reservation_date");

        try (Connection conn = DBConnection.getConnection()) {
            // Convert string to java.sql.Date
            Date reservationDate = Date.valueOf(reservationDateStr);

            // Step 1: Count current month bookings of this user
            String countSql = "SELECT COUNT(*) FROM reservation_master WHERE user_id = ? AND YEAR(reservation_date) = YEAR(?) AND MONTH(reservation_date) = MONTH(?)";
            try (PreparedStatement psCount = conn.prepareStatement(countSql)) {
                psCount.setInt(1, userId);
                psCount.setDate(2, reservationDate);
                psCount.setDate(3, reservationDate);
                ResultSet rs = psCount.executeQuery();

                int bookingCount = 0;
                if (rs.next()) {
                    bookingCount = rs.getInt(1);
                }

                if (bookingCount < 10) {
                    // Insert into reservation_master (normal booking)
                    String insertSql = "INSERT INTO reservation_master (user_id, room_id, slot_id, reservation_date) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setInt(1, userId);
                        psInsert.setInt(2, roomId);
                        psInsert.setInt(3, slotId);
                        psInsert.setDate(4, reservationDate);
                        psInsert.executeUpdate();
                    }
                    request.setAttribute("message", "Booking confirmed successfully!");
                } else {
                    // Insert into booking_requests with status 'Pending'
                    String insertRequestSql = "INSERT INTO booking_requests (user_id, room_id, slot_id, reservation_date, status) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement psRequest = conn.prepareStatement(insertRequestSql)) {
                        psRequest.setInt(1, userId);
                        psRequest.setInt(2, roomId);
                        psRequest.setInt(3, slotId);
                        psRequest.setDate(4, reservationDate);
                        psRequest.setString(5, "Pending");
                        psRequest.executeUpdate();
                    }
                    request.setAttribute("message", "Monthly booking limit reached. Your booking request is sent for admin approval.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error adding booking: " + e.getMessage());
        }

        // Forward to JSP to show the message (you can customize this page)
        request.getRequestDispatcher("bookingResult.jsp").forward(request, response);
    }
}

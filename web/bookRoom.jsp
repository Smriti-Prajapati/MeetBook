<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String[] roomIds = request.getParameterValues("room_ids");
    String[] slotIds = request.getParameterValues("slot_ids");
    String reservationDate = request.getParameter("reservation_date");
    String purpose = request.getParameter("purpose");

    String message = "";
    String alertClass = "alert-info"; // default
    int count = 0;

    if (roomIds != null && slotIds != null && reservationDate != null && purpose != null && !purpose.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetbook", "root", "15itirms");

            String insertQuery = "INSERT INTO reservation_master (user_id, room_id, reservation_date, slot_id, purpose) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(insertQuery);

            for (String roomId : roomIds) {
                for (String slotId : slotIds) {
                    String checkQuery = "SELECT COUNT(*) FROM reservation_master WHERE room_id = ? AND reservation_date = ? AND slot_id = ?";
                    try (PreparedStatement checkPs = con.prepareStatement(checkQuery)) {
                        checkPs.setInt(1, Integer.parseInt(roomId));
                        checkPs.setString(2, reservationDate);
                        checkPs.setInt(3, Integer.parseInt(slotId));

                        try (ResultSet rs = checkPs.executeQuery()) {
                            if (rs.next() && rs.getInt(1) == 0) {
                                ps.setInt(1, userId);
                                ps.setInt(2, Integer.parseInt(roomId));
                                ps.setString(3, reservationDate);
                                ps.setInt(4, Integer.parseInt(slotId));
                                ps.setString(5, purpose.trim());
                                ps.addBatch();
                                count++;
                            }
                        }
                    }
                }
            }

            if (count > 0) {
                ps.executeBatch();
                message = count + " slot(s) booked successfully!";
                alertClass = "alert-success";
            } else {
                message = "All selected slots are already booked.";
                alertClass = "alert-warning";
            }

        } catch (Exception e) {
            message = "Error occurred: " + e.getMessage();
            alertClass = "alert-danger";
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception ignored) {}
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
    } else {
        message = "Missing booking data. Please fill in all fields.";
        alertClass = "alert-danger";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Booking Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f1f5f9;
            font-family: 'Segoe UI', sans-serif;
        }
        .header-bar {
            background-color: #0d6efd;
            color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .card-custom {
            border-radius: 16px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            padding: 30px;
            background-color: white;
            max-width: 600px;
            margin: auto;
        }
        .btn-custom {
            border-radius: 12px;
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="header-bar text-center">
        <h3 class="mb-0">Booking Status</h3>
    </div>

    <div class="card-custom text-center">
        <div class="alert <%= alertClass %>">
            <strong><%= message %></strong>
        </div>
        <a href="viewAvailableRooms.jsp" class="btn btn-outline-primary btn-custom mt-3">&larr; Back to Available Rooms</a>
    </div>
</div>

</body>
</html>

<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Unauthorized</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="alert alert-danger text-center p-4 rounded shadow">You must be logged in to view your bookings.</div>
    </div>
</body>
</html>
<%
        return;
    }

    String filter = request.getParameter("filter");
    if (filter == null) filter = "today";

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mm a", java.util.Locale.ENGLISH);
    LocalDate today = LocalDate.now();
    LocalDateTime now = LocalDateTime.now();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bookings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
        }
        .card-custom {
            border-radius: 16px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            padding: 24px;
            background-color: white;
        }
        .btn-custom {
            border-radius: 12px;
        }
        table {
            border-radius: 12px;
            overflow: hidden;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .filter-btns .btn {
            min-width: 100px;
            font-weight: 600;
        }
        .filter-btns {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center header-bar mb-4">
        <h3 class="mb-0">Bookings for <%= username %></h3>
        <a href="user.jsp" class="btn btn-light btn-sm btn-custom">Back to Dashboard</a>
    </div>

    <div class="card-custom">
        <div class="filter-btns d-flex justify-content-center gap-3 mb-3">
            <a href="?filter=today" class="btn btn-outline-primary <%= filter.equals("today") ? "active" : "" %>">Today</a>
            <a href="?filter=done" class="btn btn-outline-success <%= filter.equals("done") ? "active" : "" %>">Done</a>
            <a href="?filter=upcoming" class="btn btn-outline-warning <%= filter.equals("upcoming") ? "active" : "" %>">Upcoming</a>
        </div>

<%
    String url = "jdbc:mysql://localhost:3306/meetbook";
    String dbUser = "root";
    String dbPassword = "15itirms";

    try (
        Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);
        PreparedStatement pst = conn.prepareStatement(
            "SELECT r.reservation_id, m.room_name, r.reservation_date, s.time_slot " +
            "FROM reservation_master r " +
            "JOIN meeting_room_master m ON r.room_id = m.room_id " +
            "JOIN slot_master s ON r.slot_id = s.slot_id " +
            "JOIN user_master u ON r.user_id = u.user_id " +
            "WHERE u.login_name = ? " +
            "ORDER BY r.reservation_date ASC, s.time_slot ASC"
        );
    ) {
        pst.setString(1, username);
        ResultSet rs = pst.executeQuery();

        java.util.List<java.util.Map<String, Object>> bookings = new java.util.ArrayList<>();

        while (rs.next()) {
            int reservationId = rs.getInt("reservation_id");
            String roomName = rs.getString("room_name");
            Date bookingDate = rs.getDate("reservation_date");
            String timeSlot = rs.getString("time_slot");

            // Parse start time from slot
            LocalTime startTime = null;
            try {
                String startTimeStr = timeSlot.split("-")[0].trim();
                startTime = LocalTime.parse(startTimeStr, formatter);
            } catch (Exception e) {
                startTime = null;
            }

            LocalDateTime bookingDateTime = null;
            if (bookingDate != null && startTime != null) {
                bookingDateTime = LocalDateTime.of(bookingDate.toLocalDate(), startTime);
            }

            java.util.Map<String, Object> booking = new java.util.HashMap<>();
            booking.put("reservationId", reservationId);
            booking.put("roomName", roomName);
            booking.put("bookingDate", bookingDate);
            booking.put("timeSlot", timeSlot);
            booking.put("bookingDateTime", bookingDateTime);
            bookings.add(booking);
        }

        if (bookings.isEmpty()) {
%>
            <div class="alert alert-warning text-center">No bookings found.</div>
<%
        } else {
%>
            <div class="table-responsive">
                <table class="table table-bordered align-middle text-center">
                    <thead class="table-primary">
                        <tr>
                            <th>Booking ID</th>
                            <th>Room Name</th>
                            <th>Booking Date</th>
                            <th>Time Slot</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
<%
            for (java.util.Map<String, Object> b : bookings) {
                int reservationId = (Integer) b.get("reservationId");
                String roomName = (String) b.get("roomName");
                Date bookingDate = (Date) b.get("bookingDate");
                String timeSlot = (String) b.get("timeSlot");
                LocalDateTime bookingDateTime = (LocalDateTime) b.get("bookingDateTime");

                if (bookingDateTime == null) continue;

                LocalDate bookingLocalDate = bookingDate.toLocalDate();

                boolean isPast = bookingDateTime.isBefore(now);

                // Filtering logic
                boolean showRow = false;

                switch (filter) {
                    case "today":
                        // Show only today's bookings
                        if (bookingLocalDate.equals(today)) {
                            showRow = true;
                        }
                        break;

                    case "done":
                        // Show all past bookings (before now)
                        if (isPast) {
                            showRow = true;
                        }
                        break;

                    case "upcoming":
                        // Show future bookings after today OR today but in future time
                        if (bookingLocalDate.isAfter(today) ||
                            (bookingLocalDate.equals(today) && !isPast)) {
                            showRow = true;
                        }
                        break;

                    default:
                        showRow = true;
                        break;
                }

                if (!showRow) continue;
%>
                        <tr>
                            <td><%= reservationId %></td>
                            <td><%= roomName %></td>
                            <td><%= bookingDate %></td>
                            <td><%= timeSlot %></td>
                            <td>
<%
                if (filter.equals("today")) {
                    // Instead of Done or Cancel, show "Today" in blue color
%>
                        <span class="text-primary fw-semibold" style="font-size: 1rem;">Today</span>
<%
                } else if (filter.equals("done")) {
%>
                            <span class="text-success fw-semibold" style="font-size: 1rem;">Done</span>
<%
                } else if (filter.equals("upcoming")) {
%>
                                <form action="CancelBookingServlet" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking?');" style="margin:0;">
                                    <input type="hidden" name="reservationId" value="<%= reservationId %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                                </form>
<%
                } else {
                    // default fallback
                    if (isPast) {
%>
                                <span class="text-success fw-semibold" style="font-size: 1rem;">Done</span>
<%
                    } else {
%>
                                <form action="CancelBookingServlet" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking?');" style="margin:0;">
                                    <input type="hidden" name="reservationId" value="<%= reservationId %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                                </form>
<%
                    }
                }
%>
                            </td>
                        </tr>
<%
            } // end for
%>
                    </tbody>
                </table>
            </div>
<%
        }
        rs.close();
    } catch (Exception e) {
%>
        <div class="alert alert-danger mt-3">Error fetching bookings: <%= e.getMessage() %></div>
<%
        e.printStackTrace();
    }
%>
    </div>
</div>

</body>
</html>

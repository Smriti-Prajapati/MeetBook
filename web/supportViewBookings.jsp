<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.time.*, java.time.format.DateTimeFormatter" %>
<%@ page session="true" %>
<%
    // Ensure user is logged in and role is support (assuming role_id=2)
    String username = (String) session.getAttribute("username");
    Integer roleId = (Integer) session.getAttribute("role_id");

    if (username == null || roleId == null || roleId != 2) {
        response.sendRedirect("index.jsp");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/meetbook";
    String dbUser = "root";
    String dbPassword = "15itirms";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>All Bookings - Support View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
        .filter-tabs {
            margin-bottom: 20px;
        }
        .filter-tabs .btn {
            border-radius: 12px;
            min-width: 100px;
        }
        .filter-tabs .btn.active {
            background-color: #0d6efd;
            color: white;
        }
    </style>
</head>
<body>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center header-bar mb-4">
        <h3 class="mb-0">All Room Bookings (Support View)</h3>
        <a href="support.jsp" class="btn btn-light btn-sm btn-custom">Back to Dashboard</a>
    </div>

    <div class="card-custom">
        <!-- Filter Tabs -->
        <div class="filter-tabs d-flex justify-content-center gap-3">
            <button id="btnToday" class="btn btn-outline-primary active" onclick="filterBookings('today')">Today</button>
            <button id="btnDone" class="btn btn-outline-success" onclick="filterBookings('done')">Done</button>
            <button id="btnUpcoming" class="btn btn-outline-warning" onclick="filterBookings('upcoming')">Upcoming</button>
        </div>

        <div class="table-responsive">
            <%
                try (
                    Connection con = DriverManager.getConnection(url, dbUser, dbPassword);
                    PreparedStatement ps = con.prepareStatement(
                        "SELECT r.reservation_id, u.login_name, rm.room_name, bm.building_name, rm.capacity, " +
                        "r.reservation_date, sm.time_slot, r.purpose, " +
                        "GROUP_CONCAT(a.amenity_name SEPARATOR ', ') AS amenities " +
                        "FROM reservation_master r " +
                        "JOIN user_master u ON r.user_id = u.user_id " +
                        "JOIN meeting_room_master rm ON r.room_id = rm.room_id " +
                        "JOIN building_master bm ON rm.building_id = bm.building_id " +
                        "JOIN slot_master sm ON r.slot_id = sm.slot_id " +
                        "LEFT JOIN room_amenities_link ral ON rm.room_id = ral.room_id " +
                        "LEFT JOIN amenities_master a ON ral.amenity_id = a.amenity_id " +
                        "GROUP BY r.reservation_id " +
                        "ORDER BY r.reservation_date ASC, sm.slot_id ASC"
                    );
                    ResultSet rs = ps.executeQuery();
                ) {
                    if (!rs.isBeforeFirst()) {
            %>
                        <div class="alert alert-warning text-center">No bookings found.</div>
            <%
                    } else {
                        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a", java.util.Locale.ENGLISH);
                        LocalDate today = LocalDate.now();
                        LocalTime currentTime = LocalTime.now();

                        StringBuilder allRows = new StringBuilder();
                        while (rs.next()) {
                            int reservationId = rs.getInt("reservation_id");
                            String loginName = rs.getString("login_name");
                            String roomName = rs.getString("room_name");
                            String buildingName = rs.getString("building_name");
                            int capacity = rs.getInt("capacity");
                            Date reservationDate = rs.getDate("reservation_date");
                            String timeSlot = rs.getString("time_slot");
                            String purpose = rs.getString("purpose");
                            if (purpose == null || purpose.trim().isEmpty()) {
                                purpose = "-";
                            }
                            String amenities = rs.getString("amenities");
                            if (amenities == null) {
                                amenities = "-";
                            }

                            // Determine booking status: done, today, upcoming
                            boolean isPast = false;
                            boolean isToday = false;
                            boolean isUpcoming = false;
                            try {
                                LocalDate reservationLocalDate = reservationDate.toLocalDate();

                                if (reservationLocalDate.isBefore(today)) {
                                    isPast = true;
                                } else if (reservationLocalDate.isEqual(today)) {
                                    isToday = true;
                                    String startTimeStr = timeSlot.split("-")[0].trim();
                                    LocalTime slotStartTime = LocalTime.parse(startTimeStr, timeFormatter);
                                    if (slotStartTime.isBefore(currentTime)) {
                                        isPast = true; // slot time passed means done
                                        isToday = false;
                                    } else {
                                        isUpcoming = true;
                                        isToday = false;
                                    }
                                } else if (reservationLocalDate.isAfter(today)) {
                                    isUpcoming = true;
                                }
                            } catch (Exception ex) {
                                // Ignore parsing errors
                            }

                            allRows.append("<tr data-status='")
                                   .append(isPast ? "done" : (isToday ? "today" : (isUpcoming ? "upcoming" : "unknown")))
                                   .append("'>");
                            allRows.append("<td>").append(reservationId).append("</td>");
                            allRows.append("<td>").append(loginName).append("</td>");
                            allRows.append("<td>").append(roomName).append("</td>");
                            allRows.append("<td>").append(reservationDate).append("</td>");
                            allRows.append("<td>").append(timeSlot).append("</td>");
                            allRows.append("<td>").append(purpose).append("</td>");
                            allRows.append("<td>");
                            if (isPast) {
                                allRows.append("<span class='text-success fw-bold'>Done</span>");
                            } else if (isToday) {
                                allRows.append("<span class='text-primary fw-bold'>Today</span>");
                            } else if (isUpcoming) {
                                allRows.append("<span class='text-warning fw-bold'>Upcoming</span>");
                            } else {
                                allRows.append("-");
                            }
                            allRows.append("</td>");
                            allRows.append("<td>").append(amenities).append("</td>");
                            allRows.append("</tr>");
                        }
            %>
                        <table id="bookingTable" class="table table-bordered align-middle text-center">
                            <thead class="table-primary">
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Booked By</th>
                                    <th>Room</th>
                                    <th>Date</th>
                                    <th>Slot</th>
                                    <th>Purpose</th>
                                    <th>Status</th>
                                    <th>Amenities</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%= allRows.toString() %>
                            </tbody>
                        </table>
            <%
                    }
                } catch (Exception e) {
            %>
                <div class="alert alert-danger">Error: <%= e.getMessage() %></div>
            <%
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
</div>

<script>
    // Filter rows by booking status: today, done, upcoming
    function filterBookings(status) {
        // Remove active class from all buttons
        document.querySelectorAll('.filter-tabs .btn').forEach(btn => btn.classList.remove('active'));

        // Add active to clicked button
        if (status === 'today') {
            document.getElementById('btnToday').classList.add('active');
        } else if (status === 'done') {
            document.getElementById('btnDone').classList.add('active');
        } else if (status === 'upcoming') {
            document.getElementById('btnUpcoming').classList.add('active');
        }

        // Show/hide rows based on data-status attribute
        const rows = document.querySelectorAll('#bookingTable tbody tr');
        rows.forEach(row => {
            if (row.getAttribute('data-status') === status) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // On page load, filter to "Today" by default
    document.addEventListener('DOMContentLoaded', () => {
        filterBookings('today');
    });
</script>

</body>
</html>

<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    Integer roleId = (Integer) session.getAttribute("role_id");
    if (username == null || roleId == null || roleId != 1) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>All Bookings - Admin</title>
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
        .modal-content {
            border-radius: 16px;
        }
        .form-control {
            border-radius: 10px;
        }
        /* Custom styling for tab buttons */
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
        <h3 class="mb-0">All Room Bookings</h3>
        <a href="admin.jsp" class="btn btn-light btn-sm btn-custom">Back to Dashboard</a>
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
                String url = "jdbc:mysql://localhost:3306/meetbook";
                String dbUser = "root";
                String dbPassword = "15itirms";

                try (
                    Connection con = DriverManager.getConnection(url, dbUser, dbPassword);
                    PreparedStatement ps = con.prepareStatement(
                        "SELECT r.reservation_id, u.user_id, u.login_name, rm.room_id, rm.room_name, bm.building_name, rm.capacity, " +
                        "r.reservation_date, sm.slot_id, sm.time_slot, r.purpose " +
                        "FROM reservation_master r " +
                        "JOIN user_master u ON r.user_id = u.user_id " +
                        "JOIN meeting_room_master rm ON r.room_id = rm.room_id " +
                        "JOIN building_master bm ON rm.building_id = bm.building_id " +
                        "JOIN slot_master sm ON r.slot_id = sm.slot_id " +
                        "ORDER BY r.reservation_date ASC, sm.slot_id ASC"
                    );
                    ResultSet rs = ps.executeQuery();
                ) {
                    if (!rs.isBeforeFirst()) {
            %>
                        <div class="alert alert-warning text-center">No bookings found.</div>
            <%
                    } else {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a", java.util.Locale.ENGLISH);

                        // We'll build a table rows string in JSP to pass to JS for filtering.
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

                            boolean isPast = false;
                            boolean isToday = false;
                            boolean isUpcoming = false;
                            try {
                                LocalDate today = LocalDate.now();
                                LocalTime currentTime = LocalTime.now();
                                LocalDate reservationLocalDate = reservationDate.toLocalDate();

                                if (reservationLocalDate.isBefore(today)) {
                                    isPast = true;
                                } else if (reservationLocalDate.isEqual(today)) {
                                    isToday = true;
                                    String startTimeStr = timeSlot.split("-")[0].trim();
                                    LocalTime slotStartTime = LocalTime.parse(startTimeStr, formatter);
                                    if (slotStartTime.isBefore(currentTime)) {
                                        // Consider slot as done if time has passed
                                        isPast = true;
                                    } else {
                                        isUpcoming = true;
                                    }
                                } else if (reservationLocalDate.isAfter(today)) {
                                    isUpcoming = true;
                                }
                            } catch (Exception ex) {
                                // default false
                            }

                            // Encode these states as data attributes in <tr>
                            allRows.append("<tr data-status='")
                                   .append(isPast ? "done" : (isToday ? "today" : (isUpcoming ? "upcoming" : "unknown")))
                                   .append("'>");
                            allRows.append("<td>").append(loginName).append("</td>");
                            allRows.append("<td>").append(roomName).append("</td>");
                            allRows.append("<td>").append(buildingName).append("</td>");
                            allRows.append("<td>").append(capacity).append("</td>");
                            allRows.append("<td>").append(reservationDate).append("</td>");
                            allRows.append("<td>").append(timeSlot).append("</td>");
                            allRows.append("<td>").append(purpose).append("</td>");
                            allRows.append("<td>");
                            if (isPast) {
                                allRows.append("<span class='text-success fw-bold'>Done</span>");
                            } else {
                                allRows.append("<form action='DeleteBookingServlet' method='post' style='display:inline;'>")
                                       .append("<input type='hidden' name='reservation_id' value='").append(reservationId).append("' />")
                                       .append("<button type='submit' class='btn btn-danger btn-sm btn-custom' onclick=\"return confirm('Are you sure you want to delete this booking?');\">Delete</button>")
                                       .append("</form>");
                            }
                            allRows.append("</td>");
                            allRows.append("</tr>");
                        }
            %>
                        <table id="bookingTable" class="table table-bordered align-middle text-center">
                            <thead class="table-primary">
                                <tr>
                                    <th>User</th>
                                    <th>Room</th>
                                    <th>Building</th>
                                    <th>Capacity</th>
                                    <th>Date</th>
                                    <th>Slot</th>
                                    <th>Purpose</th>
                                    <th>Action</th>
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
    // JS function to filter rows based on booking status
    function filterBookings(status) {
        // Update active button styles
        document.querySelectorAll('.filter-tabs .btn').forEach(btn => btn.classList.remove('active'));
        if (status === 'today') {
            document.getElementById('btnToday').classList.add('active');
        } else if (status === 'done') {
            document.getElementById('btnDone').classList.add('active');
        } else if (status === 'upcoming') {
            document.getElementById('btnUpcoming').classList.add('active');
        }

        const rows = document.querySelectorAll('#bookingTable tbody tr');
        rows.forEach(row => {
            if (status === 'today' && row.dataset.status === 'today') {
                row.style.display = '';
            } else if (status === 'done' && row.dataset.status === 'done') {
                row.style.display = '';
            } else if (status === 'upcoming' && row.dataset.status === 'upcoming') {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });

        // If no rows visible, show a "No bookings found" message dynamically
        const tableBody = document.querySelector('#bookingTable tbody');
        const visibleRows = Array.from(rows).filter(r => r.style.display !== 'none');
        let noDataRow = document.getElementById('noDataRow');
        if (visibleRows.length === 0) {
            if (!noDataRow) {
                noDataRow = document.createElement('tr');
                noDataRow.id = 'noDataRow';
                noDataRow.innerHTML = "<td colspan='8' class='text-center'>No bookings found for " + status.charAt(0).toUpperCase() + status.slice(1) + ".</td>";
                tableBody.appendChild(noDataRow);
            }
        } else {
            if (noDataRow) noDataRow.remove();
        }
    }

    // On page load, filter to 'Today' bookings
    window.onload = function() {
        filterBookings('today');
    };
</script>

</body>
</html>

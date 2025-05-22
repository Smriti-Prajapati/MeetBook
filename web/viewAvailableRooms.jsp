<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<html>
<head>
    <title>Available Rooms</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f1f5f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            padding-top: 30px;
            padding-bottom: 30px;
            max-width: 900px;
        }
        .card-custom {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            padding: 30px;
        }
        h2 {
            font-weight: 700;
            color: #0d6efd;
            margin-bottom: 24px;
        }
        label {
            font-weight: 600;
            color: #333;
        }
        .btn-primary, .btn-success, .btn-secondary {
            border-radius: 12px;
            font-weight: 600;
            padding: 8px 20px;
        }
        .form-control, .form-select, textarea {
            border-radius: 10px;
        }
        .form-check-input {
            margin-top: 0.3rem;
        }
        .text-center.mb-3 button.btn-success:hover {
            transform: scale(1.05);
            transition: transform 0.3s ease-in-out;
        }
        .modal-content {
            border-radius: 16px;
        }
        .room-option {
            padding-left: 0;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card-custom">
        <h2 class="text-center">Book Meeting Rooms</h2>

        <!-- Date Selection Form -->
        <form method="get" action="viewAvailableRooms.jsp" class="mb-4 d-flex justify-content-center align-items-center gap-3 flex-wrap">
            <label for="dateInput" class="mb-0">Select Date:</label>
            <input id="dateInput" type="date" name="date" required
                   value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>"
                   min=""
                   class="form-control" style="max-width: 220px;">
            <button type="submit" class="btn btn-primary">View Available Rooms</button>
        </form>

        <%
            String selectedDate = request.getParameter("date");
            if (selectedDate != null && !selectedDate.isEmpty()) {
                Connection con = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetbook", "root", "15itirms");

                    Statement buildingStmt = con.createStatement();
                    ResultSet buildingRs = buildingStmt.executeQuery("SELECT * FROM building_master");
        %>

        <!-- Modal Trigger Button -->
        <div class="text-center mb-3">
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#bookingModal">Book Now</button>
        </div>

        <!-- Modal Structure -->
        <div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form action="bookRoom.jsp" method="post">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Book a Meeting Room</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="reservation_date" value="<%= selectedDate %>">

                            <div class="mb-3">
                                <label class="form-label">Select Building</label>
                                <select name="building_id" id="buildingDropdown" class="form-select" required onchange="filterRooms()">
                                    <option value="">-- Select Building --</option>
                                    <%
                                        while (buildingRs.next()) {
                                    %>
                                    <option value="<%= buildingRs.getInt("building_id") %>"><%= buildingRs.getString("building_name") %></option>
                                    <%
                                        }
                                        buildingRs.close();
                                    %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Select Rooms</label>
                                <div id="roomCheckboxes" class="form-check">
                                    <%
                                        Statement roomStmt = con.createStatement();
                                        ResultSet roomRs = roomStmt.executeQuery("SELECT room_id, room_name, building_id FROM meeting_room_master WHERE is_available = 1");

                                        while (roomRs.next()) {
                                    %>
                                    <div class="form-check room-option" data-building="<%= roomRs.getInt("building_id") %>">
                                        <input class="form-check-input" type="checkbox" name="room_ids" value="<%= roomRs.getInt("room_id") %>" id="room_<%= roomRs.getInt("room_id") %>">
                                        <label class="form-check-label" for="room_<%= roomRs.getInt("room_id") %>">
                                            <%= roomRs.getString("room_name") %>
                                        </label>
                                    </div>
                                    <%
                                        }
                                        roomRs.close();
                                    %>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Select Time Slots</label>
                                <%
                                    Statement slotStmt = con.createStatement();
                                    ResultSet slotRs = slotStmt.executeQuery("SELECT * FROM slot_master");

                                    while (slotRs.next()) {
                                %>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="slot_ids" value="<%= slotRs.getInt("slot_id") %>" id="slot_<%= slotRs.getInt("slot_id") %>">
                                    <label class="form-check-label" for="slot_<%= slotRs.getInt("slot_id") %>">
                                        <%= slotRs.getString("time_slot") %>
                                    </label>
                                </div>
                                <%
                                    }
                                    slotRs.close();
                                %>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Purpose of Meeting</label>
                                <textarea name="purpose" class="form-control" rows="3" placeholder="Enter purpose..." required></textarea>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Book Selected</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function filterRooms() {
                var selectedBuilding = document.getElementById("buildingDropdown").value;
                var roomOptions = document.querySelectorAll(".room-option");
                roomOptions.forEach(function(option) {
                    option.style.display = option.getAttribute("data-building") === selectedBuilding ? "block" : "none";
                });
            }
        </script>

        <%
                    con.close();
                } catch (Exception e) {
                    out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
            } else {
        %>
        <div class="alert alert-info text-center">
            Please select a date to view and book available rooms.
        </div>
        <%
            }
        %>
    </div>
</div>

<!-- JS to set min date to today -->
<script>
    window.onload = function () {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById("dateInput").setAttribute("min", today);
    };
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

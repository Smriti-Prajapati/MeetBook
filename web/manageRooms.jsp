<%@ page import="java.sql.*, MeetingRoomReservation.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Meeting Rooms</title>
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
            margin-bottom: 30px;
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
        .form-control, .form-select {
            border-radius: 10px;
        }
        .amenities-container {
            max-height: 150px; 
            overflow-y: auto; 
            border: 1px solid #ddd; 
            padding: 10px; 
            border-radius: 10px;
            background-color: #fafafa;
        }
    </style>
</head>
<body>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center header-bar">
        <h2 class="mb-0">Manage Meeting Rooms</h2>
        <a href="admin.jsp" class="btn btn-light btn-sm btn-custom">Back to Dashboard</a>
    </div>

    <div class="card-custom">
        <!-- Status Alerts -->
        <%
            String status = request.getParameter("status");
            if ("success".equals(status)) {
        %>
            <div class="alert alert-success">Operation successful!</div>
        <% } else if ("error".equals(status)) { %>
            <div class="alert alert-danger">Something went wrong!</div>
        <% } %>

        <!-- Add Room Button -->
        <div class="d-flex justify-content-end mb-4">
            <button class="btn btn-success btn-custom" data-bs-toggle="modal" data-bs-target="#addRoomModal">+ Add Room</button>
        </div>

        <!-- Add Room Modal -->
        <div class="modal fade" id="addRoomModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form action="AddRoomServlet" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add New Room</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="text" name="room_name" placeholder="Room Name" class="form-control mb-3" required />
                        <input type="number" name="capacity" placeholder="Capacity" class="form-control mb-3" min="1" required />
                        <select name="building_id" class="form-select mb-3" required>
                            <option value="" disabled selected>Select Building</option>
                            <%
                                Connection c1 = null;
                                PreparedStatement ps1 = null;
                                ResultSet rs1 = null;
                                try {
                                    c1 = DBConnection.getConnection();
                                    ps1 = c1.prepareStatement("SELECT building_id, building_name FROM building_master");
                                    rs1 = ps1.executeQuery();
                                    while (rs1.next()) {
                            %>
                                <option value="<%= rs1.getInt("building_id") %>"><%= rs1.getString("building_name") %></option>
                            <%
                                    }
                                } catch(Exception e) {
                                    out.println("<option disabled>Error loading buildings</option>");
                                } finally {
                                    if (rs1 != null) rs1.close();
                                    if (ps1 != null) ps1.close();
                                    if (c1 != null) c1.close();
                                }
                            %>
                        </select>
                        <select name="is_available" class="form-select mb-3" required>
                            <option value="1">Available</option>
                            <option value="0">Not Available</option>
                        </select>

                        <label><strong>Amenities:</strong></label>
                        <div class="amenities-container mb-3">
                            <%
                                Connection cAmen = null;
                                PreparedStatement psAmen = null;
                                ResultSet rsAmen = null;
                                try {
                                    cAmen = DBConnection.getConnection();
                                    psAmen = cAmen.prepareStatement("SELECT amenity_id, amenity_name FROM amenities_master");
                                    rsAmen = psAmen.executeQuery();
                                    while(rsAmen.next()) {
                            %>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="<%= rsAmen.getInt("amenity_id") %>" id="amenityAdd<%= rsAmen.getInt("amenity_id") %>"/>
                                    <label class="form-check-label" for="amenityAdd<%= rsAmen.getInt("amenity_id") %>"><%= rsAmen.getString("amenity_name") %></label>
                                </div>
                            <%
                                    }
                                } catch(Exception e) {
                                    out.println("<div class='text-danger'>Error loading amenities</div>");
                                } finally {
                                    if (rsAmen != null) rsAmen.close();
                                    if (psAmen != null) psAmen.close();
                                    if (cAmen != null) cAmen.close();
                                }
                            %>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary btn-custom">Add Room</button>
                        <button type="button" class="btn btn-secondary btn-custom" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Rooms Table -->
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Capacity</th>
                    <th>Building</th>
                    <th>Available</th>
                    <th>Amenities</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        conn = DBConnection.getConnection();
                        String sql = "SELECT m.room_id, m.room_name, m.capacity, m.building_id, b.building_name, m.is_available, " +
                                     "GROUP_CONCAT(am.amenity_name SEPARATOR ', ') AS amenities " +
                                     "FROM meeting_room_master m " +
                                     "JOIN building_master b ON m.building_id = b.building_id " +
                                     "LEFT JOIN room_amenities_link ral ON m.room_id = ral.room_id " +
                                     "LEFT JOIN amenities_master am ON ral.amenity_id = am.amenity_id " +
                                     "GROUP BY m.room_id, m.room_name, m.capacity, m.building_id, b.building_name, m.is_available";
                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();
                        while(rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("room_id") %></td>
                    <td><%= rs.getString("room_name") %></td>
                    <td><%= rs.getInt("capacity") %></td>
                    <td><%= rs.getString("building_name") %></td>
                    <td><%= rs.getBoolean("is_available") ? "Yes" : "No" %></td>
                    <td><%= rs.getString("amenities") != null ? rs.getString("amenities") : "None" %></td>
                    <td>
                        <button
                            class="btn btn-warning btn-sm btn-custom"
                            data-bs-toggle="modal"
                            data-bs-target="#editRoomModal"
                            onclick="populateEditForm(
                                '<%= rs.getInt("room_id") %>',
                                '<%= rs.getString("room_name").replace("'", "\\'") %>',
                                '<%= rs.getInt("capacity") %>',
                                '<%= rs.getInt("building_id") %>',
                                '<%= rs.getBoolean("is_available") %>'
                            )"
                        >Edit</button>
                        <form action="DeleteRoomServlet" method="post" style="display:inline;">
                            <input type="hidden" name="room_id" value="<%= rs.getInt("room_id") %>" />
<button type="submit" class="btn btn-danger btn-sm btn-custom" onclick="return confirm('Are you sure to delete this room?')">Delete</button>
</form>
</td>
</tr>
<%
    }
} catch(Exception e) {
    out.println("<tr><td colspan='7' class='text-danger'>Error loading rooms</td></tr>");
} finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (conn != null) conn.close();
}
%>
</tbody>
</table>
</div>
</div>

<!-- Edit Room Modal -->
<div class="modal fade" id="editRoomModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form action="EditRoomServlet" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Room</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="edit_room_id" name="room_id" />
                <input type="text" id="edit_room_name" name="room_name" placeholder="Room Name" class="form-control mb-3" required />
                <input type="number" id="edit_capacity" name="capacity" placeholder="Capacity" class="form-control mb-3" min="1" required />
                <select id="edit_building_id" name="building_id" class="form-select mb-3" required>
                    <option value="" disabled>Select Building</option>
                    <%
                        Connection c2 = null;
                        PreparedStatement ps2 = null;
                        ResultSet rs2 = null;
                        try {
                            c2 = DBConnection.getConnection();
                            ps2 = c2.prepareStatement("SELECT building_id, building_name FROM building_master");
                            rs2 = ps2.executeQuery();
                            while (rs2.next()) {
                    %>
                        <option value="<%= rs2.getInt("building_id") %>"><%= rs2.getString("building_name") %></option>
                    <%
                            }
                        } catch(Exception e) {
                            out.println("<option disabled>Error loading buildings</option>");
                        } finally {
                            if (rs2 != null) rs2.close();
                            if (ps2 != null) ps2.close();
                            if (c2 != null) c2.close();
                        }
                    %>
                </select>
                <select id="edit_is_available" name="is_available" class="form-select mb-3" required>
                    <option value="1">Available</option>
                    <option value="0">Not Available</option>
                </select>

                <label><strong>Amenities:</strong></label>
                <div class="amenities-container mb-3" id="editAmenitiesContainer">
                    <%
                        Connection cA = null;
                        PreparedStatement psA = null;
                        ResultSet rsA = null;
                        try {
                            cA = DBConnection.getConnection();
                            psA = cA.prepareStatement("SELECT amenity_id, amenity_name FROM amenities_master");
                            rsA = psA.executeQuery();
                            while(rsA.next()) {
                    %>
                    <div class="form-check">
                        <input class="form-check-input edit-amenity-checkbox" type="checkbox" name="amenities" value="<%= rsA.getInt("amenity_id") %>" id="amenityEdit<%= rsA.getInt("amenity_id") %>" />
                        <label class="form-check-label" for="amenityEdit<%= rsA.getInt("amenity_id") %>"><%= rsA.getString("amenity_name") %></label>
                    </div>
                    <%
                            }
                        } catch(Exception e) {
                            out.println("<div class='text-danger'>Error loading amenities</div>");
                        } finally {
                            if (rsA != null) rsA.close();
                            if (psA != null) psA.close();
                            if (cA != null) cA.close();
                        }
                    %>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary btn-custom">Save Changes</button>
                <button type="button" class="btn btn-secondary btn-custom" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Function to populate Edit Modal fields
    async function populateEditForm(room_id, room_name, capacity, building_id, is_available) {
        document.getElementById('edit_room_id').value = room_id;
        document.getElementById('edit_room_name').value = room_name;
        document.getElementById('edit_capacity').value = capacity;
        document.getElementById('edit_building_id').value = building_id;
        document.getElementById('edit_is_available').value = is_available ? '1' : '0';

        // Clear all amenities checkboxes
        let checkboxes = document.querySelectorAll('.edit-amenity-checkbox');
        checkboxes.forEach(cb => cb.checked = false);

        // Fetch existing amenities for this room via AJAX to check corresponding checkboxes
        try {
            const response = await fetch('GetRoomAmenitiesServlet?room_id=' + room_id);
            if (response.ok) {
                const amenities = await response.json(); // expecting JSON array of amenity_ids
                amenities.forEach(id => {
                    let cb = document.querySelector(`#amenityEdit${id}`);
                    if (cb) cb.checked = true;
                });
            } else {
                console.error('Failed to load amenities');
            }
        } catch (e) {
            console.error(e);
        }
    }
</script>


<%@ page import="java.sql.*, MeetingRoomReservation.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Amenities</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
    </style>
</head>
<body>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center header-bar mb-4">
        <h3 class="mb-0">Manage Amenities</h3>
        <a href="admin.jsp" class="btn btn-light btn-sm btn-custom">Back to Dashboard</a>
    </div>

    <div class="card-custom mb-4">
        <div class="d-flex justify-content-end">
            <button class="btn btn-success btn-custom mb-3" data-bs-toggle="modal" data-bs-target="#amenityModal" onclick="openAddModal()">+ Add New Amenity</button>
        </div>

        <!-- Status Alerts -->
        <%
            String status = request.getParameter("status");
            if ("success".equals(status)) {
        %>
            <div class="alert alert-success">Operation successful!</div>
        <% } else if ("error".equals(status)) { %>
            <div class="alert alert-danger">Something went wrong!</div>
        <% } %>

        <!-- Modal -->
        <div class="modal fade" id="amenityModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form method="post" id="amenityForm">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalTitle">Add/Edit Amenity</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body row g-3">
                            <input type="hidden" name="amenity_id" id="amenity_id" />
                            <div class="col-md-12">
                                <input type="text" name="amenity_name" id="amenity_name" placeholder="Amenity Name" required class="form-control" />
                            </div>
                            <div class="col-12 mt-3 text-end">
                                <button type="submit" class="btn btn-primary btn-custom">Save Amenity</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Table -->
        <div class="table-responsive">
            <table class="table table-bordered align-middle text-center">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Amenity Name</th>
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
                        ps = conn.prepareStatement("SELECT * FROM amenities_master ORDER BY amenity_id");
                        rs = ps.executeQuery();
                        while(rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getInt("amenity_id") %></td>
                        <td><%= rs.getString("amenity_name") %></td>
                        <td>
                            <button class="btn btn-warning btn-sm btn-custom"
                                onclick="openEditModal(<%= rs.getInt("amenity_id") %>, '<%= rs.getString("amenity_name").replace("'", "\\'") %>')">
                                Edit
                            </button>
                            <form method="post" action="DeleteAmenityServlet" style="display:inline;">
                                <input type="hidden" name="amenity_id" value="<%= rs.getInt("amenity_id") %>" />
                                <button type="submit" class="btn btn-danger btn-sm btn-custom" onclick="return confirm('Are you sure you want to delete this amenity?');">Delete</button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if(rs != null) rs.close();
                        if(ps != null) ps.close();
                        if(conn != null) conn.close();
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Script -->
<script>
    function openAddModal() {
        document.getElementById("amenityForm").action = "AddAmenityServlet";
        document.getElementById("modalTitle").innerText = "Add Amenity";
        document.getElementById("amenity_id").value = "";
        document.getElementById("amenity_name").value = "";
    }

    function openEditModal(id, name) {
        document.getElementById("amenityForm").action = "EditAmenityServlet";
        document.getElementById("modalTitle").innerText = "Edit Amenity";
        document.getElementById("amenity_id").value = id;
        document.getElementById("amenity_name").value = name;
        var modal = new bootstrap.Modal(document.getElementById('amenityModal'));
        modal.show();
    }
</script>

</body>
</html>

<%@ page import="java.sql.*" %>
<%@ page import="MeetingRoomReservation.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Buildings</title>
    <!-- Bootstrap CSS & JS -->
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
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-custom {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            padding: 24px;
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
            text-align: center;
        }
        .modal-content {
            border-radius: 16px;
        }
        .form-control {
            border-radius: 10px;
        }
        .alert {
            border-radius: 12px;
        }
    </style>
</head>
<body>

<div class="container py-4">
    <div class="header-bar">
        <h3 class="mb-0">Manage Buildings</h3>
        <a href="admin.jsp" class="btn btn-light btn-sm btn-custom">Back to Dashboard</a>
    </div>

    <div class="card-custom">
        <!-- Status messages -->
        <%
            String status = request.getParameter("status");
            if ("success".equals(status)) {
        %>
            <div class="alert alert-success">Operation successful!</div>
        <%
            } else if ("error".equals(status)) {
        %>
            <div class="alert alert-danger">Something went wrong!</div>
        <%
            }
        %>

        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-success btn-custom" data-bs-toggle="modal" data-bs-target="#addBuildingModal">+ Add New Building</button>
        </div>

        <!-- Buildings Table -->
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Building Name</th>
                        <th>City</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT * FROM building_master ORDER BY building_id";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getInt("building_id") %></td>
                        <td><%= rs.getString("building_name") %></td>
                        <td><%= rs.getString("city") %></td>
                        <td>
                            <button class="btn btn-warning btn-sm btn-custom"
                                    data-bs-toggle="modal" data-bs-target="#editBuildingModal"
                                    onclick="populateEditForm('<%= rs.getInt("building_id") %>', '<%= rs.getString("building_name") %>', '<%= rs.getString("city") %>')">
                                Edit
                            </button>

                            <form action="DeleteBuildingServlet" method="post" style="display:inline;">
                                <input type="hidden" name="building_id" value="<%= rs.getInt("building_id") %>" />
                                <button type="submit" class="btn btn-danger btn-sm btn-custom"
                                        onclick="return confirm('Are you sure you want to delete this building?');">
                                    Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='4'>Error fetching buildings</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add Building Modal -->
<div class="modal fade" id="addBuildingModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form action="AddBuildingServlet" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Building</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="text" name="building_name" placeholder="Building Name" class="form-control mb-3" required />
                <input type="text" name="city" placeholder="City" class="form-control mb-3" required />
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary btn-custom">Add Building</button>
                <button type="button" class="btn btn-secondary btn-custom" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Building Modal -->
<div class="modal fade" id="editBuildingModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form action="EditBuildingServlet" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Building</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="building_id" id="editBuildingId" />
                <input type="text" name="building_name" id="editBuildingName" class="form-control mb-3" required />
                <input type="text" name="city" id="editCity" class="form-control mb-3" required />
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary btn-custom">Save Changes</button>
                <button type="button" class="btn btn-secondary btn-custom" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function populateEditForm(id, name, city) {
        document.getElementById('editBuildingId').value = id;
        document.getElementById('editBuildingName').value = name;
        document.getElementById('editCity').value = city;
    }
</script>

</body>
</html>

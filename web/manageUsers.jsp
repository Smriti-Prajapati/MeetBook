<%@ page import="java.sql.*, MeetingRoomReservation.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
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
        <h3 class="mb-0">Manage Users</h3>
        <a href="admin.jsp" class="btn btn-light btn-sm btn-custom">Back to Dashboard</a>
    </div>

    <div class="card-custom mb-4">
        <div class="d-flex justify-content-end">
            <button class="btn btn-success btn-custom mb-3" data-bs-toggle="modal" data-bs-target="#userModal" onclick="openAddModal()">+ Add New User</button>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="userModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form method="post" id="userForm">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalTitle">Add/Edit User</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body row g-3">
                            <input type="hidden" name="user_id" id="user_id" />
                            <div class="col-md-4"><input type="text" name="login_name" id="login_name" placeholder="Login Name" required class="form-control" /></div>
                            <div class="col-md-4"><input type="text" name="first_name" id="first_name" placeholder="First Name" required class="form-control" /></div>
                            <div class="col-md-4"><input type="text" name="last_name" id="last_name" placeholder="Last Name" required class="form-control" /></div>
                            <div class="col-md-4"><input type="email" name="email" id="email" placeholder="Email" required class="form-control" /></div>
                            <div class="col-md-4"><input type="text" name="mobile" id="mobile" placeholder="Mobile" required class="form-control" /></div>
                            <div class="col-md-4"><input type="password" name="password" id="password" placeholder="Password" class="form-control" /></div>
                            <div class="col-md-4"><input type="number" name="role_id" id="role_id" placeholder="Role ID" required class="form-control" /></div>
                            <div class="col-md-4">
                                <select name="is_active" id="is_active" class="form-control">
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-12 mt-3 text-end">
                                <button type="submit" class="btn btn-primary btn-custom">Save User</button>
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
                        <th>Login</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Mobile</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM user_master");
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("user_id") %></td>
                    <td><%= rs.getString("login_name") %></td>
                    <td><%= rs.getString("first_name") %> <%= rs.getString("last_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("mobile") %></td>
                    <td><%= rs.getInt("role_id") %></td>
                    <td><%= rs.getBoolean("is_active") ? "Active" : "Inactive" %></td>
                    <td>
                        <button class="btn btn-warning btn-sm btn-custom"
                                onclick="openEditModal(<%= rs.getInt("user_id") %>, '<%= rs.getString("login_name") %>', '<%= rs.getString("first_name") %>', '<%= rs.getString("last_name") %>', '<%= rs.getString("email") %>', '<%= rs.getString("mobile") %>', <%= rs.getInt("role_id") %>, <%= rs.getBoolean("is_active") ? 1 : 0 %>)">
                            Edit
                        </button>
                        <form method="post" action="DeleteUserServlet" style="display:inline;">
                            <input type="hidden" name="user_id" value="<%= rs.getInt("user_id") %>" />
                            <button type="submit" class="btn btn-danger btn-sm btn-custom">Delete</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                    conn.close();
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Script -->
<script>
    function openAddModal() {
        document.getElementById("userForm").action = "AddUserServlet";
        document.getElementById("modalTitle").innerText = "Add User";
        document.getElementById("user_id").value = "";
        document.getElementById("login_name").value = "";
        document.getElementById("first_name").value = "";
        document.getElementById("last_name").value = "";
        document.getElementById("email").value = "";
        document.getElementById("mobile").value = "";
        document.getElementById("password").required = true;
        document.getElementById("password").value = "";
        document.getElementById("role_id").value = "";
        document.getElementById("is_active").value = "1";
    }

    function openEditModal(userId, loginName, firstName, lastName, email, mobile, roleId, isActive) {
        document.getElementById("userForm").action = "EditUserServlet";
        document.getElementById("modalTitle").innerText = "Edit User";
        document.getElementById("user_id").value = userId;
        document.getElementById("login_name").value = loginName;
        document.getElementById("first_name").value = firstName;
        document.getElementById("last_name").value = lastName;
        document.getElementById("email").value = email;
        document.getElementById("mobile").value = mobile;
        document.getElementById("password").required = false;
        document.getElementById("password").value = "";
        document.getElementById("role_id").value = roleId;
        document.getElementById("is_active").value = isActive;
        var modal = new bootstrap.Modal(document.getElementById('userModal'));
        modal.show();
    }
</script>
</body>
</html>

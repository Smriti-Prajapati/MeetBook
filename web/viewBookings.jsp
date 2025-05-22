<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        /* Same styles as manageUsers.jsp for consistency */
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
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        /* Add smooth hover effect to white button */
        .btn-light.btn-custom:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(13, 110, 253, 0.4); /* blue shadow */
        }

        /* Add smooth hover effect to blue and info buttons */
        .btn-primary, .btn-info {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(13, 110, 253, 0.6);
        }
        .btn-info:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(13, 110, 253, 0.6);
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
        /* Card hover effect from your original viewAvailableRooms.jsp */
        .card:hover {
            transform: scale(1.03);
            transition: transform 0.3s ease-in-out;
        }
    </style>
</head>
<body>
    <div class="container py-4">

        <!-- Header bar with welcome and back button -->
        <div class="d-flex justify-content-between align-items-center header-bar mb-4">
            <h2 class="mb-0">Welcome, <%= username %>!</h2>
            <a href="admin.jsp" class="btn btn-light btn-sm btn-custom">Go to Dashboard</a>
        </div>

        <!-- Main card container -->
        <div class="card-custom mb-4">
            <!-- Your existing content/cards from viewAvailableRooms.jsp go here -->
            <div class="row justify-content-center g-4">
                <!-- Cards preserved from your original -->
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-body text-center">
                            <h5 class="card-title">View & Book Rooms</h5>
                            <p class="card-text">View available rooms and book directly.</p>
                            <a href="viewAvailableRooms.jsp" class="btn btn-primary">View & Book</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-body text-center">
                            <h5 class="card-title">All Bookings</h5>
                            <p class="card-text">Check all current and upcoming bookings.</p>
                            <a href="viewAllBookings.jsp" class="btn btn-info">View All Bookings</a>
                        </div>
                    </div>
                </div>
            </div>

            
        </div>
    </div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("index.jsp"); // Redirect if not logged in
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
            background-image: url('images/light background.JPG'); /* Light mode background image */
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: #212529;
        }

        .card {
            background-color: #ffffff;
            color: #212529;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .icon-box {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #0d6efd;
        }

        /* Button hover animation */
        .btn-primary, .btn-success {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .btn-primary:hover {
            transform: scale(1.1);
            box-shadow: 0 0 10px rgba(13, 110, 253, 0.6);
        }

        .btn-success:hover {
            transform: scale(1.1);
            box-shadow: 0 0 10px rgba(25, 135, 84, 0.6);
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <!-- Top Right Controls -->
        <div class="d-flex justify-content-end align-items-center mb-3">
            <!-- Logout Button -->
            <a href="logout.jsp" class="btn btn-outline-danger">Logout</a>
        </div>

        <!-- Page Heading -->
        <h2 class="text-center mb-5 fw-bold">Welcome, <%= username %>!</h2>

        <!-- Dashboard Cards -->
        <div class="d-flex flex-wrap justify-content-center gap-4">
            <!-- Book Meeting Room -->
            <div class="card p-4 text-center" style="width: 240px;">
                <div class="icon-box"><i class="bi bi-door-open-fill"></i></div>
                <h5>Book Meeting Room</h5>
                <a href="viewAvailableRooms.jsp" class="btn btn-primary mt-2">Book Now</a>
            </div>

            <!-- View My Bookings -->
            <div class="card p-4 text-center" style="width: 240px;">
                <div class="icon-box"><i class="bi bi-calendar-check-fill"></i></div>
                <h5>My Bookings</h5>
                <a href="viewMyBookings.jsp" class="btn btn-success mt-2">View</a>
            </div>
        </div>
    </div>
</body>
</html>

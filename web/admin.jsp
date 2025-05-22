<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <!-- Bootstrap CSS and icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            cursor: pointer; /* to show it's interactive */
        }
        .card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        .icon-box {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #0d6efd;
        }

        /* Button hover animation */
        .btn-primary {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .btn-primary:hover {
            transform: scale(1.1);
            box-shadow: 0 0 10px rgba(13, 110, 253, 0.6);
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="d-flex justify-content-end align-items-center mb-3">
            <a href="logout.jsp" class="btn btn-outline-danger">Logout</a>
        </div>

        <h2 class="text-center mb-5 fw-bold">Admin Dashboard</h2>

        <div class="d-flex flex-wrap justify-content-center gap-4">
            <div class="card p-4 text-center" style="width: 220px;">
                <div class="icon-box"><i class="bi bi-people-fill"></i></div>
                <h5>Manage Users</h5>
                <a href="manageUsers.jsp" class="btn btn-primary mt-2">Go</a>
            </div>
            <div class="card p-4 text-center" style="width: 220px;">
                <div class="icon-box"><i class="bi bi-house-door-fill"></i></div>
                <h5>Manage Buildings</h5>
                <a href="manageBuildings.jsp" class="btn btn-primary mt-2">Go</a>
            </div>
            <div class="card p-4 text-center" style="width: 220px;">
                <div class="icon-box"><i class="bi bi-door-open-fill"></i></div>
                <h5>Manage Rooms</h5>
                <a href="manageRooms.jsp" class="btn btn-primary mt-2">Go</a>
            </div>
            <div class="card p-4 text-center" style="width: 220px;">
                <div class="icon-box"><i class="bi bi-calendar-check-fill"></i></div>
                <h5>View Room Bookings</h5>
                <a href="viewBookings.jsp" class="btn btn-primary mt-2">Go</a>
            </div>
            <div class="card p-4 text-center" style="width: 220px;">
                <div class="icon-box"><i class="bi bi-tools"></i></div>
                <h5>Manage Amenities</h5>
                <a href="manageAmenities.jsp" class="btn btn-primary mt-2">Go</a>
            </div>
        </div>
    </div>
</body>
</html>

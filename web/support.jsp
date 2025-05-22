<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    Integer roleId = (Integer) session.getAttribute("role_id");  // ✅ MATCHED KEY

    if (username == null || roleId == null || roleId != 2) { // role_id 2 => Support
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Support Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-image: url('images/light background.JPG'); /* ✅ Set your image path here */
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-position: center;
            color: #212529;
        }

        .card {
            background-color: rgba(255, 255, 255, 0.9); /* Slight transparency */
            color: #212529;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.2);
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
        <!-- Top Right Controls -->
        <div class="d-flex justify-content-end align-items-center gap-3 mb-3">
            <!-- Logout Button -->
            <a href="logout.jsp" class="btn btn-outline-danger">Logout</a>
        </div>

        <!-- Page Heading -->
        <h2 class="text-center mb-5 fw-bold">Welcome, <%= username %> (Support Role)</h2>

        <!-- Dashboard Cards -->
        <div class="d-flex flex-wrap justify-content-center gap-4">
            <!-- View All Bookings -->
            <div class="card p-4 text-center" style="width: 220px;">
                <div class="icon-box"><i class="bi bi-calendar-week-fill"></i></div>
                <h5>View All Bookings</h5>
                <a href="supportViewBookings.jsp" class="btn btn-primary mt-2">Go</a>
            </div>
        </div>
    </div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    if (session != null) {
        session.invalidate();
    }
    response.setHeader("Refresh", "3; URL=index.jsp");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Logout - Meeting Room Reservation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body  {
            background-image: url('images/light background.JPG'); /* ✅ Set your image path here */
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-position: center;
            color: #212529;
        }
        body {
            background-color: #f1f5f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }
         
        .container-logout {
            max-width: 450px;
            width: 100%;
            border-radius: 16px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            background-color: white;
            padding: 40px;
            text-align: center;
        }
        .container-logout h2 {
            font-weight: 600;
            margin-bottom: 1rem;
            color: #212529;
        }
        .container-logout p {
            color: #6c757d;
            margin-bottom: 1.5rem;
        }
        .btn-custom {
            border-radius: 12px;
            padding: 0.5rem 1.5rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container-logout">
        <h2>Successfully Logged Out</h2>
        <p>You will be redirected to the login page shortly.</p>
        <a href="index.jsp" class="btn btn-primary btn-custom">Go to Login Now</a>
    </div>
</body>
</html>

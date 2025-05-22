<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Welcome to MeetBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        html, body {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow: hidden;
            color: white;
        }

        /* Multiple Background Images Cycling */
        .background-container {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            z-index: -1;
        }

        .background-slide {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background-size: cover;
            background-position: center;
            transition: opacity 2s ease-in-out;
            opacity: 0;
        }

        .background-slide.active {
            opacity: 1;
        }

        .content {
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 0 20px;
            z-index: 1;
            position: relative;
        }

        .top-icons {
            position: fixed;
            top: 20px;
            right: 20px;
            display: flex;
            gap: 40px;
            z-index: 2;
        }

        .icon-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.85);
            user-select: none;
        }

        .icon-button {
            font-size: 2.2rem;
            cursor: pointer;
            border-radius: 50%;
            padding: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: filter 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.4);
            margin-bottom: 4px;
        }

        .icon-login {
            color: #0d6efd;
            background-color: rgba(13,110,253,0.15);
        }

        .icon-login:hover {
            filter: brightness(1.3);
        }

        .icon-contact {
            color: #198754;
            background-color: rgba(25,135,84,0.15);
        }

        .icon-contact:hover {
            filter: brightness(1.3);
        }

        @keyframes fadeInUp {
            0% {
                opacity: 0;
                transform: translateY(40px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        h1 {
            font-size: clamp(2.5rem, 6vw, 4rem);
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 2px 2px 6px rgba(0,0,0,0.8);
            animation: fadeInUp 1s ease-out forwards;
        }

        p.quote {
            font-size: clamp(1rem, 2vw, 1.5rem);
            font-style: italic;
            max-width: 600px;
            margin-bottom: 2rem;
            text-shadow: 1px 1px 5px rgba(0,0,0,0.7);
            animation: fadeInUp 1s ease-out forwards;
            animation-delay: 0.5s;
        }

        .modal-content {
            background-color: #fff !important;
            color: #000 !important;
            border-radius: 12px;
        }

        .modal-header, .modal-footer {
            border: none;
        }

        .modal-title {
            width: 100%;
            text-align: center;
            margin: 0 auto;
        }
    </style>
</head>
<body>

<!-- Dynamic Alerts -->
<%
    String contactStatus = request.getParameter("contact");
    if ("success".equals(contactStatus)) {
%>
    <div class="alert alert-success text-center m-3">
        Thank you! Your message has been sent successfully.
    </div>
<%
    } else if ("fail".equals(contactStatus)) {
%>
    <div class="alert alert-danger text-center m-3">
        Sorry, something went wrong. Please try again later.
    </div>
<%
    }
%>

<!-- Background Image Slides -->
<div class="background-container">
    <div class="background-slide active" style="background-image: url('images/Welcome.jpg');"></div>
    <div class="background-slide" style="background-image: url('images/Welcome2.jpg');"></div>
    <div class="background-slide" style="background-image: url('images/Welcome3.jpg');"></div>
    <div class="background-slide" style="background-image: url('images/Welcome4.jpg');"></div>
</div>

<!-- Top Icons -->
<div class="top-icons">
    <div class="icon-wrapper">
        <i class="bi bi-person-circle icon-button icon-login" role="button" data-bs-toggle="modal" data-bs-target="#loginModal" title="Login" tabindex="0" aria-label="Login"></i>
        <span>Login</span>
    </div>
    <div class="icon-wrapper">
        <i class="bi bi-envelope-fill icon-button icon-contact" role="button" data-bs-toggle="modal" data-bs-target="#contactModal" title="Contact Us" tabindex="0" aria-label="Contact Us"></i>
        <span>Contact Us</span>
    </div>
</div>

<!-- Center Content -->
<div class="content">
    <h1>Welcome to MeetBook</h1>
    <p class="quote">"Where great meetings begin and ideas take flight."</p>
</div>

<!-- Login Modal -->
<div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content p-4">
      <form action="LoginServlet" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="loginModalLabel">MeetBook Login</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <% 
            String error = request.getParameter("error");
            if ("invalid_credentials".equals(error)) {
          %>
            <div class="alert alert-danger text-center">Invalid username or password.</div>
          <% } else if ("invalid_role".equals(error)) { %>
            <div class="alert alert-warning text-center">Role not recognized.</div>
          <% } %>
          <div class="mb-3">
            <label for="login_name" class="form-label">Username</label>
            <input type="text" id="login_name" name="login_name" class="form-control" required autofocus />
          </div>
          <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" id="password" name="password" class="form-control" required />
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary w-100">Login</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Contact Modal -->
<div class="modal fade" id="contactModal" tabindex="-1" aria-labelledby="contactModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content p-4">
      <form action="ContactServlet" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="contactModalLabel">Contact Us</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="contact_name" class="form-label">Your Name</label>
            <input type="text" id="contact_name" name="name" class="form-control" required />
          </div>
          <div class="mb-3">
            <label for="contact_email" class="form-label">Your Email</label>
            <input type="email" id="contact_email" name="email" class="form-control" required />
          </div>
          <div class="mb-3">
            <label for="contact_subject" class="form-label">Subject</label>
            <input type="text" id="contact_subject" name="subject" class="form-control" required />
          </div>
          <div class="mb-3">
            <label for="contact_message" class="form-label">Message</label>
            <textarea id="contact_message" name="message" class="form-control" rows="4" required></textarea>
          </div>
          <!-- Terms and Conditions Checkbox -->
          <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="termsCheck" required />
            <label class="form-check-label" for="termsCheck">
              I agree to the <a href="terms.html" target="_blank">Terms and Conditions</a>
            </label>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success w-100">Send Message</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Background images cycling logic
    const slides = document.querySelectorAll('.background-slide');
    let currentIndex = 0;

    function cycleBackground() {
        slides[currentIndex].classList.remove('active');
        currentIndex = (currentIndex + 1) % slides.length;
        slides[currentIndex].classList.add('active');
    }

    setInterval(cycleBackground, 8000); // Change every 8 seconds
</script>

</body>
</html>

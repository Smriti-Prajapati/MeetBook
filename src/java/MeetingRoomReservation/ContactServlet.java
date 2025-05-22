package MeetingRoomReservation;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {

    // Your receiving Gmail (contact form submissions come here)
    private static final String TO_EMAIL = "smriti.23bce11456@vitbhopal.ac.in";

    // Your sending Gmail (must have app password)
    private static final String FROM_EMAIL = "smritiprajapati15@gmail.com";
    private static final String FROM_PASSWORD = "btit vyqc mnok ylmu"; // Gmail App Password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Form parameters
        String userName = request.getParameter("name");
        String userEmail = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // SMTP configuration
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Authenticated session
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        // Enable debug logs
        session.setDebug(true);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL)); // Always your email
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(TO_EMAIL));
            msg.setSubject("📨 New Contact Form Submission: " + subject);

            // Set reply-to to the user's email (optional, but helpful)
            if (userEmail != null && !userEmail.trim().isEmpty()) {
                msg.setReplyTo(InternetAddress.parse(userEmail));
            }

            // Email content
            String emailBody = "📝 You've received a new message via the MeetBook contact form:\n\n"
                    + "👤 Name: " + userName + "\n"
                    + "📧 Email: " + userEmail + "\n"
                    + "🧾 Subject: " + subject + "\n\n"
                    + "💬 Message:\n" + message;

            msg.setText(emailBody);

            // Send the email
            Transport.send(msg);

            // Redirect with success message
            response.sendRedirect("index.jsp?contact=success");

        } catch (MessagingException e) {
            e.printStackTrace(); // Console log
            response.sendRedirect("index.jsp?contact=fail");
        }
    }
}

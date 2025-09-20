# 📖 MeetBook

**MeetBook** is a **web-based meeting room reservation system** that simplifies the process of booking, managing, and tracking meeting rooms in an organization.
It eliminates scheduling conflicts, provides real-time availability, and offers **role-based access** for different user types (Admin, Support, User).

---

## 🚀 Features

### 👤 User Authentication & Roles

* **Admin**: Full control over rooms, bookings, and users.
* **Support**: Assist in booking management and resolve conflicts.
* **User**: Search for availability, make reservations, and manage bookings.

### 🏢 Room Management

* Add, edit, and delete meeting rooms.
* Define room details such as **capacity, building, and amenities**.

### 📅 Booking System

* Real-time **availability check**.
* Book **multiple slots** in one request.
* Prevents **double booking** with conflict resolution logic.

### ⏰ Slot & Amenity Integration

* Assign **time slots** (morning, afternoon, evening).
* Manage **amenities** like projectors, Wi-Fi, AC, and whiteboards.

### 📊 Booking Filters & Views

* **Today’s Bookings**
* **Upcoming Bookings**
* **Completed Bookings**

### ⚙️ Admin Controls

* View all reservations in the system.
* Manage users and their roles.
* Add or delete bookings.

### 🎨 Modern UI

* Built with **Bootstrap 5** and custom CSS.
* Responsive design for desktops, tablets, and mobiles.

---

## 🛠️ Tech Stack

* **Frontend**: JSP, HTML5, CSS3, Bootstrap
* **Backend**: Java Servlets, MVC Architecture, DAO Pattern
* **Database**: MySQL (via JDBC)
* **Server**: Apache Tomcat

---

## 📂 Project Structure

```
MeetBook/
│── src/                  # Java source files (Servlets, DAO, Models)
│── WebContent/           # JSP pages, CSS, JS, and assets
│── DB/                   # SQL scripts for database setup
│── lib/                  # JAR dependencies
│── README.md             # Documentation
```

---

## ⚙️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Smriti-Prajapati/MeetBook.git
cd MeetBook
```

### 2. Setup Database (MySQL)

* Create a database (e.g., `meetbook_db`).
* Import the provided SQL script from the `DB/` folder.

### 3. Configure Database Connection

Update `DBConnection.java` with your MySQL credentials:

```java
private static final String URL = "jdbc:mysql://localhost:3306/meetbook_db";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

### 4. Deploy on Apache Tomcat

* Copy the project folder into `tomcat/webapps/`.
* Start Tomcat server.
* Access the app at:

```
http://localhost:8080/MeetBook
```

---

## ▶️ Usage

* **Login Page**: Role-based login (Admin, Support, User).
* **Admin Dashboard**: Manage rooms, users, and all bookings.
* **User Dashboard**: Check availability, book rooms, and track reservations.
* **Support Dashboard**: Assist in booking issues.

---

## 📈 Benefits

* Reduces manual scheduling & conflicts.
* Centralized system for **all bookings**.
* Real-time updates and transparent room usage.
* Scalable for organizations of any size.

---

## 🔮 Future Enhancements

* Email/SMS **notifications** for bookings.
* **Recurring bookings** (daily/weekly).
* Calendar integration (Google/Outlook).
* Analytics dashboard for room utilization.
* Approval workflows for premium rooms.

---

## 👩‍💻 Author

Developed by **Smriti Prajapati**
*As part of BHEL Internship Project*

---

# 📱 MobileNC – Bus Ticket Booking System

A full-stack Bus Ticket Booking System developed for **Nam Hai Bus Company**, providing a complete solution for customers to search routes, book tickets, select seats, and manage their journeys through a mobile application, while enabling administrators to efficiently manage transportation operations through a centralized management system.

---

# 🚀 Project Overview

MobileNC is designed to digitize the ticket booking process and simplify transportation management.

The system consists of:

* 📱 **Flutter Mobile Application** for customers
* 🖥️ **Node.js + Express.js REST API**
* 🗄️ **MySQL Database**

The mobile application communicates with the backend through RESTful APIs, while the backend manages business logic and stores all system data in MySQL.

---

# ✨ Key Features

## 👤 Customer Mobile Application

Customers can conveniently perform the following operations:

* 🔍 Search available bus trips by departure and destination
* 🚌 View detailed trip schedules
* 💺 Select available seats in real time
* 💳 Choose preferred payment methods
* 🎫 Book bus tickets online
* 📄 View purchased tickets
* 📜 Access booking history
* 📰 Read company news and announcements
* 🔔 Receive important notifications
* 💬 Submit customer feedback
* 👤 View and update personal profile
* 🔒 Change account password
* 📍 Track current location with Google Maps integration

---

## 🛠️ Admin Management System

The administrator dashboard provides complete management capabilities, including:

### 👥 Customer Management

* Create, update and delete customer information
* Search customer records

### 👨‍💼 Employee Management

* Manage employee accounts
* Update staff information

### 🚌 Bus & Trip Management

* Manage bus stations
* Manage bus routes
* Manage bus schedules
* Manage buses
* Manage trips
* Manage ticket information

### 🔐 User Management

* Manage user accounts
* Manage login credentials

### 📢 Notification Management

* Send announcements to customers
* Notify schedule changes
* Broadcast company updates

---

# 🏗️ System Architecture

```text
Flutter Mobile App
        │
        ▼
REST API (Node.js + Express.js)
        │
        ▼
MySQL Database
```

---

# 🛠️ Technology Stack

## Frontend

* Flutter
* Dart
* Google Maps API
* HTTP Package

## Backend

* Node.js
* Express.js
* REST API

## Database

* MySQL

---

# 🗄️ Database Design

Main entities include:

* Customer
* Employee
* User Account
* Bus
* Bus Station
* Route
* Trip
* Ticket
* Seat
* Notification
* Feedback
* News

---

# ⚙️ Installation Guide

## Clone Repository

```bash
git clone https://github.com/FuyutsukiTouka/MobileNC_AppBanVeXe

cd appquanlyvexekhach
```

---

## Backend Setup

Install dependencies:

```bash
npm install
```

Start the backend server:

```bash
node server.js
```

The server will run at:

```text
http://localhost:3000
```

---

## Database Setup

1. Install MySQL.
2. Create a database.

```sql
CREATE DATABASE mobilenc_db;
```

3. Import the provided SQL file into the database.

4. Update database credentials inside the backend configuration if necessary.

---

## Flutter Setup

Install Flutter dependencies:

```bash
flutter pub get
```

Verify your Flutter environment:

```bash
flutter doctor
```

---

## Configure API

Update the API base URL inside the Flutter project.

For Android Emulator:

```text
http://10.0.2.2:3000
```

For a physical Android device:

```text
http://YOUR_LOCAL_IP:3000
```

For iOS Simulator:

```text
http://localhost:3000
```

---

## Run the Application

```bash
flutter run
```

---

# 📡 REST API

The backend provides RESTful APIs for:

* Authentication
* Customer Management
* Employee Management
* Bus Management
* Route Management
* Trip Management
* Ticket Booking
* Notification Management
* News
* Feedback

---

# 🔐 Authentication & Security

The system includes:

* User Login Authentication
* Password Encryption
* Role-Based User Access
* Protected REST APIs

---

# 📊 System Modules

* Customer Management
* Employee Management
* Bus Management
* Route Management
* Trip Scheduling
* Ticket Booking
* Seat Selection
* Notifications
* News
* Feedback
* User Profile
* Booking History
* Google Maps Integration

---

# 📷 Video

* https://www.youtube.com/watch?v=KiZILs9u0ms&t=4s

---

# 🎯 Future Enhancements

* Online Payment Gateway Integration
* QR Code E-Tickets
* Real-Time Bus Tracking
* Push Notifications
* Multi-Language Support
* Dark Mode
* Online Check-in
* Driver Management
* Revenue Dashboard
* Analytics & Reports

---

# 👨‍💻 Author

**Bao Nguyen**

Bachelor of Software Engineering

Academic Year **2025 – 2026**

---

# 📄 License

This project was developed for educational and academic purposes.

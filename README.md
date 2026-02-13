**📱 MobileNC - Bus Ticket Booking App**

MobileNC is a full-stack bus ticket booking system for Nam Hai Bus Company.
The system includes a mobile application for customers and an admin management system for company staff.

**🎯 System Overview**

This project is built with:

📱 Flutter (Mobile Application)

🖥 Node.js + Express.js (Backend API)

🗄 MySQL (Database)

The mobile app communicates with the backend server via REST APIs, and the backend connects to the MySQL database to store and manage all system data.

**👤 Customer Features (Mobile App)**

The Nam Hai Bus Booking App allows customers to:

Search for bus trips based on their desired destination.

Select their preferred bus type and choose available seats.

Choose a preferred payment method to complete the booking process.

View detailed trip schedules.

View purchased tickets and booking history.

Read news and information about the bus company.

Provide feedback about the company’s services.

Receive and view notifications related to trips and company announcements.

View and update personal account information, including changing passwords.

Track their current location through Google Maps integration.

**🛠️ Admin Features (Management System)**

The Admin system allows administrators to:

Manage customer information.

Manage employee accounts and related personnel.

Manage bus stations, routes, trips, and tickets.

Manage user accounts and system data.

Send notifications to customers regarding company updates, trip changes, and important announcements.

**🚀 How to Install and Run the Project**
**STEP 1: Install Node.js
**
Download and install Node.js from:
https://nodejs.org/

Check installation:

node -v
npm -v

**STEP 2: Install MySQL**

Install MySQL

Create a database named: mobilenc_db

Import the provided .sql file (if available)

**STEP 3: Run the Backend Server**

Open terminal in the project folder and run:

npm install
node server.js


If successful, you should see:

Server running on port 3000

**STEP 4: Install Flutter**

Check Flutter installation:

flutter doctor

**STEP 5: Install Flutter Dependencies**
flutter pub get

**STEP 6: Update API Base URL**

Inside the lib/ folder, find:

http://localhost:3000


If using Android Emulator, change it to:

http://10.0.2.2:3000

**STEP 7: Run the App**
flutter run

**⚠️ Important Notes**

Make sure the backend server is running before starting the mobile app.

Make sure the MySQL service is running.

If the app cannot connect, check port 3000.

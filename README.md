**📱 MobileNC - Bus Ticket Booking App**

MobileNC is a full-stack bus ticket booking application built with:

📱 Flutter (Mobile App)

🖥 Node.js + Express.js (Backend)

🗄 MySQL (Database)

🚀 How to Install and Run the Project
**STEP 1: Install Node.js**

Download and install Node.js from:
https://nodejs.org/

Check installation:

node -v
npm -v

**STEP 2: Install MySQL**

Install MySQL

Create a database named: mobilenc_db

Import the provided .sql file (if available)

**STEP 3: Run the Backend**

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

⚠️ Important Notes

✔ Make sure backend is running before starting the app
✔ Make sure MySQL service is running
✔ If connection fails, check port 3000

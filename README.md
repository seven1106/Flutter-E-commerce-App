Emigo Ecommerce App

Emigo is a multi-platform eCommerce application designed to provide a seamless online shopping experience. The app allows users to browse products, manage orders, make secure payments, and receive real-time order notifications.

🚀 Objectives

Emigo aims to be a robust eCommerce platform, enabling both sellers and buyers to engage in efficient product management, order processing, and smooth online shopping.

🛠️ Technologies Used

Flutter, Provider State Management.

Node.js & Express.js: For backend services and building RESTful APIs.

MongoDB: NoSQL database for storing user, product, and order information.

🌟 Key Features

Online Shopping: Browse products, add them to your cart, and easily place orders.

Flexible Payment: Pay on delivery or via online payment gateways such as Google Pay.

Order Management: Track order status and receive notifications.

Voucher System: Access discount codes and special offers.

Responsive UI: Modern design, easy to use, and compatible with various screen sizes.

📂 Project Structure

lib/
│

├── screens/            # UI Screens

├── widgets/            # Shared Widgets

├── models/             # Data Models

├── services/           # Backend Services

└── utils/              # Utility Functions

💻 Installation Instructions

Clone the repository:

git clone https://github.com/username/emigo-ecommerce.git

Install dependencies:

flutter pub get

Run the app on a simulator or physical device:

flutter run

Backend setup:

Ensure the Node.js server is running and connected to MongoDB.

🔧 Backend Setup Instructions

Ensure the Node.js server is up and running at http://localhost:3000.

cd server

npm start

Setup MongoDB

Change MONGODB_CONNECTION_STRING

Use Docker for deployment if needed.

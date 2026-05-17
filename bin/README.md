# 🏨 StayEase - Hotel Booking System

A complete, full-stack hotel booking management system built with Jakarta EE, featuring role-based access for guests, staff, and administrators.

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | Java 17, Jakarta EE Servlets, JSP |
| **Frontend** | Tailwind CSS, FontAwesome, Chart.js |
| **Database** | MySQL 8.0 |
| **Architecture** | MVC (Model-View-Controller) |
| **Build Tool** | Maven |
| **Server** | Apache Tomcat 10+ |

## 📁 Project Structure

```
StayEase/
├── src/main/java/com/stayease/
│   ├── config/         → Database configuration (Singleton)
│   ├── model/          → POJOs (User, Room, Booking, Payment, RoomType)
│   ├── dao/            → Data Access Objects (JDBC + PreparedStatement)
│   ├── service/        → Business logic layer
│   ├── controllers/    → Servlets (request handling)
│   ├── filter/         → Authentication & authorization filter
│   └── utils/          → Password hashing, validation utilities
├── src/main/webapp/
│   ├── css/            → Custom styles
│   ├── js/             → Client-side JavaScript
│   ├── images/         → Static images
│   └── WEB-INF/
│       ├── pages/      → JSP views (protected)
│       └── web.xml     → Deployment descriptor
├── database/
│   └── schema.sql      → Database schema + sample data
├── pom.xml             → Maven build configuration
└── README.md
```

## 🚀 Setup Instructions

### Prerequisites
- **Java JDK 17** or higher
- **Apache Tomcat 10.1+** (Jakarta EE compatible)
- **MySQL 8.0+**
- **Maven 3.8+**
- **Eclipse IDE** (Enterprise Edition recommended) or IntelliJ IDEA

### Step 1: Database Setup

1. Start your MySQL server
2. Open a MySQL client (MySQL Workbench, command line, etc.)
3. Run the schema file:

```sql
source /path/to/StayEase/database/schema.sql;
```

Or copy-paste the contents of `database/schema.sql` into your MySQL client and execute.

### Step 2: Configure Database Connection

Open `src/main/java/com/stayease/config/DBConfig.java` and update if needed:

```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/stayease_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = ""; // Set your MySQL password here
```

### Step 3: Import into Eclipse IDE

1. **File → Import → Maven → Existing Maven Projects**
2. Browse to the `StayEase` directory
3. Select `pom.xml` and click **Finish**
4. Wait for Maven to download dependencies
5. Right-click project → **Maven → Update Project**

### Step 4: Configure Tomcat in Eclipse

1. **Window → Show View → Servers**
2. Click "No servers available..." link or right-click → **New → Server**
3. Select **Apache Tomcat v10.1** and configure the installation directory
4. Click **Finish**

### Step 5: Run the Application

1. Right-click the project → **Run As → Run on Server**
2. Select your Tomcat server
3. Click **Finish**
4. Open browser: **http://localhost:8080/StayEase/home**

### Alternative: Command Line (without Eclipse)

```bash
cd StayEase
mvn clean package
# Copy target/StayEase.war to Tomcat's webapps/ directory
# Start Tomcat
```

## 👤 Test Accounts

| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@stayease.com | admin123 |
| **Staff** | emily@stayease.com | staff123 |
| **Staff** | david@stayease.com | staff123 |
| **Guest** | sarah@example.com | guest123 |
| **Guest** | michael@example.com | guest123 |

## ✨ Features

### 🔐 Authentication & Authorization
- SHA-256 password hashing
- Session-based authentication with 30-minute timeout
- Role-based access control (Guest / Staff / Admin)
- Authentication filter on protected URLs

### 🛏️ Room Management
- Browse all rooms with type, price, capacity, amenities
- Search available rooms by date range and guest count
- Real-time availability checking (excludes booked rooms)
- Admin: Full CRUD operations on rooms

### 📅 Booking System
- Date range validation (check-out must be after check-in)
- Auto-calculated pricing (price × nights)
- Unique booking references (STY-XXXXXXXX)
- Double-booking prevention
- Status workflow: Pending → Confirmed → Checked In → Checked Out
- Cancellation with automatic refund status

### 👨‍💼 Staff Features
- Dashboard with today's check-ins / check-outs
- Update booking status
- View guest details and special requests

### 🛡️ Admin Features
- Dashboard with revenue, bookings, occupancy stats
- Full room CRUD (add, edit, delete)
- Manage all bookings and users
- Reports with Chart.js visualizations (revenue, occupancy)
- User role management

### 💳 Payment Tracking
- Payment status tracking (pending, paid, refunded)
- Staff/Admin can update payment status

## 🔒 Security

- All JSP files inside `WEB-INF` (not directly accessible)
- All queries use `PreparedStatement` (SQL injection prevention)
- SHA-256 password hashing
- Session validation on protected pages
- Role-based access enforcement via `AuthFilter`
- XSS prevention via `ValidationUtil.escapeHtml()`
- CSRF protection via POST-only form submissions

## 📱 UI Features

- **Responsive design** (mobile, tablet, desktop)
- **Tailwind CSS** for modern styling
- **FontAwesome** icons throughout
- **Chart.js** for admin reports
- **Gradient color scheme** (navy blue + gold accent)
- **Custom CSS** for cards, badges, buttons, tables
- **Client-side validation** with JavaScript
- **Auto-hiding toast alerts**
- **Smooth page transitions** and hover animations

## 🗄️ Database Schema

```
users ─────────────┐
                    │
room_types ──┐     │
             │     │
rooms ───────┤     │
             │     │
bookings ────┼─────┘
             │
payments ────┘
```

- `users` → `bookings` (one-to-many)
- `rooms` → `bookings` (one-to-many)
- `room_types` → `rooms` (one-to-many)
- `bookings` → `payments` (one-to-one)

## 📝 License

This project is for educational purposes.

---

Built with ❤️ using Jakarta EE

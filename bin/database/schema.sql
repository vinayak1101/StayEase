-- ============================================
-- StayEase Hotel Booking System - Database Schema
-- ============================================

CREATE DATABASE IF NOT EXISTS stayease_db;
USE stayease_db;

-- ============================================
-- Users Table
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(256) NOT NULL,
    phone VARCHAR(20),
    role ENUM('guest', 'staff', 'admin') DEFAULT 'guest',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Room Types Table
-- ============================================
CREATE TABLE IF NOT EXISTS room_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    capacity INT NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL
);

-- ============================================
-- Rooms Table
-- ============================================
CREATE TABLE IF NOT EXISTS rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    floor INT NOT NULL,
    status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available',
    amenities TEXT,
    FOREIGN KEY (room_type_id) REFERENCES room_types(id) ON DELETE CASCADE
);

-- ============================================
-- Bookings Table
-- ============================================
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_reference VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL DEFAULT 1,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'checked_in', 'checked_out', 'cancelled') DEFAULT 'pending',
    special_requests TEXT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- ============================================
-- Payments Table
-- ============================================
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- ============================================
-- Insert Sample Data
-- ============================================

-- Room Types
INSERT INTO room_types (type_name, description, capacity, base_price) VALUES
('Standard', 'Comfortable room with essential amenities including free Wi-Fi, flat-screen TV, and a cozy queen-size bed.', 2, 100.00),
('Deluxe', 'Spacious room with premium furnishings, city view, mini-bar, work desk, and luxury bathroom amenities.', 3, 150.00),
('Suite', 'Luxurious suite with separate living area, king-size bed, panoramic views, jacuzzi, and complimentary minibar.', 4, 250.00);

-- Admin user (password: admin123 hashed with SHA-256)
INSERT INTO users (full_name, email, password, phone, role) VALUES
('System Admin', 'admin@stayease.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '+1-555-0100', 'admin');

-- Staff users (password: staff123 hashed with SHA-256)
INSERT INTO users (full_name, email, password, phone, role) VALUES
('Emily Johnson', 'emily@stayease.com', '10176e7b7b24d317acfcf8d2064cfd2f24e154f7b5a96603077d5ef813d6a6b6', '+1-555-0201', 'staff'),
('David Chen', 'david@stayease.com', '10176e7b7b24d317acfcf8d2064cfd2f24e154f7b5a96603077d5ef813d6a6b6', '+1-555-0202', 'staff');

-- Guest users (password: guest123 hashed with SHA-256)
INSERT INTO users (full_name, email, password, phone, role) VALUES
('Sarah Williams', 'sarah@example.com', '6b93ccba414ac1d0ae1e77f3fac560c748a6701ed6946735a49d463351518e16', '+1-555-0301', 'guest'),
('Michael Brown', 'michael@example.com', '6b93ccba414ac1d0ae1e77f3fac560c748a6701ed6946735a49d463351518e16', '+1-555-0302', 'guest'),
('Jessica Davis', 'jessica@example.com', '6b93ccba414ac1d0ae1e77f3fac560c748a6701ed6946735a49d463351518e16', '+1-555-0303', 'guest'),
('Robert Wilson', 'robert@example.com', '6b93ccba414ac1d0ae1e77f3fac560c748a6701ed6946735a49d463351518e16', '+1-555-0304', 'guest'),
('Amanda Taylor', 'amanda@example.com', '6b93ccba414ac1d0ae1e77f3fac560c748a6701ed6946735a49d463351518e16', '+1-555-0305', 'guest');

-- Rooms (10+ rooms across floors)
INSERT INTO rooms (room_number, room_type_id, floor, status, amenities) VALUES
('101', 1, 1, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Fridge'),
('102', 1, 1, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Fridge'),
('103', 1, 1, 'available', 'Wi-Fi, TV, Air Conditioning, Coffee Maker'),
('201', 2, 2, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Bar, City View, Work Desk'),
('202', 2, 2, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Bar, City View, Bathrobe'),
('203', 2, 2, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Bar, Garden View, Work Desk'),
('301', 3, 3, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Bar, Jacuzzi, Living Area, Panoramic View'),
('302', 3, 3, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Bar, Jacuzzi, Living Area, Balcony'),
('104', 1, 1, 'maintenance', 'Wi-Fi, TV, Air Conditioning, Mini Fridge'),
('204', 2, 2, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Bar, Pool View, Work Desk'),
('303', 3, 3, 'available', 'Wi-Fi, TV, Air Conditioning, Mini Bar, Jacuzzi, Living Area, Rooftop Access');

-- Sample Bookings
INSERT INTO bookings (booking_reference, user_id, room_id, check_in_date, check_out_date, number_of_guests, total_price, status, special_requests) VALUES
('STY-A1B2C3', 4, 1, '2026-05-10', '2026-05-13', 2, 300.00, 'confirmed', 'Late check-in around 10 PM'),
('STY-D4E5F6', 5, 4, '2026-05-12', '2026-05-15', 2, 450.00, 'pending', 'Extra pillows please'),
('STY-G7H8I9', 6, 7, '2026-05-08', '2026-05-11', 3, 750.00, 'checked_in', 'Anniversary celebration - champagne if possible'),
('STY-J1K2L3', 7, 2, '2026-05-01', '2026-05-03', 1, 200.00, 'checked_out', NULL),
('STY-M4N5O6', 8, 5, '2026-05-15', '2026-05-18', 2, 450.00, 'pending', 'Vegetarian breakfast preferred'),
('STY-P7Q8R9', 4, 6, '2026-05-20', '2026-05-22', 3, 300.00, 'confirmed', NULL),
('STY-S1T2U3', 5, 8, '2026-05-05', '2026-05-07', 2, 500.00, 'cancelled', 'Trip cancelled due to emergency'),
('STY-V4W5X6', 6, 3, '2026-05-18', '2026-05-21', 1, 300.00, 'confirmed', 'Ground floor room preferred');

-- Sample Payments
INSERT INTO payments (booking_id, amount, payment_status, payment_method, transaction_id) VALUES
(1, 300.00, 'paid', 'Credit Card', 'TXN-001-2026'),
(2, 450.00, 'pending', NULL, NULL),
(3, 750.00, 'paid', 'Debit Card', 'TXN-003-2026'),
(4, 200.00, 'paid', 'Credit Card', 'TXN-004-2026'),
(5, 450.00, 'pending', NULL, NULL),
(6, 300.00, 'paid', 'Online Banking', 'TXN-006-2026'),
(7, 500.00, 'refunded', 'Credit Card', 'TXN-007-2026'),
(8, 300.00, 'paid', 'Credit Card', 'TXN-008-2026');

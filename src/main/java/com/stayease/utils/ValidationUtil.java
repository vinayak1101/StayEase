package com.stayease.utils;

import java.sql.Date;
import java.time.LocalDate;
import java.util.regex.Pattern;

/**
 * Utility class for validating user input on the server side.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[+]?[0-9\\-\\s()]{7,20}$");

    /**
     * Validates an email address format.
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Validates a phone number format.
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Checks that a string is not null and not blank.
     */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /**
     * Validates that check-out date is after check-in date, and both are not in the past.
     */
    public static boolean isValidDateRange(Date checkIn, Date checkOut) {
        if (checkIn == null || checkOut == null) return false;
        LocalDate today = LocalDate.now();
        LocalDate checkInLocal = checkIn.toLocalDate();
        LocalDate checkOutLocal = checkOut.toLocalDate();
        return !checkInLocal.isBefore(today) && checkOutLocal.isAfter(checkInLocal);
    }

    /**
     * Validates that a date string can be parsed as a valid SQL date.
     */
    public static boolean isValidDateString(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return false;
        try {
            Date.valueOf(dateStr.trim());
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * Validates password length (minimum 6 characters).
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    /**
     * Validates full name (minimum 2 characters, only letters and spaces).
     */
    public static boolean isValidName(String name) {
        return name != null && name.trim().length() >= 2 && name.trim().matches("[A-Za-z\\s]+");
    }

    /**
     * Validates that a number of guests is positive and within capacity.
     */
    public static boolean isValidGuestCount(int guests, int capacity) {
        return guests > 0 && guests <= capacity;
    }

    /**
     * Escapes HTML special characters to prevent XSS.
     */
    public static String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                     .replace("<", "&lt;")
                     .replace(">", "&gt;")
                     .replace("\"", "&quot;")
                     .replace("'", "&#x27;");
    }
}

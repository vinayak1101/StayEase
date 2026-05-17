package com.stayease.service;

import com.stayease.dao.UserDAO;
import com.stayease.model.User;
import com.stayease.utils.PasswordUtil;
import com.stayease.utils.ValidationUtil;

/**
 * Service layer for authentication and user management business logic.
 */
public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    /**
     * Authenticates a user with email and plaintext password.
     * @return the User if credentials are valid, null otherwise
     */
    public User login(String email, String password) {
        if (!ValidationUtil.isNotEmpty(email) || !ValidationUtil.isNotEmpty(password)) {
            return null;
        }
        String hashedPassword = PasswordUtil.hashPassword(password);
        return userDAO.loginUser(email.trim(), hashedPassword);
    }

    /**
     * Registers a new user after validation.
     * @return null on success, or an error message string on failure
     */
    public String register(String fullName, String email, String password, String phone) {
        if (!ValidationUtil.isValidName(fullName)) {
            return "Please enter a valid full name (letters and spaces only).";
        }
        if (!ValidationUtil.isValidEmail(email)) {
            return "Please enter a valid email address.";
        }
        if (!ValidationUtil.isValidPassword(password)) {
            return "Password must be at least 6 characters long.";
        }
        if (ValidationUtil.isNotEmpty(phone) && !ValidationUtil.isValidPhone(phone)) {
            return "Please enter a valid phone number.";
        }
        if (userDAO.emailExists(email.trim())) {
            return "An account with this email already exists.";
        }
        String hashedPassword = PasswordUtil.hashPassword(password);
        User user = new User(fullName.trim(), email.trim(), hashedPassword, phone != null ? phone.trim() : "", "guest");
        boolean success = userDAO.registerUser(user);
        return success ? null : "Registration failed. Please try again.";
    }

    /**
     * Verifies if a user exists with the given email and phone number.
     * @return true if user is verified, false otherwise
     */
    public boolean verifyUserForPasswordReset(String email, String phone) {
        if (!ValidationUtil.isNotEmpty(email) || !ValidationUtil.isNotEmpty(phone)) {
            return false;
        }
        User user = userDAO.getUserByEmailAndPhone(email.trim(), phone.trim());
        return user != null;
    }

    /**
     * Resets a user's password.
     * @return null on success, error message on failure
     */
    public String resetPassword(String email, String newPassword) {
        if (!ValidationUtil.isValidPassword(newPassword)) {
            return "Password must be at least 6 characters long.";
        }
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        boolean success = userDAO.updatePassword(email.trim(), hashedPassword);
        return success ? null : "Failed to reset password. Please try again.";
    }
}

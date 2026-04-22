package com.spendwise.dao;

import com.spendwise.model.User;
import com.spendwise.util.DBConnection;
import java.security.MessageDigest;
import java.sql.*;

public class UserDAO {

    // Hash password using SHA-256
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) hex.append(String.format("%02x", b));
            return hex.toString();
        } catch (Exception e) {
            throw new RuntimeException("Hashing failed", e);
        }
    }

    // Register new user
    public boolean registerUser(String fullName, String email, String password) {
        String sql = "INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, hashPassword(password));
            ps.executeUpdate();
            return true;

        } catch (SQLIntegrityConstraintViolationException e) {
            return false; // email already exists
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Validate login
    public User loginUser(String email, String password) {
        String sql = "SELECT id, full_name, email FROM users WHERE email=? AND password=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, hashPassword(password));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(rs.getInt("id"), rs.getString("full_name"), rs.getString("email"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

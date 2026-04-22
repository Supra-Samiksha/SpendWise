package com.spendwise.dao;

import com.spendwise.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class SubscriptionDAO {

    public List<Map<String, Object>> detectSubscriptions(int userId) {
        String sql = "SELECT description, " +
            "ROUND(AVG(amount)::numeric, 2) AS avg_amount, " +
            "COUNT(DISTINCT DATE_TRUNC('month', transaction_date)) AS month_count, " +
            "MAX(transaction_date) AS last_date, category " +
            "FROM bank_transactions " +
            "WHERE user_id=? AND amount < 0 " +
            "GROUP BY description, category " +
            "HAVING COUNT(DISTINCT DATE_TRUNC('month', transaction_date)) >= 2 " +
            "ORDER BY month_count DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("description", rs.getString("description"));
                row.put("avgAmount",   rs.getBigDecimal("avg_amount").abs());
                row.put("monthCount",  rs.getInt("month_count"));
                row.put("lastDate",    rs.getDate("last_date"));
                row.put("category",    rs.getString("category"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean saveSubscription(int userId, String name, BigDecimal amount, String nextDue) {
        String sql = "INSERT INTO subscriptions (user_id, name, amount, next_due) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, name);
            ps.setBigDecimal(3, amount);
            ps.setDate(4, java.sql.Date.valueOf(nextDue));
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Map<String, Object>> getSavedSubscriptions(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM subscriptions WHERE user_id=? AND is_active=TRUE ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("id",      rs.getInt("id"));
                row.put("name",    rs.getString("name"));
                row.put("amount",  rs.getBigDecimal("amount"));
                row.put("nextDue", rs.getDate("next_due"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean cancelSubscription(int id, int userId) {
        String sql = "UPDATE subscriptions SET is_active=FALSE WHERE id=? AND user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}

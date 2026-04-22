package com.spendwise.dao;

import com.spendwise.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;

public class BudgetDAO {

    public boolean setBudget(int userId, int month, int year, BigDecimal amount) {
        String sql = "INSERT INTO budgets (user_id, month, year, total_budget) VALUES (?,?,?,?) " +
                     "ON CONFLICT (user_id, month, year) DO UPDATE SET total_budget = EXCLUDED.total_budget";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            ps.setBigDecimal(4, amount);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public BigDecimal getBudget(int userId, int month, int year) {
        String sql = "SELECT total_budget FROM budgets WHERE user_id=? AND month=? AND year=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal("total_budget");
        } catch (Exception e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    public BigDecimal getTotalSpent(int userId, int month, int year) {
        String sql = "SELECT " +
            "COALESCE((SELECT SUM(amount) FROM expenses " +
            "  WHERE user_id=? AND EXTRACT(MONTH FROM expense_date)=? AND EXTRACT(YEAR FROM expense_date)=?), 0) " +
            "+ COALESCE((SELECT ABS(SUM(amount)) FROM bank_transactions " +
            "  WHERE user_id=? AND EXTRACT(MONTH FROM transaction_date)=? AND EXTRACT(YEAR FROM transaction_date)=? AND amount < 0), 0) " +
            "AS total_spent";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, month); ps.setInt(3, year);
            ps.setInt(4, userId); ps.setInt(5, month); ps.setInt(6, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal("total_spent");
        } catch (Exception e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }
}

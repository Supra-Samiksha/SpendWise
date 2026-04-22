package com.spendwise.dao;

import com.spendwise.model.Expense;
import com.spendwise.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class ExpenseDAO {

    public boolean addExpense(Expense e) {
        String sql = "INSERT INTO expenses (user_id, title, amount, category, expense_date, notes) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, e.getUserId());
            ps.setString(2, e.getTitle());
            ps.setBigDecimal(3, e.getAmount());
            ps.setString(4, e.getCategory());
            ps.setDate(5, e.getExpenseDate());
            ps.setString(6, e.getNotes());
            ps.executeUpdate();
            return true;
        } catch (Exception ex) { ex.printStackTrace(); return false; }
    }

    public List<Expense> getExpensesByUser(int userId) {
        List<Expense> list = new ArrayList<>();
        String sql = "SELECT * FROM expenses WHERE user_id=? ORDER BY expense_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Expense e = new Expense();
                e.setId(rs.getInt("id"));
                e.setUserId(userId);
                e.setTitle(rs.getString("title"));
                e.setAmount(rs.getBigDecimal("amount"));
                e.setCategory(rs.getString("category"));
                e.setExpenseDate(rs.getDate("expense_date"));
                e.setNotes(rs.getString("notes"));
                list.add(e);
            }
        } catch (Exception ex) { ex.printStackTrace(); }
        return list;
    }

    public Expense getExpenseById(int id) {
        String sql = "SELECT * FROM expenses WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Expense e = new Expense();
                e.setId(rs.getInt("id"));
                e.setUserId(rs.getInt("user_id"));
                e.setTitle(rs.getString("title"));
                e.setAmount(rs.getBigDecimal("amount"));
                e.setCategory(rs.getString("category"));
                e.setExpenseDate(rs.getDate("expense_date"));
                e.setNotes(rs.getString("notes"));
                return e;
            }
        } catch (Exception ex) { ex.printStackTrace(); }
        return null;
    }

    public boolean updateExpense(Expense e) {
        String sql = "UPDATE expenses SET title=?, amount=?, category=?, expense_date=?, notes=? WHERE id=? AND user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getTitle());
            ps.setBigDecimal(2, e.getAmount());
            ps.setString(3, e.getCategory());
            ps.setDate(4, e.getExpenseDate());
            ps.setString(5, e.getNotes());
            ps.setInt(6, e.getId());
            ps.setInt(7, e.getUserId());
            ps.executeUpdate();
            return true;
        } catch (Exception ex) { ex.printStackTrace(); return false; }
    }

    public boolean deleteExpense(int id, int userId) {
        String sql = "DELETE FROM expenses WHERE id=? AND user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ps.executeUpdate();
            return true;
        } catch (Exception ex) { ex.printStackTrace(); return false; }
    }

    public BigDecimal getTotalByMonth(int userId, int month, int year) {
        String sql = "SELECT COALESCE(SUM(amount),0) FROM expenses WHERE user_id=? AND EXTRACT(MONTH FROM expense_date)=? AND EXTRACT(YEAR FROM expense_date)=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (Exception ex) { ex.printStackTrace(); }
        return BigDecimal.ZERO;
    }
}

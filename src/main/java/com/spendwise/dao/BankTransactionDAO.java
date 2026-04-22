package com.spendwise.dao;

import com.spendwise.model.BankTransaction;
import com.spendwise.util.DBConnection;
import java.sql.*;
import java.util.*;

public class BankTransactionDAO {

    // Returns true if inserted, false if duplicate
    public boolean insertIfNotDuplicate(BankTransaction txn) {
        String sql = "INSERT INTO bank_transactions (user_id, transaction_id, description, amount, transaction_date, category) " +
                     "VALUES (?,?,?,?,?,?) ON CONFLICT (user_id, transaction_id) DO NOTHING";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, txn.getUserId());
            ps.setString(2, txn.getTransactionId());
            ps.setString(3, txn.getDescription());
            ps.setBigDecimal(4, txn.getAmount());
            ps.setDate(5, txn.getTransactionDate());
            ps.setString(6, txn.getCategory());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<BankTransaction> getAllByUser(int userId) {
        List<BankTransaction> list = new ArrayList<>();
        String sql = "SELECT * FROM bank_transactions WHERE user_id=? ORDER BY transaction_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BankTransaction t = new BankTransaction();
                t.setId(rs.getInt("id"));
                t.setUserId(userId);
                t.setTransactionId(rs.getString("transaction_id"));
                t.setDescription(rs.getString("description"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setTransactionDate(rs.getDate("transaction_date"));
                t.setCategory(rs.getString("category"));
                list.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
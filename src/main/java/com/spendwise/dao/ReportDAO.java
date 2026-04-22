package com.spendwise.dao;

import com.spendwise.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ReportDAO {

    // Category totals (manual expenses)
    public List<Map<String, Object>> getCategoryTotals(int userId, int month, int year) {
        String sql = """
            SELECT category,
                   SUM(amount) AS total,
                   COUNT(*) AS txn_count
            FROM expenses
            WHERE user_id=?
              AND EXTRACT(MONTH FROM expense_date)=?
              AND EXTRACT(YEAR FROM expense_date)=?
            GROUP BY category
            ORDER BY total DESC
            """;
        return runQuery(sql, userId, month, year);
    }

    // Monthly spending trend (last 6 months)
    public List<Map<String, Object>> getMonthlyTrend(int userId) {
        String sql = """
            SELECT TO_CHAR(expense_date, 'Mon YYYY') AS month_label,
                   EXTRACT(YEAR FROM expense_date)  AS yr,
                   EXTRACT(MONTH FROM expense_date) AS mo,
                   SUM(amount) AS total
            FROM expenses
            WHERE user_id=?
            GROUP BY month_label, yr, mo
            ORDER BY yr DESC, mo DESC
            LIMIT 6
            """;
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("label", rs.getString("month_label"));
                row.put("total", rs.getBigDecimal("total"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Bank transaction category totals
    public List<Map<String, Object>> getBankCategoryTotals(int userId, int month, int year) {
        String sql = """
            SELECT category,
                   ABS(SUM(amount)) AS total,
                   COUNT(*) AS txn_count
            FROM bank_transactions
            WHERE user_id=?
              AND EXTRACT(MONTH FROM transaction_date)=?
              AND EXTRACT(YEAR FROM transaction_date)=?
              AND amount < 0
            GROUP BY category
            ORDER BY total DESC
            """;
        return runQuery(sql, userId, month, year);
    }

    private List<Map<String, Object>> runQuery(String sql, int userId, int month, int year) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, month); ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("category",  rs.getString("category"));
                row.put("total",     rs.getBigDecimal("total"));
                row.put("txnCount",  rs.getInt("txn_count"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
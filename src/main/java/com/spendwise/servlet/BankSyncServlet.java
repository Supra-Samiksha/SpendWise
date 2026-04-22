package com.spendwise.servlet;

import com.spendwise.dao.BankTransactionDAO;
import com.spendwise.model.BankTransaction;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/banksync")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB max
public class BankSyncServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        BankTransactionDAO dao = new BankTransactionDAO();
        List<BankTransaction> transactions = dao.getAllByUser(userId);
        req.setAttribute("transactions", transactions);
        req.getRequestDispatcher("banksync.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        Part filePart = req.getPart("csvFile");

        if (filePart == null || filePart.getSize() == 0) {
            req.setAttribute("error", "Please select a CSV file.");
            req.getRequestDispatcher("banksync.jsp").forward(req, res);
            return;
        }

        BankTransactionDAO dao = new BankTransactionDAO();
        int inserted = 0, skipped = 0;

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(filePart.getInputStream()))) {

            String line;
            boolean firstLine = true;

            while ((line = reader.readLine()) != null) {
                if (firstLine) { firstLine = false; continue; } // skip header
                if (line.trim().isEmpty()) continue;

                String[] cols = line.split(",");
                if (cols.length < 5) continue;

                BankTransaction txn = new BankTransaction();
                txn.setUserId(userId);
                txn.setTransactionId(cols[0].trim());
                txn.setTransactionDate(Date.valueOf(cols[1].trim()));
                txn.setDescription(cols[2].trim());
                txn.setAmount(new BigDecimal(cols[3].trim()));
                txn.setCategory(cols[4].trim());

                if (dao.insertIfNotDuplicate(txn)) inserted++;
                else skipped++;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error parsing CSV: " + e.getMessage());
            req.getRequestDispatcher("banksync.jsp").forward(req, res);
            return;
        }

        res.sendRedirect("banksync?inserted=" + inserted + "&skipped=" + skipped);
    }
}

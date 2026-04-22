package com.spendwise.servlet;

import com.spendwise.dao.ExpenseDAO;
import com.spendwise.model.Expense;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/expenses")
public class ExpenseServlet extends HttpServlet {

    private ExpenseDAO dao = new ExpenseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Expense e = dao.getExpenseById(id);
            req.setAttribute("expense", e);
            req.getRequestDispatcher("editExpense.jsp").forward(req, res);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteExpense(id, userId);
            res.sendRedirect("expenses?msg=deleted");

        } else {
            List<Expense> list = dao.getExpensesByUser(userId);
            req.setAttribute("expenses", list);
            req.getRequestDispatcher("expenses.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");

        Expense e = new Expense();
        e.setUserId(userId);
        e.setTitle(req.getParameter("title").trim());
        e.setAmount(new BigDecimal(req.getParameter("amount")));
        e.setCategory(req.getParameter("category"));
        e.setExpenseDate(Date.valueOf(req.getParameter("expenseDate")));
        e.setNotes(req.getParameter("notes") != null ? req.getParameter("notes").trim() : "");

        if ("update".equals(action)) {
            e.setId(Integer.parseInt(req.getParameter("id")));
            dao.updateExpense(e);
            res.sendRedirect("expenses?msg=updated");
        } else {
            dao.addExpense(e);
            res.sendRedirect("expenses?msg=added");
        }
    }
}
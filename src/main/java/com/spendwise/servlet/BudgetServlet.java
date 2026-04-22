package com.spendwise.servlet;

import com.spendwise.dao.BudgetDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/budget")
public class BudgetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year  = now.getYear();

        BudgetDAO dao = new BudgetDAO();
        BigDecimal budget = dao.getBudget(userId, month, year);
        BigDecimal spent  = dao.getTotalSpent(userId, month, year);
        BigDecimal remaining = budget.subtract(spent);
        double percent = budget.doubleValue() > 0
            ? Math.min(100, (spent.doubleValue() / budget.doubleValue()) * 100)
            : 0;

        req.setAttribute("budget",    budget);
        req.setAttribute("spent",     spent);
        req.setAttribute("remaining", remaining);
        req.setAttribute("percent",   Math.round(percent));
        req.setAttribute("month",     month);
        req.setAttribute("year",      year);

        req.getRequestDispatcher("budget.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        BigDecimal amount = new BigDecimal(req.getParameter("budgetAmount"));
        int month = Integer.parseInt(req.getParameter("month"));
        int year  = Integer.parseInt(req.getParameter("year"));

        new BudgetDAO().setBudget(userId, month, year, amount);
        res.sendRedirect("budget?msg=saved");
    }
}
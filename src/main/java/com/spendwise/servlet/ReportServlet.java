package com.spendwise.servlet;

import com.spendwise.dao.ReportDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        LocalDate now = LocalDate.now();

        int month = req.getParameter("month") != null
            ? Integer.parseInt(req.getParameter("month")) : now.getMonthValue();
        int year  = req.getParameter("year") != null
            ? Integer.parseInt(req.getParameter("year"))  : now.getYear();

        ReportDAO dao = new ReportDAO();
        req.setAttribute("categoryTotals",     dao.getCategoryTotals(userId, month, year));
        req.setAttribute("bankCategoryTotals", dao.getBankCategoryTotals(userId, month, year));
        req.setAttribute("monthlyTrend",       dao.getMonthlyTrend(userId));
        req.setAttribute("month", month);
        req.setAttribute("year",  year);

        req.getRequestDispatcher("reports.jsp").forward(req, res);
    }
}
package com.spendwise.servlet;

import com.spendwise.dao.SubscriptionDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet("/subscriptions")
public class SubscriptionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");
        SubscriptionDAO dao = new SubscriptionDAO();

        if ("cancel".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.cancelSubscription(id, userId);
            res.sendRedirect("subscriptions?msg=cancelled");
            return;
        }

        List<Map<String, Object>> detected = dao.detectSubscriptions(userId);
        List<Map<String, Object>> saved    = dao.getSavedSubscriptions(userId);

        req.setAttribute("detected", detected);
        req.setAttribute("saved", saved);
        req.getRequestDispatcher("subscriptions.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        SubscriptionDAO dao = new SubscriptionDAO();

        String name    = req.getParameter("name");
        BigDecimal amt = new BigDecimal(req.getParameter("amount"));
        String nextDue = req.getParameter("nextDue");

        dao.saveSubscription(userId, name, amt, nextDue);
        res.sendRedirect("subscriptions?msg=saved");
    }
}

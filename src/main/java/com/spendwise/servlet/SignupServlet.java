package com.spendwise.servlet;

import com.spendwise.dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName").trim();
        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();

        if (fullName.isEmpty() || email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("signup.jsp").forward(req, res);
            return;
        }

        UserDAO dao = new UserDAO();
        boolean success = dao.registerUser(fullName, email, password);

        if (success) {
            res.sendRedirect("login.jsp?registered=true");
        } else {
            req.setAttribute("error", "Email already registered. Please login.");
            req.getRequestDispatcher("signup.jsp").forward(req, res);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        res.sendRedirect("signup.jsp");
    }
}

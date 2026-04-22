package com.spendwise.servlet;

import com.spendwise.util.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.Connection;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        try (Connection conn = DBConnection.getConnection()) {
            out.println("<h2 style='color:green'>✅ Database connected successfully!</h2>");
            out.println("<p>Connected to: " + conn.getMetaData().getURL() + "</p>");
        } catch (Exception e) {
            out.println("<h2 style='color:red'>❌ Connection failed: " + e.getMessage() + "</h2>");
        }
    }
}

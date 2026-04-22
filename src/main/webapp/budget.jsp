<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // Session check
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Data from servlet — guard against null values
    BigDecimal budget    = (BigDecimal) request.getAttribute("budget");
    BigDecimal spent     = (BigDecimal) request.getAttribute("spent");
    BigDecimal remaining = (BigDecimal) request.getAttribute("remaining");

    // Provide safe defaults so the page never renders "null"
    if (budget    == null) budget    = BigDecimal.ZERO;
    if (spent     == null) spent     = BigDecimal.ZERO;
    if (remaining == null) remaining = BigDecimal.ZERO;

    Integer percentObj = (Integer) request.getAttribute("percent");
    Integer monthObj   = (Integer) request.getAttribute("month");
    Integer yearObj    = (Integer) request.getAttribute("year");

    int percent = (percentObj != null) ? percentObj : 0;
    int month   = (monthObj   != null) ? monthObj   : 1;
    int year    = (yearObj    != null) ? yearObj     : 2026;

    // Safe comparison — no NPE possible now
    boolean overBudget = remaining.doubleValue() < 0;

    String[] months = {"", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SpendWise – Budget</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>

<body>
<div class="layout">

    <%@ include file="sidebar.jsp" %>

    <main class="main-content">

        <div class="page-header">
            <h1>Monthly Budget</h1>
        </div>

        <% if ("saved".equals(request.getParameter("msg"))) { %>
            <div class="alert success">Budget saved!</div>
        <% } %>

        <!-- Summary Cards -->
        <div class="cards-row">

            <div class="stat-card">
                <div class="stat-label">Budget Set</div>
                <div class="stat-value">₹<%= String.format("%.0f", budget) %></div>
                <div class="stat-sub"><%= months[month] %> <%= year %></div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Total Spent</div>
                <div class="stat-value" style="color:#E67E22">
                    ₹<%= String.format("%.0f", spent) %>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Remaining</div>

                <div class="stat-value"
                     style="color:<%= overBudget ? "#e74c3c" : "#2ECC71" %>">
                    ₹<%= String.format("%.0f", remaining) %>
                </div>

                <% if (overBudget) { %>
                    <div class="stat-sub" style="color:#e74c3c">
                        ⚠ Over budget!
                    </div>
                <% } %>

            </div>

        </div>

        <!-- Progress Bar -->
        <div class="card" style="margin-top:24px">

            <div style="display:flex;justify-content:space-between;margin-bottom:8px">
                <span style="color:#34495E;font-weight:600">Spending Progress</span>

                <span style="color:<%= overBudget ? "#e74c3c" : "#34495E" %>">
                    <%= percent %>%
                </span>
            </div>

            <div class="progress-bar">
                <div class="progress-fill <%= overBudget ? "over" : "" %>"
                     style="width:<%= Math.min(percent, 100) %>%">
                </div>
            </div>

        </div>

        <!-- Set Budget Form -->
        <div class="card" style="max-width:480px;margin-top:24px">

            <h3 style="margin-bottom:16px;color:#2C3E50">Set Budget</h3>

            <form action="budget" method="post">

                <div class="form-row">

                    <div class="form-group">
                        <label>Month</label>
                        <select name="month">
                            <% for (int m = 1; m <= 12; m++) { %>
                                <option value="<%= m %>" <%= m == month ? "selected" : "" %>>
                                    <%= months[m] %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Year</label>
                        <input type="number" name="year"
                               value="<%= year %>" min="2020" max="2030"/>
                    </div>

                </div>

                <div class="form-group">
                    <label>Budget Amount (₹)</label>
                    <input type="number" name="budgetAmount"
                           step="100" placeholder="e.g. 20000" required/>
                </div>

                <button type="submit" class="btn-primary">
                    Save Budget
                </button>

            </form>

        </div>

    </main>
</div>
</body>
</html>

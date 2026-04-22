<%@ page import="com.spendwise.model.User" %>
<%
    User sidebarUser = (User) session.getAttribute("user");
    String currentPage = request.getServletPath();
%>
<nav class="sidebar">
    <div class="sidebar-logo">💰 SpendWise</div>

    <% if (sidebarUser != null) { %>
        <div class="sidebar-user">
            <div class="user-avatar"><%= sidebarUser.getFullName().charAt(0) %></div>
            <div class="user-info">
                <div class="user-name"><%= sidebarUser.getFullName() %></div>
                <div class="user-email"><%= sidebarUser.getEmail() %></div>
            </div>
        </div>
    <% } %>

    <ul class="nav-list">
        <li class="nav-item <%= currentPage.contains("dashboard") ? "active" : "" %>">
            <a href="dashboard.jsp">🏠 Dashboard</a>
        </li>
        <li class="nav-item <%= currentPage.contains("expenses") ? "active" : "" %>">
            <a href="expenses">💸 Expenses</a>
        </li>
        <li class="nav-item <%= currentPage.contains("banksync") ? "active" : "" %>">
            <a href="banksync">🏦 Bank Sync</a>
        </li>
        <li class="nav-item <%= currentPage.contains("subscriptions") ? "active" : "" %>">
            <a href="subscriptions">🔄 Subscriptions</a>
        </li>
        <li class="nav-item <%= currentPage.contains("budget") ? "active" : "" %>">
            <a href="budget">🎯 Budget</a>
        </li>
        <li class="nav-item <%= currentPage.contains("reports") ? "active" : "" %>">
            <a href="reports">📊 Reports</a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="logout" class="logout-btn">⬅ Logout</a>
    </div>
</nav>
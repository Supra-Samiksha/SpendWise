<%@ page import="com.spendwise.model.User" %>
<%
    User sidebarUser = (User) session.getAttribute("user");
    String cp = request.getServletPath() + request.getRequestURI();
%>
<nav class="sidebar">
    <div class="sidebar-logo">SpendWise</div>

    <% if (sidebarUser != null) { %>
    <div class="sidebar-user">
        <div class="user-avatar">
            <%= sidebarUser.getFullName().toUpperCase().charAt(0) %>
        </div>
        <div class="user-info">
            <div class="user-name"><%= sidebarUser.getFullName() %></div>
            <div class="user-email"><%= sidebarUser.getEmail() %></div>
        </div>
    </div>
    <% } %>

    <ul class="nav-list">
        <li class="nav-item">
            <a href="dashboard.jsp"
               class="<%= request.getRequestURI().contains("dashboard") ? "active" : "" %>">
                <span class="nav-icon">&#9632;</span> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a href="expenses"
               class="<%= request.getRequestURI().contains("expenses") ? "active" : "" %>">
                <span class="nav-icon">&#9632;</span> Expenses
            </a>
        </li>
        <li class="nav-item">
            <a href="banksync"
               class="<%= request.getRequestURI().contains("banksync") ? "active" : "" %>">
                <span class="nav-icon">&#9632;</span> Bank Sync
            </a>
        </li>
        <li class="nav-item">
            <a href="subscriptions"
               class="<%= request.getRequestURI().contains("subscriptions") ? "active" : "" %>">
                <span class="nav-icon">&#9632;</span> Subscriptions
            </a>
        </li>
        <li class="nav-item">
            <a href="budget"
               class="<%= request.getRequestURI().contains("budget") ? "active" : "" %>">
                <span class="nav-icon">&#9632;</span> Budget
            </a>
        </li>
        <li class="nav-item">
            <a href="reports"
               class="<%= request.getRequestURI().contains("reports") ? "active" : "" %>">
                <span class="nav-icon">&#9632;</span> Reports
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="logout" class="logout-btn">&#8592; Logout</a>
    </div>
</nav>
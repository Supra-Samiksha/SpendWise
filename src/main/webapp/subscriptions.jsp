<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Map<String,Object>> detected = (List<Map<String,Object>>) request.getAttribute("detected");
    List<Map<String,Object>> saved    = (List<Map<String,Object>>) request.getAttribute("saved");
%>
<!DOCTYPE html>
<html>
<head>
    <title>SpendWise – Subscriptions</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <main class="main-content">
        <div class="page-header"><h1>Subscriptions</h1></div>

        <% String msg = request.getParameter("msg");
           if ("saved".equals(msg))     { %><div class="alert success">Subscription tracked!</div><% }
           if ("cancelled".equals(msg)) { %><div class="alert error">Subscription cancelled.</div><% } %>

        <!-- Auto-detected subscriptions -->
        <div class="card" style="margin-bottom:24px">
            <h3 style="color:#2C3E50;margin-bottom:16px">🔍 Auto-detected Recurring Payments</h3>
            <% if (detected != null && !detected.isEmpty()) { %>
                <table class="data-table">
                    <thead>
                        <tr><th>Description</th><th>Avg Amount</th><th>Months Seen</th><th>Last Date</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                    <% for (Map<String,Object> row : detected) { %>
                        <tr>
                            <td><%= row.get("description") %></td>
                            <td class="amount debit">₹<%= row.get("avgAmount") %></td>
                            <td><span class="badge"><%= row.get("monthCount") %> months</span></td>
                            <td><%= row.get("lastDate") %></td>
                            <td>
                                <form action="subscriptions" method="post" style="display:inline">
                                    <input type="hidden" name="name" value="<%= row.get("description") %>"/>
                                    <input type="hidden" name="amount" value="<%= row.get("avgAmount") %>"/>
                                    <input type="hidden" name="nextDue" value="2024-04-05"/>
                                    <button type="submit" class="btn-edit">Track</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p style="color:#999;text-align:center;padding:24px">
                    No recurring payments detected yet. Upload more bank statements.
                </p>
            <% } %>
        </div>

        <!-- Tracked subscriptions -->
        <div class="card">
            <h3 style="color:#2C3E50;margin-bottom:16px">📋 Tracked Subscriptions</h3>
            <% if (saved != null && !saved.isEmpty()) { %>
                <table class="data-table">
                    <thead>
                        <tr><th>Name</th><th>Amount/Month</th><th>Next Due</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                    <% for (Map<String,Object> s : saved) { %>
                        <tr>
                            <td><%= s.get("name") %></td>
                            <td class="amount debit">₹<%= s.get("amount") %></td>
                            <td><%= s.get("nextDue") %></td>
                            <td>
                                <a href="subscriptions?action=cancel&id=<%= s.get("id") %>"
                                   class="btn-delete"
                                   onclick="return confirm('Cancel this subscription?')">Cancel</a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p style="color:#999;text-align:center;padding:24px">No subscriptions tracked yet.</p>
            <% } %>
        </div>
    </main>
</div>
</body>
</html>
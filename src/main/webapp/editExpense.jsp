<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.spendwise.model.Expense" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    Expense e = (Expense) request.getAttribute("expense");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Expense</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <main class="main-content">
        <div class="page-header"><h1>Edit Expense</h1></div>
        <div class="card" style="max-width:520px">
            <form action="expenses" method="post">
                <input type="hidden" name="action" value="update"/>
                <input type="hidden" name="id" value="<%= e.getId() %>"/>
                <div class="form-group">
                    <label>Title</label>
                    <input type="text" name="title" value="<%= e.getTitle() %>" required/>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Amount (₹)</label>
                        <input type="number" name="amount" step="0.01" value="<%= e.getAmount() %>" required/>
                    </div>
                    <div class="form-group">
                        <label>Date</label>
                        <input type="date" name="expenseDate" value="<%= e.getExpenseDate() %>" required/>
                    </div>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select name="category">
                        <% String[] cats = {"Food","Transport","Shopping","Entertainment","Health","Utilities","Rent","Subscriptions","Other"};
                           for (String c : cats) { %>
                            <option <%= c.equals(e.getCategory()) ? "selected" : "" %>><%= c %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Notes</label>
                    <input type="text" name="notes" value="<%= e.getNotes() != null ? e.getNotes() : "" %>"/>
                </div>
                <div class="form-actions">
                    <a href="expenses" class="btn-secondary">Cancel</a>
                    <button type="submit" class="btn-primary">Update</button>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>
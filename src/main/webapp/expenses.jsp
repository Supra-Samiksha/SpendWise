<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.spendwise.model.Expense, java.util.List" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Expense> expenses = (List<Expense>) request.getAttribute("expenses");
%>
<!DOCTYPE html>
<html>
<head>
    <title>SpendWise – Expenses</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <main class="main-content">
        <div class="page-header">
            <h1>My Expenses</h1>
            <button class="btn-primary" onclick="document.getElementById('addModal').style.display='flex'">+ Add Expense</button>
        </div>

        <% String msg = request.getParameter("msg");
           if ("added".equals(msg))   { %><div class="alert success">Expense added!</div><% }
           if ("updated".equals(msg)) { %><div class="alert success">Expense updated!</div><% }
           if ("deleted".equals(msg)) { %><div class="alert error">Expense deleted.</div><% } %>

        <div class="card">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date</th><th>Title</th><th>Category</th>
                        <th>Amount</th><th>Notes</th><th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (expenses != null) {
                    for (Expense e : expenses) { %>
                    <tr>
                        <td><%= e.getExpenseDate() %></td>
                        <td><%= e.getTitle() %></td>
                        <td><span class="badge"><%= e.getCategory() %></span></td>
                        <td class="amount">₹<%= e.getAmount() %></td>
                        <td><%= e.getNotes() != null ? e.getNotes() : "" %></td>
                        <td>
                            <a href="expenses?action=edit&id=<%= e.getId() %>" class="btn-edit">Edit</a>
                            <a href="expenses?action=delete&id=<%= e.getId() %>"
                               class="btn-delete"
                               onclick="return confirm('Delete this expense?')">Delete</a>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="6" style="text-align:center;color:#999">No expenses yet. Add one!</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Add Expense Modal -->
        <div id="addModal" class="modal" style="display:none">
            <div class="modal-content">
                <h3>Add Expense</h3>
                <form action="expenses" method="post">
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" required placeholder="e.g. Lunch at Cafe"/>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Amount (₹)</label>
                            <input type="number" name="amount" step="0.01" required placeholder="0.00"/>
                        </div>
                        <div class="form-group">
                            <label>Date</label>
                            <input type="date" name="expenseDate" required/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <select name="category">
                            <option>Food</option><option>Transport</option>
                            <option>Shopping</option><option>Entertainment</option>
                            <option>Health</option><option>Utilities</option>
                            <option>Rent</option><option>Subscriptions</option>
                            <option>Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Notes (optional)</label>
                        <input type="text" name="notes" placeholder="Any notes..."/>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary"
                                onclick="document.getElementById('addModal').style.display='none'">Cancel</button>
                        <button type="submit" class="btn-primary">Save Expense</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
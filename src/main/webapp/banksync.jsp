<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.spendwise.model.BankTransaction, java.util.List" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    List<BankTransaction> transactions = (List<BankTransaction>) request.getAttribute("transactions");
    String inserted = request.getParameter("inserted");
    String skipped  = request.getParameter("skipped");
%>
<!DOCTYPE html>
<html>
<head>
    <title>SpendWise – Bank Sync</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <main class="main-content">
        <div class="page-header"><h1>Bank Sync</h1></div>

        <% if (inserted != null) { %>
            <div class="alert success">
                ✅ Sync complete: <strong><%= inserted %></strong> new transactions added,
                <strong><%= skipped %></strong> duplicates skipped.
            </div>
        <% } %>
        <% String error = (String) request.getAttribute("error");
           if (error != null) { %><div class="alert error"><%= error %></div><% } %>

        <!-- Upload Card -->
        <div class="card" style="max-width:480px;margin-bottom:24px">
            <h3 style="margin-bottom:16px;color:#2C3E50">Upload Bank Statement (CSV)</h3>
            <form action="banksync" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Select CSV File</label>
                    <input type="file" name="csvFile" accept=".csv" required style="padding:8px"/>
                </div>
                <p style="font-size:0.82rem;color:#999;margin-bottom:12px">
                    CSV format: transaction_id, date, description, amount, category
                </p>
                <button type="submit" class="btn-primary">Upload &amp; Sync</button>
            </form>
        </div>

        <!-- Transactions Table -->
        <div class="card">
            <h3 style="margin-bottom:16px;color:#2C3E50">Transaction History</h3>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Txn ID</th><th>Date</th><th>Description</th>
                        <th>Category</th><th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                <% if (transactions != null && !transactions.isEmpty()) {
                    for (BankTransaction t : transactions) {
                        boolean isCredit = t.getAmount().doubleValue() > 0;
                %>
                    <tr>
                        <td style="font-size:0.82rem;color:#999"><%= t.getTransactionId() %></td>
                        <td><%= t.getTransactionDate() %></td>
                        <td><%= t.getDescription() %></td>
                        <td><span class="badge"><%= t.getCategory() %></span></td>
                        <td class="amount <%= isCredit ? "credit" : "debit" %>">
                            <%= isCredit ? "+" : "" %>₹<%= t.getAmount() %>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="5" style="text-align:center;color:#999">No transactions yet. Upload a CSV.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </main>
</div>
</body>
</html>
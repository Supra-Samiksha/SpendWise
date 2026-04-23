<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Map<String,Object>> catTotals     = (List<Map<String,Object>>) request.getAttribute("categoryTotals");
    List<Map<String,Object>> bankTotals    = (List<Map<String,Object>>) request.getAttribute("bankCategoryTotals");
    List<Map<String,Object>> trend         = (List<Map<String,Object>>) request.getAttribute("monthlyTrend");
    int month = request.getAttribute("month") != null
        ? ((Number) request.getAttribute("month")).intValue() : 1;
    int year  = request.getAttribute("year") != null
        ? ((Number) request.getAttribute("year")).intValue() : 2024;
    String[] months = {"","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
%>
<!DOCTYPE html>
<html>
<head>
    <title>SpendWise – Reports</title>
    <link rel="stylesheet" href="css/dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <main class="main-content">
        <div class="page-header">
            <h1>Reports</h1>
            <form action="reports" method="get" style="display:flex;gap:8px;align-items:center">
                <select name="month" style="padding:8px;border-radius:6px;border:1px solid #ECEFF1">
                    <% for (int m = 1; m <= 12; m++) { %>
                        <option value="<%= m %>" <%= m==month?"selected":"" %>><%= months[m] %></option>
                    <% } %>
                </select>
                <input type="number" name="year" value="<%= year %>" style="width:80px;padding:8px;border-radius:6px;border:1px solid #ECEFF1"/>
                <button type="submit" class="btn-primary" style="padding:8px 16px">Filter</button>
            </form>
        </div>

        <div class="cards-row">
            <!-- Category breakdown: manual expenses -->
            <div class="card" style="flex:1">
                <h3 style="color:#2C3E50;margin-bottom:16px">Manual Expenses by Category</h3>
                <% if (catTotals != null && !catTotals.isEmpty()) { %>
                    <canvas id="expenseChart" height="220"></canvas>
                    <table class="data-table" style="margin-top:16px">
                        <thead><tr><th>Category</th><th>Amount</th><th>Txns</th></tr></thead>
                        <tbody>
                        <% for (Map<String,Object> r : catTotals) { %>
                            <tr>
                                <td><%= r.get("category") %></td>
                                <td class="amount">₹<%= r.get("total") %></td>
                                <td><%= r.get("txnCount") %></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <p style="color:#999;text-align:center;padding:32px">No expense data for this month.</p>
                <% } %>
            </div>

            <!-- Category breakdown: bank transactions -->
            <div class="card" style="flex:1">
                <h3 style="color:#2C3E50;margin-bottom:16px">Bank Transactions by Category</h3>
                <% if (bankTotals != null && !bankTotals.isEmpty()) { %>
                    <canvas id="bankChart" height="220"></canvas>
                <% } else { %>
                    <p style="color:#999;text-align:center;padding:32px">No bank data for this month.</p>
                <% } %>
            </div>
        </div>

        <!-- Monthly trend -->
        <div class="card" style="margin-top:24px">
            <h3 style="color:#2C3E50;margin-bottom:16px">Monthly Spending Trend</h3>
            <canvas id="trendChart" height="100"></canvas>
        </div>
    </main>
</div>

<script>
    const colors = ['#1ABC9C','#2C3E50','#E67E22','#9B59B6','#3498DB','#E74C3C','#2ECC71','#F39C12','#1ABC9C'];

    <% if (catTotals != null && !catTotals.isEmpty()) { %>
    new Chart(document.getElementById('expenseChart'), {
        type: 'doughnut',
        data: {
            labels: [<% for(int i=0;i<catTotals.size();i++){%>'<%=catTotals.get(i).get("category")%>'<%if(i<catTotals.size()-1)out.print(",");%><% } %>],
            datasets: [{ data: [<% for(int i=0;i<catTotals.size();i++){%><%=catTotals.get(i).get("total")%><%if(i<catTotals.size()-1)out.print(",");%><% } %>], backgroundColor: colors }]
        },
        options: { plugins: { legend: { position: 'bottom' } } }
    });
    <% } %>

    <% if (bankTotals != null && !bankTotals.isEmpty()) { %>
    new Chart(document.getElementById('bankChart'), {
        type: 'doughnut',
        data: {
            labels: [<% for(int i=0;i<bankTotals.size();i++){%>'<%=bankTotals.get(i).get("category")%>'<%if(i<bankTotals.size()-1)out.print(",");%><% } %>],
            datasets: [{ data: [<% for(int i=0;i<bankTotals.size();i++){%><%=bankTotals.get(i).get("total")%><%if(i<bankTotals.size()-1)out.print(",");%><% } %>], backgroundColor: colors }]
        },
        options: { plugins: { legend: { position: 'bottom' } } }
    });
    <% } %>

    <% if (trend != null && !trend.isEmpty()) { %>
    new Chart(document.getElementById('trendChart'), {
        type: 'bar',
        data: {
            labels: [<% for(int i=0;i<trend.size();i++){%>'<%=trend.get(i).get("label")%>'<%if(i<trend.size()-1)out.print(",");%><% } %>],
            datasets: [{
                label: 'Total Spent (₹)',
                data: [<% for(int i=0;i<trend.size();i++){%><%=trend.get(i).get("total")%><%if(i<trend.size()-1)out.print(",");%><% } %>],
                backgroundColor: '#1ABC9C',
                borderRadius: 6
            }]
        },
        options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
    });
    <% } %>
</script>
</body>
</html>
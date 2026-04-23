<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="
    com.spendwise.dao.BudgetDAO,
    com.spendwise.dao.ExpenseDAO,
    com.spendwise.dao.SubscriptionDAO,
    com.spendwise.dao.ReportDAO,
    com.spendwise.util.ScoreCalculator,
    java.math.BigDecimal,
    java.time.LocalDate,
    java.util.List,
    java.util.Map
" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); return;
    }

    int userId  = (int) session.getAttribute("userId");
    String name = (String) session.getAttribute("userName");

    LocalDate now  = LocalDate.now();
    int month      = now.getMonthValue();
    int year       = now.getYear();

    BudgetDAO      budgetDAO = new BudgetDAO();
    SubscriptionDAO subDAO   = new SubscriptionDAO();
    ReportDAO      repDAO    = new ReportDAO();

    BigDecimal budget    = budgetDAO.getBudget(userId, month, year);
    BigDecimal spent     = budgetDAO.getTotalSpent(userId, month, year);
    BigDecimal remaining = budget.subtract(spent);

    List<Map<String,Object>> catTotals = repDAO.getCategoryTotals(userId, month, year);
    int catCount  = catTotals.size();
    int subCount  = subDAO.getSavedSubscriptions(userId).size();

    int score      = ScoreCalculator.calculate(budget, spent, catCount, subCount);
    String grade   = ScoreCalculator.getGrade(score);
    String color   = ScoreCalculator.getColor(score);
    String tip     = ScoreCalculator.getTip(score);

    double percent = budget.doubleValue() > 0
        ? Math.min(100.0, (spent.doubleValue() / budget.doubleValue()) * 100.0)
        : 0.0;
    boolean overBudget = remaining.doubleValue() < 0;

    String dayName   = now.getDayOfWeek().toString();
    dayName = dayName.charAt(0) + dayName.substring(1).toLowerCase();
    String monthName = now.getMonth().toString();
    monthName = monthName.charAt(0) + monthName.substring(1).toLowerCase();
%>
<!DOCTYPE html>
<html>
<head>
    <title>SpendWise - Dashboard</title>
    <link rel="stylesheet" href="css/dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <main class="main-content">

        <!-- Page Header -->
        <div class="page-header">
            <h1>Welcome back, <%= name != null ? name.split(" ")[0] : "User" %>!</h1>
            <div class="header-date">
                <%= dayName %>, <%= now.getDayOfMonth() %> <%= monthName %> <%= year %>
            </div>
        </div>

        <!-- Stat Cards -->
        <div class="cards-row">
            <div class="stat-card">
                <div class="stat-label">Monthly Budget</div>
                <div class="stat-value">Rs.<%= String.format("%.0f", budget) %></div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Total Spent</div>
                <div class="stat-value" style="color:#E67E22">
                    Rs.<%= String.format("%.0f", spent) %>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Remaining</div>
                <div class="stat-value"
                     style="color:<%= overBudget ? "#E74C3C" : "#2ECC71" %>">
                    Rs.<%= String.format("%.0f", remaining) %>
                </div>
            </div>

            <div class="stat-card"
                 style="border-top:4px solid <%= color %>">
                <div class="stat-label">SpendWise Score</div>
                <div class="stat-value"
                     style="color:<%= color %>;font-size: 2.2rem">
                    <%= score %>
                </div>
                <div class="stat-sub"
                     style="color:<%= color %>;font-weight: 600">
                    <%= grade %>
                </div>
            </div>
        </div>

        <!-- Budget Progress -->
        <div class="card">
            <div style="display:flex;justify-content:space-between;margin-bottom:8px">
                <span style="font-weight:600;color:#2C3E50">Budget Usage</span>
                <span><%= Math.round(percent) %>%</span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill <%= overBudget ? "over" : "" %>"
                     style="width:<%= Math.min(percent, 100.0) %>%">
                </div>
            </div>
        </div>

        <!-- Score + Category Charts -->
        <div class="cards-row" style="margin-top:24px">

            <!-- SpendWise Score Card -->
            <div class="card" style="flex:1">
                <h3 style="color:#2C3E50;margin-bottom:4px">SpendWise Score</h3>
                <div style="text-align:center;padding:16px 0">
                    <div style="font-size:4rem;font-weight:700;color:<%= color %>">
                        <%= score %>
                    </div>
                    <div style="font-size:1.2rem;color:<%= color %>;font-weight:600;margin:4px 0">
                        <%= grade %>
                    </div>
                    <p style="color:#7f8c8d;font-size:0.9rem;max-width:240px;margin:auto">
                        <%= tip %>
                    </p>
                    <canvas id="scoreGauge" width="200" height="120"
                            style="margin:16px auto;display:block">
                    </canvas>
                </div>
            </div>

            <!-- This Month's Spending -->
            <div class="card" style="flex:1">
                <h3 style="color:#2C3E50;margin-bottom:16px">This Month's Spending</h3>
                <% if (!catTotals.isEmpty()) { %>
                    <canvas id="catChart" height="200"></canvas>
                <% } else { %>
                    <p style="color:#999;text-align:center;padding:32px">
                        Add expenses to see breakdown
                    </p>
                <% } %>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="card" style="margin-top:24px">
            <h3 style="color:#2C3E50;margin-bottom:16px">Quick Actions</h3>
            <div style="display:flex;gap:12px;flex-wrap:wrap">
                <a href="expenses"      class="quick-action-btn">+ Add Expense</a>
                <a href="banksync"      class="quick-action-btn secondary">Bank Sync</a>
                <a href="budget"        class="quick-action-btn secondary">Set Budget</a>
                <a href="reports"       class="quick-action-btn secondary">View Reports</a>
            </div>
        </div>

    </main>
</div>

<script>
// Score gauge arc
(function() {
    var canvas = document.getElementById('scoreGauge');
    if (!canvas) return;
    var ctx   = canvas.getContext('2d');
    var score = <%= score %>;
    var color = '<%= color %>';
    var cx = 100, cy = 100, r = 70;
    var start  = Math.PI;
    var filled = start + (score / 100) * Math.PI;

    ctx.beginPath();
    ctx.arc(cx, cy, r, start, 2 * Math.PI);
    ctx.strokeStyle = '#ECEFF1';
    ctx.lineWidth   = 14;
    ctx.lineCap     = 'round';
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(cx, cy, r, start, filled);
    ctx.strokeStyle = color;
    ctx.lineWidth   = 14;
    ctx.lineCap     = 'round';
    ctx.stroke();
})();

<% if (!catTotals.isEmpty()) {
    StringBuilder labels = new StringBuilder();
    StringBuilder data   = new StringBuilder();
    for (int i = 0; i < catTotals.size(); i++) {
        if (i > 0) { labels.append(","); data.append(","); }
        labels.append("'").append(catTotals.get(i).get("category")).append("'");
        data.append(catTotals.get(i).get("total"));
    }
%>
new Chart(document.getElementById('catChart'), {
    type: 'doughnut',
    data: {
        labels:   [ <%= labels %> ],
        datasets: [{
            data:            [ <%= data %> ],
            backgroundColor: ['#1ABC9C','#2C3E50','#E67E22',
                               '#9B59B6','#3498DB','#E74C3C',
                               '#2ECC71','#F39C12']
        }]
    },
    options: {
        plugins: { legend: { position: 'bottom' } },
        cutout: '65%'
    }
});
<% } %>
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>SpendWise – Login</title>
    <link rel="stylesheet" href="css/auth.css">
</head>
<body>
<div class="auth-container">
    <div class="auth-card">
        <div class="logo">💰 SpendWise</div>
        <h2>Welcome Back</h2>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert error"><%= error %></div>
        <% } %>
        <% String registered = request.getParameter("registered");
           if ("true".equals(registered)) { %>
            <div class="alert success">Account created! Please login.</div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="john@example.com" required />
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Your password" required />
            </div>
            <button type="submit" class="btn-primary">Login</button>
        </form>

        <p class="switch-link">New here? <a href="signup.jsp">Create Account</a></p>
    </div>
</div>
</body>
</html>
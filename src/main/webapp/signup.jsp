<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>SpendWise – Sign Up</title>
    <link rel="stylesheet" href="css/auth.css">
    <!-- Minimal styling so page is visible even without CSS -->
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .auth-card {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            width: 300px;
        }
        .logo {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .form-group {
            margin-bottom: 12px;
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 4px;
        }
        button {
            width: 100%;
            padding: 10px;
            background: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
    </style>
</head>

<body>

<div class="auth-card">
    <div class="logo">💰 SpendWise</div>
    <h2>Create Account</h2>

    <!-- DEBUG TEXT (remove later) -->
    <p style="color:green;">Signup Page Loaded</p>

    <!-- Safe error handling -->
    <%
        try {
            String error = (String) request.getAttribute("error");
            if (error != null) {
    %>
        <div class="error"><%= error %></div>
    <%
            }
        } catch (Exception e) {
            out.println("<div class='error'>Error displaying message</div>");
        }
    %>

    <form action="signup" method="post">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullName" placeholder="John Doe" required />
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="john@example.com" required />
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Min 6 characters" required minlength="6"/>
        </div>

        <button type="submit">Create Account</button>
    </form>

    <p>Already have an account? <a href="login.jsp">Login</a></p>
</div>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SpendWise</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: #FAFAFA;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .card {
            background: #fff;
            border-radius: 16px;
            padding: 48px 64px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            text-align: center;
        }
        h1 { color: #1ABC9C; font-size: 2.4rem; margin-bottom: 8px; }
        p  { color: #34495E; font-size: 1.1rem; }
        .btn {
            display: inline-block;
            margin-top: 24px;
            padding: 12px 32px;
            background: #1ABC9C;
            color: #fff;
            border-radius: 8px;
            text-decoration: none;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>💰 SpendWise</h1>
        <p>Your personal finance manager</p>
        <a class="btn" href="login.jsp">Get Started</a>
    </div>
</body>
</html>
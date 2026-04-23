# 💸 SpendWise

> A full-stack personal finance management web application built with Java Servlets, JSP, and PostgreSQL — inspired by Rocket Money.

SpendWise gives users complete visibility into their money: track manual expenses, sync bank statements via CSV, detect recurring subscriptions automatically, manage monthly budgets, and measure financial health with a real-time SpendWise Score.

---

## ✨ Features

- **Secure Authentication** — SHA-256 password hashing, session-based login, protected routes
- **Manual Expense Tracking** — Log cash and card expenses with categories and notes
- **Bank Statement Sync** — Upload CSV exports; duplicate transactions are automatically ignored
- **Subscription Detection** — Auto-detects recurring charges from bank history (2+ months = subscription)
- **Budget Management** — Set monthly budgets with a live progress bar and over-budget alerts
- **Reports & Analytics** — Doughnut and bar charts for spending by category and by month (Chart.js)
- **SpendWise Score** — A 0–100 financial health score based on budget adherence, savings rate, category diversity, and subscription count

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend Language | Java 17 (JDK) |
| Web Server | Apache Tomcat 10 |
| Database | PostgreSQL 16 |
| DB GUI | pgAdmin 4 |
| Connectivity | JDBC (PostgreSQL Driver 42.x) |
| Frontend | JSP, HTML5, CSS3, JavaScript |
| Charts | Chart.js |
| Build | Custom `build.bat` script + `javac` |
| Editor | VS Code |

---

## 📁 Project Structure

```
C:\SpendWise\
│
├── src\
│   └── main\
│       ├── java\
│       │   └── com\
│       │       └── spendwise\
│       │           ├── util\           ← DBConnection, ScoreCalculator
│       │           ├── model\          ← User, Expense, BankTransaction, Budget, Subscription
│       │           ├── dao\            ← UserDAO, ExpenseDAO, BankTransactionDAO, BudgetDAO, SubscriptionDAO, ReportDAO
│       │           └── servlet\        ← LoginServlet, SignupServlet, ExpenseServlet, BankSyncServlet, BudgetServlet, SubscriptionServlet, ReportServlet, ProfileServlet
│       └── webapp\
│           ├── WEB-INF\
│           │   └── web.xml
│           ├── css\
│           │   ├── auth.css
│           │   └── dashboard.css
│           └── *.jsp                   ← 13 JSP pages
├── lib\                                ← External JARs (PostgreSQL JDBC driver)
├── out\                                ← Compiled .class files (git-ignored)
├── sources.txt                         ← Source file list for javac
└── build.bat                           ← One-click build and deploy script
```

---

## 🗄 Database Schema

Five tables with full relational integrity:

```sql
users              — id, full_name, email (UNIQUE), password (SHA-256 hash), created_at
expenses           — id, user_id (FK), title, amount (DECIMAL), category, expense_date, notes
bank_transactions  — id, user_id (FK), transaction_id, description, amount, transaction_date, category
                     UNIQUE(user_id, transaction_id)  ← enables duplicate-safe CSV sync
subscriptions      — id, user_id (FK), name, amount, billing_cycle, next_due, is_active
budgets            — id, user_id (FK), month, year, total_budget
                     UNIQUE(user_id, month, year)  ← UPSERT support
```

All monetary values use `DECIMAL(10,2)` — never FLOAT. All user-linked tables use `ON DELETE CASCADE`.

---

## ⚙️ Setup & Installation

### Prerequisites

- Java JDK 17 ([Download](https://adoptium.net/))
- Apache Tomcat 10 ([Download](https://tomcat.apache.org/download-10.cgi))
- PostgreSQL 16 + pgAdmin 4 ([Download](https://www.postgresql.org/download/))
- PostgreSQL JDBC Driver JAR ([Download](https://jdbc.postgresql.org/download/))

---

### Step 1 — Database Setup

Open **pgAdmin 4**, connect to your local PostgreSQL server, open the Query Tool, and run the following:

```sql
CREATE DATABASE spendwise;

\c spendwise

CREATE TABLE users (
    id         SERIAL PRIMARY KEY,
    full_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(150) UNIQUE NOT NULL,
    password   VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE expenses (
    id           SERIAL PRIMARY KEY,
    user_id      INT REFERENCES users(id) ON DELETE CASCADE,
    title        VARCHAR(200) NOT NULL,
    amount       DECIMAL(10,2) NOT NULL,
    category     VARCHAR(100) NOT NULL,
    expense_date DATE NOT NULL,
    notes        TEXT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bank_transactions (
    id               SERIAL PRIMARY KEY,
    user_id          INT REFERENCES users(id) ON DELETE CASCADE,
    transaction_id   VARCHAR(100) NOT NULL,
    description      VARCHAR(300),
    amount           DECIMAL(10,2) NOT NULL,
    transaction_date DATE NOT NULL,
    category         VARCHAR(100) DEFAULT 'Uncategorized',
    UNIQUE(user_id, transaction_id)
);

CREATE TABLE subscriptions (
    id            SERIAL PRIMARY KEY,
    user_id       INT REFERENCES users(id) ON DELETE CASCADE,
    name          VARCHAR(200) NOT NULL,
    amount        DECIMAL(10,2) NOT NULL,
    billing_cycle VARCHAR(50) DEFAULT 'Monthly',
    next_due      DATE,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE budgets (
    id           SERIAL PRIMARY KEY,
    user_id      INT REFERENCES users(id) ON DELETE CASCADE,
    month        INT NOT NULL,
    year         INT NOT NULL,
    total_budget DECIMAL(10,2) NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, month, year)
);
```

---

### Step 2 — Configure Database Credentials

Open `src/main/java/com/spendwise/util/DBConnection.java` and update:

```java
private static final String URL      = "jdbc:postgresql://localhost:5432/spendwise";
private static final String USER     = "your_postgres_username";
private static final String PASSWORD = "your_postgres_password";
```

---

### Step 3 — Install JDBC Driver

Copy the PostgreSQL JDBC driver JAR (e.g. `postgresql-42.7.3.jar`) to:

```
C:\tomcat\lib\
```

---

### Step 4 — Configure Paths in build.bat

Open `build.bat` and verify the top lines match your installation:

```bat
set TOMCAT_HOME=C:\tomcat
set PROJECT_ROOT=C:\SpendWise
```

---

### Step 5 — Build and Deploy

```bat
cd C:\SpendWise
build.bat
```

The script will:
1. Clean the `out\` directory
2. Compile all 19 Java source files with `javac`
3. Copy `.class` files to `WEB-INF\classes\`
4. Copy all JSP, CSS, and static files to the Tomcat webapps folder
5. Start Tomcat automatically

---

### Step 6 — Open the App

```
http://localhost:8080/SpendWise/signup.jsp
```

---

## 📄 Sample CSV Format

For the Bank Sync feature, your CSV file must follow this format:

```csv
transaction_id,date,description,amount,category
TXN001,2024-01-05,Netflix Subscription,-499.00,Entertainment
TXN002,2024-01-10,Salary Credit,50000.00,Income
TXN003,2024-01-15,Swiggy Food Order,-350.00,Food
```

- Dates must be in `YYYY-MM-DD` format
- Negative amounts = debits (spending)
- Positive amounts = credits (income/refunds)
- Re-uploading the same file is safe — duplicates are silently skipped

---

## 🔐 Security Notes

- Passwords are **SHA-256 hashed** before storage — plaintext is never saved
- Sessions use Tomcat's built-in `JSESSIONID` cookie mechanism; session data stays server-side
- All SQL uses **PreparedStatements** with `?` placeholders — SQL injection is not possible
- Every data mutation (delete, update) checks `user_id` in the WHERE clause — users cannot access other users' data

---

## 📊 SpendWise Score Breakdown

| Factor | Weight | Best Case |
|--------|--------|-----------|
| Budget Adherence | 40 pts | Spent < 50% of budget |
| Savings Rate | 30 pts | Saved 50%+ of budget |
| Category Diversity | 15 pts | 5+ expense categories tracked |
| Subscription Count | 15 pts | 0 active subscriptions |
| **Total** | **100 pts** | |

Score ranges: 85–100 Excellent · 70–84 Good · 50–69 Fair · Below 50 Needs Work

---

## 🏗 Architecture Pattern

SpendWise follows the classic **MVC + DAO Layered Architecture**:

```
Browser (JSP/HTML/CSS/JS)
    ↕ HTTP
Servlet Layer  ← handles requests, reads params, writes responses
    ↕ Java objects
DAO Layer      ← ONLY layer that touches the database
    ↕ JDBC / SQL
PostgreSQL     ← stores all persistent data
```

This separation means database changes are isolated to DAOs, and HTTP handling is isolated to Servlets. Neither layer bleeds into the other.

---

## 🙏 Acknowledgements

Inspired by [Rocket Money](https://www.rocketmoney.com/) (formerly Truebill) — a real-world personal finance app that connects to bank accounts, detects subscriptions, and helps users take control of their spending.

---


Built as a college project by Supra Samiksha.

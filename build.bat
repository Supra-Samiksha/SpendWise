@echo off
echo ========================================
echo   SpendWise Build and Deploy Script
echo ========================================

set TOMCAT_HOME=C:\tomcat
set PROJECT_ROOT=C:\SpendWise
set DEPLOY_DIR=%TOMCAT_HOME%\webapps\SpendWise
set SRC=%PROJECT_ROOT%\src\main\java

echo [1/5] Cleaning old build...
if exist "%PROJECT_ROOT%\out" rmdir /s /q "%PROJECT_ROOT%\out"
mkdir "%PROJECT_ROOT%\out"

echo [2/5] Writing sources list...
echo %SRC%\com\spendwise\util\DBConnection.java > "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\util\ScoreCalculator.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\model\User.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\model\Expense.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\model\BankTransaction.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\dao\UserDAO.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\dao\ExpenseDAO.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\dao\BankTransactionDAO.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\dao\BudgetDAO.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\dao\SubscriptionDAO.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\dao\ReportDAO.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\servlet\SignupServlet.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\servlet\LoginServlet.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\servlet\LogoutServlet.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\servlet\ExpenseServlet.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\servlet\BankSyncServlet.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\servlet\SubscriptionServlet.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\servlet\BudgetServlet.java >> "%PROJECT_ROOT%\sources.txt"
echo %SRC%\com\spendwise\servlet\ReportServlet.java >> "%PROJECT_ROOT%\sources.txt"

echo [3/5] Compiling...
javac -cp "%TOMCAT_HOME%\lib\*;%PROJECT_ROOT%\lib\*" -d "%PROJECT_ROOT%\out" @"%PROJECT_ROOT%\sources.txt"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo *** COMPILE FAILED. See errors above. ***
    pause
    exit /b 1
)
echo    Compile OK!

echo [4/5] Stopping Tomcat...
call "%TOMCAT_HOME%\bin\shutdown.bat" 2>nul
timeout /t 4 /nobreak >nul

echo [5/5] Deploying...
mkdir "%DEPLOY_DIR%\WEB-INF\classes" 2>nul
mkdir "%DEPLOY_DIR%\css" 2>nul
mkdir "%DEPLOY_DIR%\js"  2>nul

xcopy /s /y "%PROJECT_ROOT%\out\*"                          "%DEPLOY_DIR%\WEB-INF\classes\"
copy  /y    "%PROJECT_ROOT%\src\main\webapp\*.jsp"          "%DEPLOY_DIR%\"
copy  /y    "%PROJECT_ROOT%\src\main\webapp\WEB-INF\web.xml" "%DEPLOY_DIR%\WEB-INF\"
copy  /y    "%PROJECT_ROOT%\src\main\webapp\css\*"          "%DEPLOY_DIR%\css\"
copy  /y    "%PROJECT_ROOT%\lib\postgresql-*.jar"           "%TOMCAT_HOME%\lib\" 2>nul

echo    Deploy OK!

echo Starting Tomcat...
start "" "%TOMCAT_HOME%\bin\startup.bat"
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo  DONE! Visit: http://localhost:8080/SpendWise/
echo ========================================
pause
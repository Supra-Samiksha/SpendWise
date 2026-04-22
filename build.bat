@echo off
echo ========================================
echo   SpendWise Build and Deploy Script
echo ========================================

:: === PATH CONFIGURATION ===
set TOMCAT_HOME=C:\Tomcat\apachetomcat
set PROJECT_ROOT=C:\SpendWise
set DEPLOY_DIR=%TOMCAT_HOME%\webapps\SpendWise
set SRC=%PROJECT_ROOT%\src\main\java

echo [1/6] Cleaning old build and deployment...
if exist "%PROJECT_ROOT%\out" rmdir /s /q "%PROJECT_ROOT%\out"
mkdir "%PROJECT_ROOT%\out"

:: FIX 1: Also wipe the old deployed folder so stale files don't linger
if exist "%DEPLOY_DIR%" rmdir /s /q "%DEPLOY_DIR%"
mkdir "%DEPLOY_DIR%"
mkdir "%DEPLOY_DIR%\WEB-INF\classes"
mkdir "%DEPLOY_DIR%\WEB-INF\lib"
mkdir "%DEPLOY_DIR%\css"
mkdir "%DEPLOY_DIR%\js"

echo [2/6] Writing sources list...
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

echo [3/6] Compiling...
javac -cp "%TOMCAT_HOME%\lib\*;%PROJECT_ROOT%\lib\*" -d "%PROJECT_ROOT%\out" @"%PROJECT_ROOT%\sources.txt"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo *** COMPILE FAILED. See errors above. ***
    pause
    exit /b 1
)
echo    Compile OK!

echo [4/6] Stopping Tomcat...
call "%TOMCAT_HOME%\bin\shutdown.bat" 2>nul
timeout /t 5 /nobreak >nul

echo [5/6] Deploying...

:: Deploy compiled classes
xcopy /s /e /y "%PROJECT_ROOT%\out\*" "%DEPLOY_DIR%\WEB-INF\classes\"

:: FIX 2: Copy ALL JSPs recursively (original used copy which misses subfolders)
xcopy /s /e /y "%PROJECT_ROOT%\src\main\webapp\*.jsp" "%DEPLOY_DIR%\"

:: Deploy web.xml
copy /y "%PROJECT_ROOT%\src\main\webapp\WEB-INF\web.xml" "%DEPLOY_DIR%\WEB-INF\"

:: Deploy CSS and JS
xcopy /s /e /y "%PROJECT_ROOT%\src\main\webapp\css\*" "%DEPLOY_DIR%\css\"

:: FIX 3: Deploy JS folder (was completely missing in original build.bat)
if exist "%PROJECT_ROOT%\src\main\webapp\js\*" (
    xcopy /s /e /y "%PROJECT_ROOT%\src\main\webapp\js\*" "%DEPLOY_DIR%\js\"
)

:: FIX 4: Copy JAR dependencies into WEB-INF/lib (not just Tomcat/lib)
:: This ensures your app's own libs (e.g. PostgreSQL driver) are bundled correctly
xcopy /s /e /y "%PROJECT_ROOT%\lib\*.jar" "%DEPLOY_DIR%\WEB-INF\lib\"

:: Also keep PostgreSQL in Tomcat lib for connection pooling if needed
copy /y "%PROJECT_ROOT%\lib\postgresql-*.jar" "%TOMCAT_HOME%\lib\" 2>nul

echo    Deploy OK!

echo [6/6] Starting Tomcat...
start "" "%TOMCAT_HOME%\bin\startup.bat"
timeout /t 6 /nobreak >nul

echo.
echo ========================================
echo  DONE! Visit: http://localhost:8080/SpendWise/
echo ========================================
pause
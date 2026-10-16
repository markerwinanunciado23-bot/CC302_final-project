@echo off
setlocal
cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is required. Install Node.js 22.13 or later, then try again.
  pause
  exit /b 1
)

node -e "const [major, minor] = process.versions.node.split('.').map(Number); if (major < 22 || major === 22 && minor < 13) process.exit(1); try { require('node:sqlite'); } catch { process.exit(1); }"
if errorlevel 1 (
  echo Blue Way requires Node.js 22.13 or later with the built-in SQLite module.
  pause
  exit /b 1
)

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter is not on PATH. Install Flutter and reopen this terminal.
  pause
  exit /b 1
)

curl.exe --silent --fail http://localhost:3000/api/health >nul 2>nul
if errorlevel 1 (
  echo Starting the Blue Way API in a separate terminal...
  start "Blue Way API" /D "%~dp0api" node server.js
)

echo Waiting for the Blue Way API...
for /L %%i in (1,1,30) do (
  curl.exe --silent --fail http://localhost:3000/api/health >nul 2>nul
  if not errorlevel 1 goto api_ready
  timeout /t 1 /nobreak >nul
)

echo The API did not start. Check whether port 3000 is available and Node.js is version 22.13 or later.
pause
exit /b 1

:api_ready
echo Installing Flutter packages...
call flutter pub get
if errorlevel 1 (
  pause
  exit /b 1
)

echo Starting Blue Way...
call flutter run %*
endlocal

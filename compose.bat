@echo off
title Docker Compose Starter
color 0A
cls

set NETWORK_NAME=shared-network

echo =============================================
echo     Starting Docker Compose Environments
echo =============================================

REM Check if the network already exists
docker network ls --format "{{.Name}}" | findstr /C:"%NETWORK_NAME%" >nul
if ERRORLEVEL 1 (
    echo Creating Docker network: %NETWORK_NAME%
    docker network create %NETWORK_NAME%
) else (
    echo Docker network %NETWORK_NAME% already exists.
    echo Skipping network creation.
)

cd docker-elk
docker compose up setup

cd ..

echo.
echo [1/2] Starting Docker stack from docker-elk...
echo --------------------------------------------
docker compose -f docker-elk\docker-compose.yml up -d
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to start docker/compose
    pause
    exit /b
)

echo.
echo [2/2] Starting Frappe stack from frappe_docker...
echo --------------------------------------------
docker compose -f frappe_docker\pwd.yml up -d
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to start frappe/compose
    pause
    exit /b
)

echo.
echo =============================================
echo     All docker-compose stacks are running!
echo =============================================
pause

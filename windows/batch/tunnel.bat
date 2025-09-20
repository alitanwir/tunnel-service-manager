@echo off
setlocal enabledelayedexpansion

:: Tunnel Service Script - ngrok and pinggy.io
:: Author: Ali Tanwir
:: Description: Interactive script to expose localhost using ngrok or pinggy.io

title Tunnel Service Manager

echo.
echo ========================================
echo     Tunnel Service Manager
echo ========================================
echo.

:: Check if required tools are installed
echo [INFO] Checking for required tools...

:: Check for ngrok
where ngrok >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] ngrok is not installed or not in PATH
    echo [INFO] Please install ngrok from https://ngrok.com/download
    pause
    exit /b 1
) else (
    echo [OK] ngrok found
)

:: Check for ssh (needed for pinggy)
where ssh >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] SSH client is not installed or not in PATH
    echo [INFO] Please install OpenSSH client or use Windows 10/11 built-in version
    echo [INFO] You can install it via: Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    pause
    exit /b 1
) else (
    echo [OK] SSH client found
)

echo.

:: Service Selection Menu
:MENU
echo Select tunneling service:
echo 1. ngrok (ngrok.com)
echo 2. pinggy.io
echo 3. Exit
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto NGROK_SETUP
if "%choice%"=="2" goto PINGGY_SETUP
if "%choice%"=="3" goto EXIT
echo [ERROR] Invalid choice. Please try again.
echo.
goto MENU

:: ngrok Setup and Configuration
:NGROK_SETUP
echo.
echo === NGROK CONFIGURATION ===

:: Check if ngrok is already authenticated
echo [INFO] Checking ngrok authentication...

:: First check if ngrok config file exists and has authtoken
set "ngrok_config_found=false"
if exist "%USERPROFILE%\AppData\Local\ngrok\ngrok.yml" (
    echo [INFO] Found ngrok config file, checking for authtoken...
    findstr /C:"authtoken:" "%USERPROFILE%\AppData\Local\ngrok\ngrok.yml" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Found authtoken in ngrok config file
        set "ngrok_config_found=true"
    )
)

:: Check if ngrok is authenticated via config check
ngrok config check >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] ngrok is already authenticated
    goto NGROK_TUNNEL_TYPE
) else (
    echo [INFO] ngrok is not authenticated
    
    :: If config file has authtoken but ngrok check failed, try to use it
    if "%ngrok_config_found%"=="true" (
        echo [INFO] Attempting to use authtoken from config file...
        for /f "tokens=2 delims=: " %%a in ('findstr /C:"authtoken:" "%USERPROFILE%\AppData\Local\ngrok\ngrok.yml"') do (
            set "config_token=%%a"
            set "config_token=!config_token: =!"
        )
        if defined config_token (
            ngrok config add-authtoken !config_token!
            if %errorlevel% equ 0 (
                echo [OK] ngrok authenticated using config file token
                goto NGROK_TUNNEL_TYPE
            )
        )
    )
    
    :: Check for NGROK_AUTHTOKEN environment variable
    if defined NGROK_AUTHTOKEN (
        echo [OK] Found NGROK_AUTHTOKEN environment variable
        echo [INFO] Authenticating ngrok...
        ngrok config add-authtoken %NGROK_AUTHTOKEN%
        if %errorlevel% equ 0 (
            echo [OK] ngrok authenticated successfully
        ) else (
            echo [ERROR] Failed to authenticate ngrok with provided token
            pause
            goto MENU
        )
    ) else (
        echo [WARNING] No ngrok authtoken found
        echo Please set your ngrok authtoken using one of these methods:
        echo   1. Set environment variable: set NGROK_AUTHTOKEN=your_token_here
        echo   2. Add to config file: %USERPROFILE%\AppData\Local\ngrok\ngrok.yml
        echo   3. Run manually: ngrok config add-authtoken YOUR_TOKEN
        echo.
        pause
        goto MENU
    )
)

:NGROK_TUNNEL_TYPE
echo.
echo Select tunnel type for ngrok:
echo 1. HTTP/HTTPS (web traffic)
echo 2. TCP (raw TCP traffic)
echo.
set /p ngrok_type="Enter your choice (1-2): "

if "%ngrok_type%"=="1" goto NGROK_HTTP
if "%ngrok_type%"=="2" goto NGROK_TCP
echo [ERROR] Invalid choice. Please try again.
goto NGROK_TUNNEL_TYPE

:NGROK_HTTP
echo.
set /p port="Enter local port to tunnel (default: 80): "
if "%port%"=="" set port=80

:: Check for custom domain
set "ngrok_cmd=ngrok http %port%"
if defined NGROK_CUSTOM_DOMAIN (
    echo [INFO] Using custom domain: %NGROK_CUSTOM_DOMAIN%
    set "ngrok_cmd=ngrok http --hostname=%NGROK_CUSTOM_DOMAIN% %port%"
)

echo [INFO] Starting ngrok HTTP tunnel on port %port%...
echo [INFO] Press Ctrl+C to stop the tunnel
echo.
%ngrok_cmd%
goto MENU

:NGROK_TCP
echo.
set /p port="Enter local port to tunnel: "
if "%port%"=="" (
    echo [ERROR] Port is required for TCP tunnel
    goto NGROK_TCP
)

:: Check for custom domain (TCP tunnels also support custom domains)
set "ngrok_cmd=ngrok tcp %port%"
if defined NGROK_CUSTOM_DOMAIN (
    echo [INFO] Using custom domain: %NGROK_CUSTOM_DOMAIN%
    set "ngrok_cmd=ngrok tcp --hostname=%NGROK_CUSTOM_DOMAIN% %port%"
)

echo [INFO] Starting ngrok TCP tunnel on port %port%...
echo [INFO] Press Ctrl+C to stop the tunnel
echo.
%ngrok_cmd%
goto MENU

:: pinggy.io Setup and Configuration
:PINGGY_SETUP
echo.
echo === PINGGY.IO CONFIGURATION ===

:: Check for PINGGY_TOKEN environment variable
if defined PINGGY_TOKEN (
    echo [OK] Found PINGGY_TOKEN environment variable
    set "pinggy_user=%PINGGY_TOKEN%"
) else (
    echo [WARNING] PINGGY_TOKEN environment variable not found
    echo [INFO] Using anonymous access (limited features)
    set "pinggy_user=a"
)

echo.
echo Select tunnel type for pinggy.io:
echo 1. HTTP/HTTPS (web traffic)
echo 2. TCP (raw TCP traffic)
echo.
set /p pinggy_type="Enter your choice (1-2): "

if "%pinggy_type%"=="1" goto PINGGY_HTTP
if "%pinggy_type%"=="2" goto PINGGY_TCP
echo [ERROR] Invalid choice. Please try again.
goto PINGGY_TUNNEL_TYPE

:PINGGY_HTTP
echo.
set /p port="Enter local port to tunnel (default: 80): "
if "%port%"=="" set port=80
echo [INFO] Starting pinggy.io HTTP tunnel on port %port%...
echo [INFO] Press Ctrl+C to stop the tunnel
echo.
ssh -p 443 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R0:localhost:%port% %pinggy_user%+force@free.pinggy.io
goto MENU

:PINGGY_TCP
echo.
set /p port="Enter local port to tunnel: "
if "%port%"=="" (
    echo [ERROR] Port is required for TCP tunnel
    goto PINGGY_TCP
)
echo [INFO] Starting pinggy.io TCP tunnel on port %port%...
echo [INFO] Press Ctrl+C to stop the tunnel
echo.
ssh -p 443 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R0:localhost:%port% %pinggy_user%+force+tcp@free.pinggy.io
goto MENU

:EXIT
echo.
echo [SUCCESS] Thank you for using Tunnel Service Manager!
echo [INFO] Remember to set your environment variables:
echo   NGROK_AUTHTOKEN=your_ngrok_token
echo   NGROK_CUSTOM_DOMAIN=your_custom_domain.ngrok.io
echo   PINGGY_TOKEN=your_pinggy_token
echo.
pause
exit /b 0


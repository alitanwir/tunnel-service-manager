#!/bin/bash

# Tunnel Service Script - ngrok and pinggy.io
# Author: Ali Tanwir
# Description: Interactive shell script to expose localhost using ngrok or pinggy.io
# Compatible with macOS and Linux

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Color functions for better output
write_info() {
    echo -e "${CYAN}[INFO] $1${NC}"
}

write_success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

write_warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

write_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

write_ok() {
    echo -e "${GREEN}[OK] $1${NC}"
}

# Service Selection Menu
show_menu() {
    echo -e "${WHITE}Select tunneling service:${NC}"
    echo -e "${WHITE}1. ngrok (ngrok.com)${NC}"
    echo -e "${WHITE}2. pinggy.io${NC}"
    echo -e "${WHITE}3. Exit${NC}"
    echo ""
}

# ngrok Setup and Configuration
start_ngrok_setup() {
    echo ""
    echo -e "${MAGENTA}=== NGROK CONFIGURATION ===${NC}"
    
    write_info "Checking ngrok authentication..."
    
    # Check if ngrok config file exists and has authtoken
    ngrok_config_path="$HOME/.config/ngrok/ngrok.yml"
    ngrok_config_found=false
    
    if [ -f "$ngrok_config_path" ]; then
        write_info "Found ngrok config file, checking for authtoken..."
        if grep -q "authtoken:" "$ngrok_config_path"; then
            write_ok "Found authtoken in ngrok config file"
            ngrok_config_found=true
        fi
    fi
    
    # Check if ngrok is authenticated via config check
    if ngrok config check >/dev/null 2>&1; then
        write_ok "ngrok is already authenticated"
        show_ngrok_tunnel_type
        return
    else
        write_info "ngrok is not authenticated"
        
        # If config file has authtoken but ngrok check failed, try to use it
        if [ "$ngrok_config_found" = true ]; then
            write_info "Attempting to use authtoken from config file..."
            config_token=$(grep "authtoken:" "$ngrok_config_path" | cut -d':' -f2 | tr -d ' ')
            if [ -n "$config_token" ]; then
                if ngrok config add-authtoken "$config_token" >/dev/null 2>&1; then
                    write_ok "ngrok authenticated using config file token"
                    show_ngrok_tunnel_type
                    return
                else
                    write_warning "Failed to use config file token"
                fi
            fi
        fi
        
        # Check for NGROK_AUTHTOKEN environment variable
        if [ -n "$NGROK_AUTHTOKEN" ]; then
            write_ok "Found NGROK_AUTHTOKEN environment variable"
            write_info "Authenticating ngrok..."
            if ngrok config add-authtoken "$NGROK_AUTHTOKEN" >/dev/null 2>&1; then
                write_ok "ngrok authenticated successfully"
                show_ngrok_tunnel_type
                return
            else
                write_error "Failed to authenticate ngrok with provided token"
                read -p "Press Enter to continue..."
                return
            fi
        else
            write_warning "No ngrok authtoken found"
            echo -e "${WHITE}Please set your ngrok authtoken using one of these methods:${NC}"
            echo -e "${WHITE}  1. Set environment variable: export NGROK_AUTHTOKEN='your_token_here'${NC}"
            echo -e "${WHITE}  2. Add to config file: $ngrok_config_path${NC}"
            echo -e "${WHITE}  3. Run manually: ngrok config add-authtoken YOUR_TOKEN${NC}"
            echo ""
            read -p "Press Enter to continue..."
            return
        fi
    fi
}

show_ngrok_tunnel_type() {
    echo ""
    echo -e "${WHITE}Select tunnel type for ngrok:${NC}"
    echo -e "${WHITE}1. HTTP/HTTPS (web traffic)${NC}"
    echo -e "${WHITE}2. TCP (raw TCP traffic)${NC}"
    echo ""
    
    while true; do
        read -p "Enter your choice (1-2): " ngrok_type
        case $ngrok_type in
            1)
                start_ngrok_http
                break
                ;;
            2)
                start_ngrok_tcp
                break
                ;;
            *)
                write_error "Invalid choice. Please try again."
                ;;
        esac
    done
}

start_ngrok_http() {
    echo ""
    read -p "Enter local port to tunnel (default: 80): " port
    if [ -z "$port" ]; then
        port="80"
    fi
    
    # Check for custom domain
    ngrok_cmd="ngrok http $port"
    if [ -n "$NGROK_CUSTOM_DOMAIN" ]; then
        write_info "Using custom domain: $NGROK_CUSTOM_DOMAIN"
        ngrok_cmd="ngrok http --hostname=$NGROK_CUSTOM_DOMAIN $port"
    fi
    
    write_info "Starting ngrok HTTP tunnel on port $port..."
    write_info "Press Ctrl+C to stop the tunnel"
    echo ""
    
    eval "$ngrok_cmd"
}

start_ngrok_tcp() {
    echo ""
    while true; do
        read -p "Enter local port to tunnel: " port
        if [ -n "$port" ]; then
            break
        else
            write_error "Port is required for TCP tunnel"
        fi
    done
    
    # Note: Custom domains are not supported for TCP tunnels in ngrok
    ngrok_cmd="ngrok tcp $port"
    if [ -n "$NGROK_CUSTOM_DOMAIN" ]; then
        write_warning "Custom domains are not supported for TCP tunnels in ngrok"
        write_info "Using default TCP tunnel (custom domain ignored)"
    fi
    
    write_info "Starting ngrok TCP tunnel on port $port..."
    write_info "Press Ctrl+C to stop the tunnel"
    echo ""
    
    eval "$ngrok_cmd"
}

# pinggy.io Setup and Configuration
start_pinggy_setup() {
    echo ""
    echo -e "${MAGENTA}=== PINGGY.IO CONFIGURATION ===${NC}"
    
    # Check for PINGGY_TOKEN environment variable
    if [ -n "$PINGGY_TOKEN" ]; then
        write_ok "Found PINGGY_TOKEN environment variable"
        pinggy_user="$PINGGY_TOKEN"
    else
        write_warning "PINGGY_TOKEN environment variable not found"
        write_info "Using anonymous access (limited features)"
        pinggy_user="a"
    fi
    
    echo ""
    echo -e "${WHITE}Select tunnel type for pinggy.io:${NC}"
    echo -e "${WHITE}1. HTTP/HTTPS (web traffic)${NC}"
    echo -e "${WHITE}2. TCP (raw TCP traffic)${NC}"
    echo ""
    
    while true; do
        read -p "Enter your choice (1-2): " pinggy_type
        case $pinggy_type in
            1)
                start_pinggy_http "$pinggy_user"
                break
                ;;
            2)
                start_pinggy_tcp "$pinggy_user"
                break
                ;;
            *)
                write_error "Invalid choice. Please try again."
                ;;
        esac
    done
}

start_pinggy_http() {
    local user="$1"
    
    echo ""
    read -p "Enter local port to tunnel (default: 80): " port
    if [ -z "$port" ]; then
        port="80"
    fi
    
    write_info "Starting pinggy.io HTTP tunnel on port $port..."
    write_info "Press Ctrl+C to stop the tunnel"
    echo ""
    
    ssh -p 443 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R0:localhost:$port "$user+force@free.pinggy.io"
}

start_pinggy_tcp() {
    local user="$1"
    
    echo ""
    while true; do
        read -p "Enter local port to tunnel: " port
        if [ -n "$port" ]; then
            break
        else
            write_error "Port is required for TCP tunnel"
        fi
    done
    
    write_info "Starting pinggy.io TCP tunnel on port $port..."
    write_info "Press Ctrl+C to stop the tunnel"
    echo ""
    
    ssh -p 443 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R0:localhost:$port "$user+force+tcp@free.pinggy.io"
}

show_exit_message() {
    echo ""
    write_success "Thank you for using Tunnel Service Manager!"
    write_info "Remember to set your environment variables:"
    echo -e "${WHITE}  NGROK_AUTHTOKEN=your_ngrok_token${NC}"
    echo -e "${WHITE}  NGROK_CUSTOM_DOMAIN=your_custom_domain.ngrok.io${NC}"
    echo -e "${WHITE}  PINGGY_TOKEN=your_pinggy_token${NC}"
    echo ""
    read -p "Press Enter to exit..."
}

# Main header
echo ""
echo -e "${MAGENTA}========================================${NC}"
echo -e "${MAGENTA}     Tunnel Service Manager${NC}"
echo -e "${MAGENTA}========================================${NC}"
echo ""

# Check if required tools are installed
write_info "Checking for required tools..."

# Check for ngrok
if command -v ngrok >/dev/null 2>&1; then
    write_ok "ngrok found"
else
    write_error "ngrok is not installed or not in PATH"
    write_info "Please install ngrok from https://ngrok.com/download"
    read -p "Press Enter to exit..."
    exit 1
fi

# Check for ssh (needed for pinggy)
if command -v ssh >/dev/null 2>&1; then
    write_ok "SSH client found"
else
    write_error "SSH client is not installed or not in PATH"
    write_info "Please install OpenSSH client"
    write_info "On macOS: brew install openssh"
    write_info "On Ubuntu/Debian: sudo apt-get install openssh-client"
    write_info "On CentOS/RHEL: sudo yum install openssh-clients"
    read -p "Press Enter to exit..."
    exit 1
fi

echo ""

# Main menu loop
while true; do
    show_menu
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            start_ngrok_setup
            ;;
        2)
            start_pinggy_setup
            ;;
        3)
            show_exit_message
            exit 0
            ;;
        *)
            write_error "Invalid choice. Please try again."
            echo ""
            ;;
    esac
done

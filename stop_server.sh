#!/bin/bash

# stop_server.sh
# Stops the Hello Server

PROJECT_DIR="/home/carlos/Project03"
SERVER_PID_FILE="${PROJECT_DIR}/server.pid"

if [ -f "${SERVER_PID_FILE}" ]; then
    PID=$(cat "${SERVER_PID_FILE}")
    if kill -0 ${PID} 2>/dev/null; then
        echo "Stopping Server (PID: ${PID})..."
        kill ${PID}
        sleep 2
        
        # Force kill if still running
        if kill -0 ${PID} 2>/dev/null; then
            echo "Force stopping Server..."
            kill -9 ${PID}
        fi
        
        rm -f "${SERVER_PID_FILE}"
        echo "Server stopped"
    else
        echo "Server not running (stale PID file)"
        rm -f "${SERVER_PID_FILE}"
    fi
else
    echo "Server PID file not found"
fi

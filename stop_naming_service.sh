#!/bin/bash

# stop_naming_service.sh
# Stops the TAO Naming Service

NAMING_SERVICE_DIR="/home/carlos/ACE_wrappers/TAO/orbsvcs/Naming_Service"
PID_FILE="${NAMING_SERVICE_DIR}/naming_service.pid"

if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}")
    if kill -0 ${PID} 2>/dev/null; then
        echo "Stopping Naming Service (PID: ${PID})..."
        kill ${PID}
        sleep 2
        
        # Force kill if still running
        if kill -0 ${PID} 2>/dev/null; then
            echo "Force stopping Naming Service..."
            kill -9 ${PID}
        fi
        
        rm -f "${PID_FILE}"
        echo "Naming Service stopped"
    else
        echo "Naming Service not running (stale PID file)"
        rm -f "${PID_FILE}"
    fi
else
    echo "Naming Service PID file not found"
fi

# Clean up IOR file
rm -f "${NAMING_SERVICE_DIR}/naming.ior"

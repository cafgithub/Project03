#!/bin/bash

# status.sh
# Shows status of all services

NAMING_SERVICE_DIR="/home/carlos/ACE_wrappers/TAO/orbsvcs/Naming_Service"
PROJECT_DIR="/home/carlos/Project03"

echo "=== Service Status ==="
echo ""

# Check Naming Service
PID_FILE="${NAMING_SERVICE_DIR}/naming_service.pid"
if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}")
    if kill -0 ${PID} 2>/dev/null; then
        echo "✓ Naming Service: RUNNING (PID: ${PID})"
    else
        echo "✗ Naming Service: NOT RUNNING (stale PID file)"
    fi
else
    echo "✗ Naming Service: NOT RUNNING"
fi

# Check Server
PID_FILE="${PROJECT_DIR}/server.pid"
if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}")
    if kill -0 ${PID} 2>/dev/null; then
        echo "✓ Hello Server: RUNNING (PID: ${PID})"
    else
        echo "✗ Hello Server: NOT RUNNING (stale PID file)"
    fi
else
    echo "✗ Hello Server: NOT RUNNING"
fi

# Check Client
PID_FILE="${PROJECT_DIR}/client.pid"
if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}")
    if kill -0 ${PID} 2>/dev/null; then
        echo "✓ Hello Client: RUNNING (PID: ${PID})"
    else
        echo "✗ Hello Client: NOT RUNNING (stale PID file)"
    fi
else
    echo "✗ Hello Client: NOT RUNNING"
fi

echo ""
echo "=== File Locations ==="
echo "Naming Service IOR: ${NAMING_SERVICE_DIR}/naming.ior"
echo "Server Log: ${PROJECT_DIR}/server.log"
echo "Client Log: ${PROJECT_DIR}/client.log"

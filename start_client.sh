#!/bin/bash
# start_client.sh

PROJECT_DIR="/home/carlos/Project03"
NAMING_SERVICE_DIR="/home/carlos/ACE_wrappers/TAO/orbsvcs/Naming_Service"
IOR_FILE="${NAMING_SERVICE_DIR}/naming.ior"
CLIENT_PID_FILE="${PROJECT_DIR}/client.pid"
LOG_FILE="${PROJECT_DIR}/client.log"
MY_IP="192.168.1.91"

# Check if naming service is running
if [ ! -f "${IOR_FILE}" ]; then
    echo "Error: Naming Service not running or IOR file not found"
    echo "Please start naming service first: ./start_naming_service.sh"
    exit 1
fi

cd "${PROJECT_DIR}"

# Check if client executable exists
if [ ! -f "./client" ]; then
    echo "Client executable not found. Building..."
    make client
fi

# Display IOR being used
echo "Using Naming Service at ${MY_IP}:12345"
echo "IOR file: ${IOR_FILE}"
echo ""

# Start client (foreground by default, or background with -b flag)
if [ "$1" = "-b" ]; then
    echo "Starting Hello Client in background..."
    ./client -n "${IOR_FILE}" \
             -ORBInitRef NameService=file://"${IOR_FILE}" \
             > "${LOG_FILE}" 2>&1 &
    CLIENT_PID=$!
    echo ${CLIENT_PID} > "${CLIENT_PID_FILE}"
    sleep 1
    
    if kill -0 ${CLIENT_PID} 2>/dev/null; then
        echo "Client started successfully"
        echo "  PID: ${CLIENT_PID}"
        echo "  Log file: ${LOG_FILE}"
    else
        echo "Failed to start client"
        echo "Last few lines of log:"
        tail -10 "${LOG_FILE}"
        rm -f "${CLIENT_PID_FILE}"
        exit 1
    fi
else
    echo "Starting Hello Client (foreground)..."
    echo "Press Ctrl+C to exit"
    echo ""
    ./client -n "${IOR_FILE}" \
             -ORBInitRef NameService=file://"${IOR_FILE}"
fi
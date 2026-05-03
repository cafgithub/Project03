#!/bin/bash
# start_server.sh

PROJECT_DIR="/home/carlos/Project03"
NAMING_SERVICE_DIR="/home/carlos/ACE_wrappers/TAO/orbsvcs/Naming_Service"
IOR_FILE="${NAMING_SERVICE_DIR}/naming.ior"
SERVER_PID_FILE="${PROJECT_DIR}/server.pid"
LOG_FILE="${PROJECT_DIR}/server.log"
MY_IP="192.168.1.91"

# Check if naming service is running
if [ ! -f "${IOR_FILE}" ]; then
    echo "Error: Naming Service not running or IOR file not found"
    echo "Please start naming service first: ./start_naming_service.sh"
    exit 1
fi

# Check if server is already running
if [ -f "${SERVER_PID_FILE}" ] && kill -0 $(cat "${SERVER_PID_FILE}") 2>/dev/null; then
    echo "Server is already running with PID: $(cat ${SERVER_PID_FILE})"
    exit 1
fi

cd "${PROJECT_DIR}"

# Check if server executable exists
if [ ! -f "./server" ]; then
    echo "Server executable not found. Building..."
    make server
fi

# Start server with explicit ORB init reference
echo "Starting Hello Server..."
echo "Connecting to Naming Service at ${MY_IP}:12345"
./server -n "${IOR_FILE}" \
         -ORBInitRef NameService=file://"${IOR_FILE}" \
         -ORBListenEndpoints iiop://${MY_IP}:0 \
         > "${LOG_FILE}" 2>&1 &

SERVER_PID=$!
echo ${SERVER_PID} > "${SERVER_PID_FILE}"

sleep 2

# Check if started successfully
if kill -0 ${SERVER_PID} 2>/dev/null; then
    echo "Server started successfully"
    echo "  PID: ${SERVER_PID}"
    echo "  Log file: ${LOG_FILE}"
    echo ""
    echo "Checking log for errors:"
    tail -5 "${LOG_FILE}"
else
    echo "Failed to start server"
    echo "Last few lines of log:"
    tail -10 "${LOG_FILE}"
    rm -f "${SERVER_PID_FILE}"
    exit 1
fi
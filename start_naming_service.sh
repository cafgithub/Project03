#!/bin/bash
# start_naming_service_auto.sh

NAMING_SERVICE_DIR="/home/carlos/ACE_wrappers/TAO/orbsvcs/Naming_Service"
IOR_FILE="${NAMING_SERVICE_DIR}/naming.ior"
PID_FILE="${NAMING_SERVICE_DIR}/naming_service.pid"
MY_IP="192.168.1.91"

# Kill any existing naming service processes
pkill -9 tao_cosnaming
sleep 2

# Find a free port starting from 30000
PORT=30000

# while true; do
#     if ! ss -tuln | grep -q ":$PORT "; then
#         echo "Found free port: $PORT"
#         break
#     fi
#     PORT=$((PORT + 1))
#     if [ $PORT -gt 31000 ]; then
#         echo "No free ports found in range 30000-31000"
#         exit 1
#     fi
# done

# Remove old files
rm -f "${IOR_FILE}" "${PID_FILE}"

# Start naming service
echo "Starting TAO Naming Service on ${MY_IP}:${PORT}..."
cd "${NAMING_SERVICE_DIR}"
./tao_cosnaming -o "${IOR_FILE}" \
                -p "${PID_FILE}" \
                -m 0 \
                -ORBEndpoint iiop://${MY_IP}:${PORT} &

# Wait for service to start
sleep 3

# Check if started successfully
if [ -f "${IOR_FILE}" ]; then
    echo "✅ Naming Service started successfully"
    echo "  IP: ${MY_IP}"
    echo "  Port: ${PORT}"
    echo "  PID: $(cat ${PID_FILE} 2>/dev/null)"
    echo ""
    echo "Save this port number: ${PORT}"
    echo ""
    echo "To run server:"
    echo "  ./server -ORBInitRef NameService=corbaloc::${MY_IP}:${PORT}/NameService"
    echo ""
    echo "To run client:"
    echo "  ./client -ORBInitRef NameService=corbaloc::${MY_IP}:${PORT}/NameService"
    
    # Save port to file for other scripts
    echo "${PORT}" > "${NAMING_SERVICE_DIR}/ns_port.txt"
else
    echo "❌ Failed to start Naming Service"
    exit 1
fi
#!/bin/bash

# start_all.sh
# Starts all services in order

echo "=== Starting All Services ==="
echo ""

# Start Naming Service
./start_naming_service.sh
if [ $? -ne 0 ]; then
    echo "Failed to start Naming Service. Aborting."
    exit 1
fi

echo ""
sleep 2

# Start Server
./start_server.sh
if [ $? -ne 0 ]; then
    echo "Failed to start Server. Aborting."
    exit 1
fi

echo ""
sleep 1

# Ask about client
read -p "Start Client? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Run in background? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./start_client.sh -b
    else
        ./start_client.sh
    fi
fi

echo ""
echo "=== All services started ==="
echo "Run ./status.sh to check status"
echo "Run ./stop_all.sh to stop all services"

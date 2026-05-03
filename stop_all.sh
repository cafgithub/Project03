#!/bin/bash

# stop_all.sh
# Stops all services

echo "=== Stopping All Services ==="
echo ""

./stop_server.sh
echo ""
./stop_naming_service.sh

echo ""
echo "=== All services stopped ==="

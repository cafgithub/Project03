#!/bin/bash

# compile_idl.sh - Script to compile TAO IDL files with proper GPERF setup

# Set ACE_ROOT and TAO_ROOT (adjust these paths to your installation)
export ACE_ROOT=/home/carlos/ACE_wrappers
export TAO_ROOT=${ACE_ROOT}/TAO

# Add ACE_ROOT/bin to PATH for gperf
export PATH=$ACE_ROOT/bin:$PATH

# Check if gperf is installed
if ! command -v gperf &> /dev/null; then
    echo "GPERF not found. Installing gperf..."
    sudo apt-get update
    sudo apt-get install -y gperf
fi

# Check if gperf is in ACE_ROOT/bin
if [ -f "$ACE_ROOT/bin/gperf" ]; then
    echo "Using gperf from ACE_ROOT/bin"
elif [ -f "/usr/bin/gperf" ]; then
    echo "Using system gperf"
else
    echo "Warning: GPERF not found. Will use dynamic hashing (slower)."
    echo "To install gperf: sudo apt-get install gperf"
fi

# Set LD_LIBRARY_PATH if needed
export LD_LIBRARY_PATH=$ACE_ROOT/lib:$LD_LIBRARY_PATH

# Clean previous files
echo "Cleaning previous IDL generated files..."
rm -f HelloC.h HelloC.cpp HelloS.h HelloS.cpp HelloS.i

# Compile the IDL file
echo "Compiling Hello.idl..."
tao_idl Hello.idl

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "✅ IDL compilation successful!"
    echo "Generated files:"
    ls -la HelloC.* HelloS.* 2>/dev/null
else
    echo "❌ IDL compilation failed!"
    exit 1
fi
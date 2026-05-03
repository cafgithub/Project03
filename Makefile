# Compiler
CXX = g++

# TAO/ACE paths
ACE_ROOT = /home/carlos/ACE_wrappers
TAO_ROOT = $(ACE_ROOT)/TAO

# Include directories
INCLUDES = -I$(ACE_ROOT) \
           -I$(TAO_ROOT) \
           -I$(TAO_ROOT)/orbsvcs

# Library directories
LIB_DIR = -L$(ACE_ROOT)/lib

# Libraries
COMMON_LIBS = -lTAO_AnyTypeCode -lTAO -lACE -lpthread -ldl -lrt
SERVER_LIBS = -lTAO_PortableServer -lTAO_CosNaming
CLIENT_LIBS = -lTAO_CosNaming

# Compiler flags
CXXFLAGS = -Wall -O2 $(INCLUDES)

# Targets
all: server client

server: HelloServer.cpp HelloC.cpp HelloS.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LIB_DIR) $(SERVER_LIBS) $(COMMON_LIBS)

client: HelloClient.cpp HelloC.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LIB_DIR) $(CLIENT_LIBS) $(COMMON_LIBS)

clean:
	rm -f server client
#Compiler
CC = g++
CFLAGS = -g -Wall -std=c++11

#Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
TST_DIR = tests

SOURCES  := $(wildcard $(SRC_DIR)/*.cpp)
INCLUDES := $(wildcard $(SRC_DIR)/*.h)
OBJECTS  := $(SOURCES:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)

#Target
EXEC = stack
TARGET := $(BIN_DIR)/$(EXEC)

.PHONY: all
all: $(TARGET)

$(TARGET): dirs $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS)

$(OBJECTS): $(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: dirs
dirs:
	@ mkdir -p $(OBJ_DIR)
	@ mkdir -p $(BIN_DIR)

.PHONY: test
test: dirs $(OBJECTS)
	@ bash $(TST_DIR)/runtests.sh

.PHONY: grade
grade:
	@ bash ./$(GRD_DIR)/grade.sh

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)
	rm -rf $(OBJ_DIR)

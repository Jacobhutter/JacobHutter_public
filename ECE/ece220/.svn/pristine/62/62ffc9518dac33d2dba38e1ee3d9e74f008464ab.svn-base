CC = gcc
CFLAGS = -g -Wall -std=c99 -m32

#Directories
SRC_DIR = src
BIN_DIR = bin

#Files
SOURCES := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*.S)

#Binaries
BIN = max
TARGET := $(BIN_DIR)/$(BIN)

.PHONY: all
all: dirs $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: dirs
dirs: 
	mkdir -p bin

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)

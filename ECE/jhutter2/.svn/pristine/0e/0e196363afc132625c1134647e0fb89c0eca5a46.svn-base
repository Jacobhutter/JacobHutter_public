CC = gcc
CFLAGS = -g -Wall -std=c99 -m32

#Directories
SRC_DIR = src
BIN_DIR = bin
TST_DIR = tests
GRD_DIR = grade

#Files
SOURCES := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*.S)

#Binaries
BIN = rev_avg
TARGET := $(BIN_DIR)/$(BIN)

.PHONY: all
all: dirs $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: dirs
dirs: 
	mkdir -p bin

.PHONY: test
test:
	bash ./$(TST_DIR)/runtests.sh

.PHONY: grade
grade:
	bash ./$(GRD_DIR)/grade.sh

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)

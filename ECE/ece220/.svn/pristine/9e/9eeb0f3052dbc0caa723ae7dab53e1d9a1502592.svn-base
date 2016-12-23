#Assembler
AS = lc3as

#Directories
SRC_DIR = src
OBJ_DIR = obj
TST_DIR = tests
GRD_DIR = grade

#Files
SOURCES := $(wildcard $(SRC_DIR)/*.asm)

.PHONY: all
all: dirs sources

.PHONY: sources
sources:
	-$(AS) $(SOURCES)
	mv $(SRC_DIR)/*.obj $(OBJ_DIR)
	mv $(SRC_DIR)/*.sym $(OBJ_DIR)

.PHONY: dirs
dirs:
	mkdir -p obj

.PHONY: test
test:
	bash ./$(TST_DIR)/runtests.sh

.PHONY: grade
grade:
	bash ./$(GRD_DIR)/grade.sh

.PHONY: clean
clean:
	rm -rf $(OBJ_DIR)

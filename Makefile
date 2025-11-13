# Makefile for Futhark Language Interpreter

# Compiler and flags
CC = cc
CFLAGS = -Wall -Wextra -g
LDFLAGS =

# Build tools
FLEX = flex
BISON = bison

# Source files
LEX_SOURCE = ᚠᚢᚦᛆᚱᚴ.lex
YACC_SOURCE = ᚠᚢᚦᛆᚱᚴ.y

# Generated files
LEX_OUTPUT = lex.yy.c
YACC_OUTPUT = ᚠᚢᚦᛆᚱᚴ.tab.c
YACC_HEADER = ᚠᚢᚦᛆᚱᚴ.tab.h

# Object files
LEX_OBJ = lex.yy.o
YACC_OBJ = ᚠᚢᚦᛆᚱᚴ.tab.o

# Executable
TARGET = futhark

# Default target
all: $(TARGET)

# Build the executable
$(TARGET): $(LEX_OBJ) $(YACC_OBJ)
	$(CC) $(LDFLAGS) -o $@ $^
	@echo "✓ Built $(TARGET) successfully"

# Compile lexer object file
$(LEX_OBJ): $(LEX_OUTPUT) $(YACC_HEADER)
	$(CC) $(CFLAGS) -c -o $@ $(LEX_OUTPUT)

# Compile parser object file
$(YACC_OBJ): $(YACC_OUTPUT)
	$(CC) $(CFLAGS) -c -o $@ $(YACC_OUTPUT)

# Generate lexer C code
$(LEX_OUTPUT): $(LEX_SOURCE)
	$(FLEX) $(LEX_SOURCE)
	@echo "✓ Generated lexer from $(LEX_SOURCE)"

# Generate parser C code and header
$(YACC_OUTPUT) $(YACC_HEADER): $(YACC_SOURCE)
	$(BISON) -d $(YACC_SOURCE)
	@echo "✓ Generated parser from $(YACC_SOURCE)"

# Clean build artifacts
clean:
	rm -f $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER)
	rm -f $(LEX_OBJ) $(YACC_OBJ)
	rm -f $(TARGET)
	@echo "✓ Cleaned all build artifacts"

# Clean and rebuild
rebuild: clean all

# Install target (optional)
install: $(TARGET)
	@echo "Installing to /usr/local/bin (requires sudo)"
	sudo cp $(TARGET) /usr/local/bin/
	@echo "✓ Installed $(TARGET) to /usr/local/bin"

# Run automated tests
test: $(TARGET)
	@echo "Running automated test suite..."
	@./run_tests.sh

# Phony targets
.PHONY: all clean rebuild install test help

# Help target
help:
	@echo "Futhark Language Build System"
	@echo "=============================="
	@echo ""
	@echo "Targets:"
	@echo "  all      - Build the Futhark interpreter (default)"
	@echo "  clean    - Remove all generated files and build artifacts"
	@echo "  rebuild  - Clean and build from scratch"
	@echo "  test     - Run automated test suite"
	@echo "  install  - Install the interpreter to /usr/local/bin"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "Usage:"
	@echo "  make           # Build the interpreter"
	@echo "  make test      # Run all tests"
	@echo "  make clean     # Clean build artifacts"
	@echo "  make rebuild   # Clean and rebuild"
	@echo "  make install   # Install system-wide"

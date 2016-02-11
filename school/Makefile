COMPILER = fpc
DEBUGGER = gdb
OUTPUT = losange
FLAGS = -gl -o$(OUTPUT) -Mtp
INPUT = < input.txt
SOURCE = losange.pas
all: $(SOURCE)
	$(COMPILER) $(FLAGS) $(SOURCE)
run: all $(OUTPUT)
	./$(OUTPUT) $(INPUT)
debug: all
	gdb ./$(OUTPUT)

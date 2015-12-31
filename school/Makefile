COMPILER = fpc
DEBUGGER = gdb
OUTPUT = 2010_pratique_1
FLAGS = -gl -o$(OUTPUT)
INPUT = < input.txt
SOURCE = 2010_pratique_1.pas
all: $(SOURCE)
	$(COMPILER) $(FLAGS) $(SOURCE)
run: all $(OUTPUT)
	./$(OUTPUT) $(INPUT)
debug: all
	gdb ./$(OUTPUT)

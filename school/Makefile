COMPILER = fpc
DEBUGGER = gdb
OUTPUT = distance
FLAGS = -gl -o$(OUTPUT) -Mtp
INPUT = < input.txt
SOURCE = distance.pas
all: $(SOURCE)
	$(COMPILER) $(FLAGS) $(SOURCE)
run: all $(OUTPUT)
	./$(OUTPUT) $(INPUT)
debug: all
	gdb ./$(OUTPUT)

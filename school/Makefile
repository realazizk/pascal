COMPILER = fpc
DEBUGGER = gdb
OUTPUT = counting_sort
FLAGS = -gl -o$(OUTPUT) -Mtp
INPUT = < input.txt
SOURCE = counting_sort.pas
all: $(SOURCE)
	$(COMPILER) $(FLAGS) $(SOURCE)
run: all $(OUTPUT)
	./$(OUTPUT) $(INPUT)
debug: all
	gdb ./$(OUTPUT)

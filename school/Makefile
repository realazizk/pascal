COMPILER = fpc
DEBUGGER = gdb
OUTPUT = 3_2009
FLAGS = -gl -o$(OUTPUT) -Mtp
#INPUT = < input.txt
SOURCE = 3_2009.pas
all: $(SOURCE)
	$(COMPILER) $(FLAGS) $(SOURCE)
run: all $(OUTPUT)
	./$(OUTPUT) $(INPUT)
debug: all
	$(DEBUGGER) ./$(OUTPUT)

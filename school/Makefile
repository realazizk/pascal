COMPILER = fpc
DEBUGGER = gdb
FLAGS = -gl
INPUT = < input.txt
all: trifusion.pas
	$(COMPILER) $(FLAGS) trifusion.pas	
run: all trifusion
	./trifusion $(INPUT)
debug: all
	gdb ./trifusion

FILENAME = p2
INPUT = input.txt

all: cls employee.o compile
cls:
	clear
employee.o:
	gcc -c employee.c

compile:
	flex $(FILENAME).l
	bison -o $(FILENAME).tab.c $(FILENAME).y -yd
	gcc -o $(FILENAME) lex.yy.c employee.o $(FILENAME).tab.c -lfl -ly -w

run:
	./$(FILENAME) < $(INPUT)

clean:
	rm $(FILENAME) lex.yy.c $(FILENAME).tab.c $(FILENAME).tab.h employee.o

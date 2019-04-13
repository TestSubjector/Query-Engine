FILENAME = p2
INPUT = input.txt

all: employee.o department.o compile
cls:
	clear
employee.o:
	gcc -c employee.c
department.o:
	gcc -c department.c

compile:
	flex $(FILENAME).l
	bison -o $(FILENAME).tab.c $(FILENAME).y -yd
	gcc -g -o $(FILENAME) lex.yy.c employee.o department.o $(FILENAME).tab.c -lfl -ly -w

run:
	./$(FILENAME) < $(INPUT)

clean:
	rm $(FILENAME) lex.yy.c $(FILENAME).tab.c $(FILENAME).tab.h employee.o department.o

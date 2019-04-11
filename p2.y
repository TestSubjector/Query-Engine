%{
	#include <stdio.h>
	#include <string.h>
	#include "employee.h"

	#define max(a,b) ((a)>(b)?(a):(b))
	void yyerror (char const *);

	int numMedidas = 0;
	tEmployeeList employeeList;
	char auxillary[10][20];
	int indice = 0;
	char * table;
	char * argument1;
	char * argument2;
	char * operator;
	char * errorFlag;
	char buffer[2];
	int check = 0;
	int where = 0;

%}
/*
****************************************************************************
****************************************************************************
*/

%union
{
	int valInt;
	float valFloat;
	char * valString;
}

%token GET FROM WHERE
%token <valString> FIELD TABLE OPERATOR EOFF NUMBERS COMMA SEMICOLON ASTERISK STRINGVALUE WORD
%type <valString> fieldselect fromtable selectfrom wheretable wherefrom argument
%start S
%%

S:  wheretable
	{
		printf("\n Reached wheretable\n");
		check = 0;
	}
	|fromtable
	{
		printf("\n Reached fromtable\n");
		check = 0;
	}
;

wheretable: wherefrom argument OPERATOR argument SEMICOLON
{
	printf("\n |where| command- ");
	argument1 = $2;
	operator = $3;
	argument2 = $4;
}
;

wheretable: wherefrom argument OPERATOR argument
		{
			yyerror("ERROR: No semicolon in input;");
			check = 1;
			return;
		}
	| wherefrom EOFF
		{
			yyerror("ERROR: Reached file end incorrectly;");
			//check = 1;
			//return;
		}
	| wherefrom argument OPERATOR error
		{
			yyerror("ERROR: The given operand/argument is not recognised;");
			check = 1;
			return;
		}
	| wherefrom argument error
		{
			yyerror("ERROR: The given operator/argument is not recognised;");
			check = 1;
			return;
		}
	| wherefrom error
		{
			yyerror("ERROR: The given operand/argument is not recognised;");
			check = 1;
			return;
		}
;

argument : FIELD | NUMBERS | STRINGVALUE;

wherefrom: fromtable WHERE {printf("\n |wherefrom| command - ");}
	| fromtable SEMICOLON
		{
			printf("\n ERROR: |where| not given");
			where = 1;
			return;
		}
	| fromtable error
		{
			yyerror("\n ERROR: WHERE not in given conditions/arguments;");
			check = 1;
			return;
		}
	| fromtable
		{
			yyerror("\n ERROR: No arguments given with command;");
			check = 1;
			return;
		}
;

fromtable: selectfrom TABLE {table = $2; printf("\n |fromtable| command - ");}
	| selectfrom error
		{
			yyerror("\n ERROR: Table name is not recognised ;");
			check = 1;
			return;
		}
;

selectfrom: fieldselect FROM {printf("\n |selectfrom| command - ");}
	| selectasterisk FROM {printf("\n |asterisk| selection");}
	| fieldselect error
		{
			strcpy(errorFlag,"\n ERROR: Not recognised ");
			sprintf(buffer, 2, "%d", indice+2);
			strcat(errorFlag,buffer);
			yyerror(errorFlag);
			check = 1;
			return;
		}
;

selectasterisk: GET ASTERISK {printf("\n |asterisk| command - ");}
	| selectasterisk error
		{
			yyerror("\n ERROR: There must be a FROM after the asterisk;");
			check = 1;
			return;
		}
;

fieldselect: GET FIELD 	{
								strcpy(auxillary[indice], $2);
								indice++;
								printf("\n Select");
							}
	| fieldselect COMMA FIELD
	{
		strcpy(auxillary[indice], $3);
		indice++;printf("\n Select2 ");
	}
	| GET error
	{
		strcpy(errorFlag,"\n ERROR: Unrecognised token;");
		// strcat(errorFlag,"2");
		yyerror(errorFlag);
		check = 1;
		return;
	}
	| fieldselect FIELD error
	{
		strcpy(errorFlag,"\n ERROR: Unrecognised token;");
		snprintf(buffer, 2, "%d", indice+3);
		strcat(errorFlag,buffer);
		yyerror(errorFlag);
		check = 1;
		return;
	}
;

/*
****************************************************************************
****************************************************************************
*/

%%
//Build Employee List

tEmployeeList parseDB()
{
	employeeList = createEmployeeList (); // Assign memory
	FILE *f = fopen("EMP.txt", "r" );
	if (!f)
	{
		printf("\n Could not open file EMP for reading.");
		fclose(f);
		exit(0);
	}

	// Move file pointer to end of file
	fseek(f, 0, SEEK_END);
	long fileSize = ftell(f);
	// Move file pointer to start of file
	fseek(f, 0, SEEK_SET);
	char *fileString = malloc(fileSize + 1);
	// Read the file and store the contents in string
	fread(fileString, fileSize, 1, f);
	fclose(f);

	char * indexNumber = strtok (fileString, ",");
	// For strtok() to keep searching the same string, pass a NULL pointer as its first argument.
	char * ename = strtok (NULL, ",");
	char * eage = strtok (NULL, ",");
	char * puesto = strtok (NULL, ",");
	char * anho = strtok (NULL, "\n");
	tEmployee empleado = createEmployee (ename, eage, puesto, anho, atoi(indexNumber));
	addEmployeeToList (employeeList, empleado);

	// Keep reading word by word
	while(1)
	{
		indexNumber = strtok (NULL, ",");
		if (indexNumber == NULL)
			break;
		ename = strtok (NULL, ",");
		eage = strtok (NULL, ",");
		puesto = strtok (NULL, ",");
		anho = strtok (NULL, "\n");
		empleado = createEmployee (ename, eage, puesto,anho, atoi(indexNumber));
		addEmployeeToList (employeeList, empleado);
	}
	return employeeList;
}



char * getField(char * argument, tEmployee tE)
{
	int atoi1 = 0;
	char * opp =  malloc(sizeof(char)* 80);
	atoi1 = atoi(argument);
	if (atoi1 != NULL)
		return argument;
	else
	{
		// strncmp ompares up to num characters of given strings
		if(!strncmp(argument,"indexNumber",10))
			sprintf(opp, "Index number used %d", tE->indexNumber);
		else if(!strncmp(argument,"ename",10))
			opp = tE->ename;
		else if(!strncmp(argument,"eage",10))
			opp = tE->eage;
		else if(!strncmp(argument,"anho",10))
			opp = tE->anho;
		else if(!strncmp(argument,"puesto",10))
			opp = tE->puesto;
		else
		{
			opp = strtok(argument,"\"");
		}
	}
	return opp;
}


/*
****************************************************************************
****************************************************************************
*/

int main()
{
	errorFlag = malloc(sizeof(char)* 80);

	char * field;
	int length;
	int len;
	int atoi1, atoi2;
	int print = 0;
	int k = 0;
	char * test;
	char * field1 =  malloc(sizeof(char)* 80);
	char * field2 =  malloc(sizeof(char)* 80);
	int p = 0;

	//Call the c function yyparse to cause parsing to occur. This function reads tokens and executes actions,
	yyparse();

	if (check != 0 || table == NULL)
	{
		printf("\n Exiting...\n");
		return 0 ;
	}

	// Get all contents of file
	tEmployeeList l = parseDB();
	// Get total length of entries
	length = lengthEmployeeList(l);

	// This will read the command, indice gives length
	int i = 0;
	for (i = 0; i < indice; i++)
	{
		printf("\n Field %d -> %s", i, auxillary[i]);
	}
	printf("\n Table -> %s",table);
	printf("\n Argument_1 -> %s",argument1);
	printf("\n Argument_2 -> %s",argument2);
	printf("\n Argument_Opr -> %s\n\n",operator);

	if(where)
	{
		argument1 = "1";
		argument2 = "1";
		operator = "=";
	}

	// Iterate for every single employee
	for (k=0; k < length; k++)
	{

		tEmployee ss1 = getEmployeeFromListByIndex (l, k);
		field1 = getField(argument1,ss1); // Get required field

		if ((!strncmp(field1,argument1,strlen(field1))) || !strncmp(argument1,"\"",1))
		{
			k = length;
		}

		for(p = 0; p < length;p++)
		{

			tEmployee ss2 = getEmployeeFromListByIndex (l, p);
			field2 = getField(argument2,ss2);

			if ((!strncmp(field2,argument2,strlen(field2)) && k != length)|| !strncmp(argument2,"\"",1))
			{
				p = length;
				ss2 = ss1;
			}

			if (!strncmp(operator,"=",1))
			{
				len = max(strlen(field1),strlen(field2));
				print = !strncmp(field1,field2,len);
			}
			else
			{
				atoi1 = atoi(field1);
				atoi2 = atoi(field2);
				if (atoi1 != NULL && atoi2 != NULL)
					if (!strncmp(operator,">",1))
						print = atoi1 > atoi2;
					if (!strncmp(operator,"<",1))
						print = atoi1 < atoi2;
			}

			if (print)
			{
				if (indice == 0)
					printf("%d %s %s %s %s", ss2->indexNumber, ss2->ename, ss2->eage, ss2->puesto, ss2->anho);
				else
				{
					i = 0;
					for (i=0; i< indice; i++)
					{
						field = auxillary[i];
						if(!strncmp(field,"indexNumber",10))
							printf(" %d ",ss2->indexNumber);
						if(!strncmp(field,"ename",6))
							printf(" %s ",ss2->ename);
						if(!strncmp(field,"eage",9))
							printf(" %s ",ss2->eage);
						if(!strncmp(field,"anho",4))
							printf(" %s ",ss2->anho);
						if(!strncmp(field,"puesto",6))
							printf(" %s ",ss2->puesto);
					}
				}
			printf("\n");
			}
		}
	}
	return 0;
}

void yyerror (char const *message) { if (strncmp(message,"syntax error",12))fprintf (stderr, "%s\n", message);}

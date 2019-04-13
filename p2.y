%{
	#include <stdio.h>
	#include <string.h>
	#include "employee.h"
	#include "department.h"

	#define max(a,b) ((a)>(b)?(a):(b))
	void yyerror (char const *);

	int numMedidas = 0;
	tEmployeeList employeeList;
	tDepartmentList departmentList;
	char auxillary[10][20];
	int indice = 0;
	int isAndOrOrFlag = -1;
	char * table;
	int conditionLength = 0;
	char argument1[10][30];
	char argument2[10][30];
	char operator[10][30];
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
	char * valString;
}

%token GET FROM WHERE AND OR INSERT RECORD UPDATE IN DELETE SET TO INTO
%token <valString> FIELD TABLE OPERATOR EOFF NUMBERS COMMA SEMICOLON ASTERISK STRINGVALUE WORD SINGLEQUOTES
%type <valString> fieldget fromtable getfrom wheretable wherefrom argument condition check
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
	| updatetable
	{
		printf("\n Reached updatetable\n");
		check = 0;
	}
	| inserttable
	{
		printf("\n Reached inserttable\n");
		check = 0;
	}
	| deletetable
	{
		printf("\n Reached deletetable\n");
		check = 0;
	}
;

wheretable: wherefrom condition SEMICOLON
{
	printf("\n |where| command- ");
}
;

wheretable: wherefrom condition
		{
			yyerror("Warning: No semicolon in input;");
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

fromtable: getfrom TABLE {table = $2; printf("\n |fromtable| command - ");}
	| getfrom error
		{
			yyerror("\n ERROR: Table name is not recognised ;");
			check = 1;
			return;
		}
;

getfrom: fieldget FROM {printf("\n |getfrom| command - ");}
	| getasterisk FROM {printf("\n |asterisk| sign ");}
	| fieldget error
		{
			strcpy(errorFlag,"\n ERROR: Not recognised ");
			sprintf(buffer, 2, "%d", indice+2);
			strcat(errorFlag,buffer);
			yyerror(errorFlag);
			check = 1;
			return;
		}
;

getasterisk: GET ASTERISK {printf("\n |asterisk| command - ");}
	| getasterisk error
		{
			yyerror("\n ERROR: There must be a FROM after the asterisk;");
			check = 1;
			return;
		}
;

fieldget: GET FIELD {
						strcpy(auxillary[indice], $2);
						indice++;
						printf("\n Get");
					}
	| fieldget COMMA FIELD
	{
		strcpy(auxillary[indice], $3);
		indice++;
		printf("\n Get2 ");
	}
	| GET error
	{
		strcpy(errorFlag,"\n ERROR: Unrecognised token;");
		// strcat(errorFlag,"2");
		yyerror(errorFlag);
		check = 1;
		return;
	}
	| fieldget FIELD error
	{
		strcpy(errorFlag,"\n ERROR: Unrecognised token;");
		snprintf(buffer, 2, "%d", indice+3);
		strcat(errorFlag,buffer);
		yyerror(errorFlag);
		check = 1;
		return;
	}
;

condition: check AND condition
	{
		isAndOrOrFlag = 0;
		printf("\n AND command;");
	}
	| check OR condition
	{
		isAndOrOrFlag = 1;
		printf("\n OR command;");
	}
	| check
	{
		printf("\n Final command;");
	}
;

check:	argument OPERATOR argument
	{
		printf("\n Reaching commands;");
		strcpy(argument1[conditionLength], $1);
		strcpy(operator[conditionLength], $2);
		strcpy(argument2[conditionLength], $3);
		conditionLength++;
	}
;

inserttable: INSERT RECORD entry INTO TABLE {printf("\n Matches;");}
;

deletetable: DELETE RECORD FROM TABLE WHERE condition SEMICOLON
;

updatetable: UPDATE RECORD IN TABLE SET FIELD TO argument WHERE condition SEMICOLON
;

entry: argument COMMA argument COMMA argument COMMA argument
	{
		printf("\n Inserting into table");
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
	FILE *femp = fopen("EMP.txt", "r" );
	if (!femp)
	{
		printf("\n Could not open file EMP for reading.");
		fclose(femp);
		exit(0);
	}

	// Move file pointer to end of file
	fseek(femp, 0, SEEK_END);
	long fileSize = ftell(femp);
	// Move file pointer to start of file
	fseek(femp, 0, SEEK_SET);
	char *fileString = malloc(fileSize + 1);
	// Read the file and store the contents in string
	fread(fileString, fileSize, 1, femp);
	fclose(femp);

	char * indexNumber = strtok (fileString, ",");
	// For strtok() to keep searching the same string, pass a NULL pointer as its first argument.
	char * ename = strtok (NULL, ",");
	char * eage = strtok (NULL, ",");
	char * eaddress = strtok (NULL, ",");
	char * salary = strtok (NULL, "\n");
	tEmployee empleado = createEmployee (ename, eage, eaddress, salary, atoi(indexNumber));
	addEmployeeToList (employeeList, empleado);

	// Keep reading word by word
	while(1)
	{
		indexNumber = strtok (NULL, ",");
		if (indexNumber == NULL)
			break;
		ename = strtok (NULL, ",");
		eage = strtok (NULL, ",");
		eaddress = strtok (NULL, ",");
		salary = strtok (NULL, "\n");
		empleado = createEmployee (ename, eage, eaddress, salary, atoi(indexNumber));
		addEmployeeToList (employeeList, empleado);
	}
	return employeeList;
}

tDepartmentList parseDBDept()
{
	departmentList = createDepartmentList (); // Assign memory
	FILE *fdept = fopen("DEPT.txt", "r" );
	if (!fdept)
	{
		printf("\n Could not open file DEPT for reading.");
		fclose(fdept);
		exit(0);
	}

	// Move file pointer to end of file
	fseek(fdept, 0, SEEK_END);
	long fileSize = ftell(fdept);
	// Move file pointer to start of file
	fseek(fdept, 0, SEEK_SET);
	char *fileString = malloc(fileSize + 1);
	// Read the file and store the contents in string
	fread(fileString, fileSize, 1, fdept);
	fclose(fdept);

	char * indexNumber = strtok (fileString, ",");
	// For strtok() to keep searching the same string, pass a NULL pointer as its first argument.
	int dnum= strtok (NULL, ",");
	char * dname = strtok (NULL, ",");
	char * dlocation = strtok (NULL, "\n");
	// printf("\n>>>1 %s %s %s %s", indexNumber, dnum, dname, dlocation);
	tDepartment department = createDepartment (dnum, dname, dlocation, atoi(indexNumber));
	addDepartmentToList (departmentList, department);

	// Keep reading word by word
	while(1)
	{
		indexNumber = strtok (NULL, ",");
		// printf("\n IndexNumber is %d", indexNumber);
		if (indexNumber == NULL)
			break;
		dnum = strtok (NULL, ",");
		dname = strtok (NULL, ",");
		dlocation = strtok (NULL, "\n");
		// printf("\n>>>2 %s %s %s %s", indexNumber, dnum, dname, dlocation);
		department = createDepartment (dnum, dname, dlocation, atoi(indexNumber));
		// printf("\n#### %s", department->indexNumber);
		addDepartmentToList (departmentList, department);
		// printf("\n#### %s", departmentList->tail->tDepartment->indexNumber);
	}
	return departmentList;
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
		// strncmp compares up to num characters of given strings
		if(!strncmp(argument,"indexNumber",10))
			sprintf(opp, "Index number used %d", tE->indexNumber);
		else if(!strncmp(argument,"ename",10))
			opp = tE->ename;
		else if(!strncmp(argument,"eage",10))
			opp = tE->eage;
		else if(!strncmp(argument,"salary",10))
			opp = tE->salary;
		else if(!strncmp(argument,"eaddress",10))
			opp = tE->eaddress;
		else
		{
			opp = strtok(argument,"\"");
		}
	}
	return opp;
}

char * getFieldDept(char * argument, tDepartment tE)
{
	int atoi1 = 0;
	char * opp =  malloc(sizeof(char)* 80);
	atoi1 = atoi(argument);
	if (atoi1 != NULL)
		return argument;
	else
	{
		// strncmp compares up to num characters of given strings
		if(!strncmp(argument,"indexNumber",10))
			sprintf(opp, "Index number used %d", tE->indexNumber);
		else if(!strncmp(argument,"dnum",10))
			opp = tE->dnum;
		else if(!strncmp(argument,"dname",10))
			opp = tE->dname;
		else if(!strncmp(argument,"dlocation",10))
			opp = tE->dlocation;
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
	int lengthEmp;
	int lengthDept;
	int len;
	int atoi1, atoi2;
	int printFlag = 0;
	int k = 0;
	char * test;
	char * field1 =  malloc(sizeof(char)* 80);
	char * field2 =  malloc(sizeof(char)* 80);
	int p = 0;
	int conditionLoop = 0;

	while(1)
	{
		//Call the c function yyparse to cause parsing to occur. This function reads tokens and executes actions,
		yyparse();

		if (check != 0 || table == NULL)
		{
			printf("\n Exiting...\n");
			return 0 ;
		}

		// Get all contents of file
		tEmployeeList empl = parseDB();
		// Get total lengthEmp of entries
		lengthEmp = lengthEmployeeList(empl);

		tDepartmentList deptl = parseDBDept();
		lengthDept = lengthDepartmentList(deptl);


		// This will read the command, indice gives lengthEmp
		int i = 0;
		for (i = 0; i < indice; i++)
		{
			printf("\n Field %d -> %s", i, auxillary[i]);
		}
		printf("\n Table -> %s",table);

		// No conditions
		if(where)
		{
			strcpy(argument1,"1");
			strcpy(argument2,"1");
			strcpy(operator, "=");
			conditionLength++;
		}

		for (i = 0; i < conditionLength; i++)
		{
			printf("\n Argument_1 -> %s",argument1[i]);
			printf("\n Argument_2 -> %s",argument2[i]);
			printf("\n Argument_Opr -> %s\n\n",operator[i]);
		}

		// printf("\n\n ^^^^^^ the table is %s", table);
		// Iterate for every single employee
		if(strcmp(table, "Employee")==0)
		{
			for (k=0; k < lengthEmp; k++)
			{
				tEmployee ss1 = getEmployeeFromListByIndex (empl, k);
				field1 = getField(argument1[0],ss1); // Get required field
				// printf("\n >>>1 %s", field1);

				// Some error, exiting
				if ((!strncmp(field1,argument1[0],strlen(field1))) || !strncmp(argument1[0],"\"",1))
				{
					printf("\n ERROR: Condition error;");
					k = lengthEmp;
				}

				for(p = 0; p < lengthEmp; p++)
				{
					// Second list
					tEmployee ss2 = getEmployeeFromListByIndex (empl, p);
					for(conditionLoop = 0; conditionLoop< conditionLength; conditionLoop++)
					{
						field1 = getField(argument1[conditionLoop],ss1); // Get required field
						field2 = getField(argument2[conditionLoop],ss2);
						// printf("\n >>>2 %s %s",field1, field2);

						if ((!strncmp(field2,argument2[conditionLoop],strlen(field2)) && k != lengthEmp)|| !strncmp(argument2[conditionLoop],"\"",1))
						{
							p = lengthEmp;
							ss2 = ss1;
						}

						// strncmp returns an integral value indicating the relationship between the strings:
						if (!strncmp(operator[conditionLoop],"=",1))
						{
							len = max(strlen(field1),strlen(field2));
							printFlag = !strncmp(field1,field2,len);
						}
						else
						{
							atoi1 = atoi(field1);
							atoi2 = atoi(field2);
							if (atoi1 != NULL && atoi2 != NULL)
								if (!strncmp(operator[conditionLoop],">",1))
									printFlag = atoi1 > atoi2;
								if (!strncmp(operator[conditionLoop],"<",1))
									printFlag = atoi1 < atoi2;
						}
						if(!printFlag && isAndOrOrFlag == 0)
						{
							break;
						}
						else if(printFlag && isAndOrOrFlag == 1)
						{
							break;
						}
					}

					if (printFlag)
					{
						if (indice == 0)
							printf("\n %d %s %s %s %s", ss2->indexNumber, ss2->ename, ss2->eage, ss2->eaddress, ss2->salary);
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
								if(!strncmp(field,"salary",4))
									printf(" %s ",ss2->salary);
								if(!strncmp(field,"eaddress",6))
									printf(" %s ",ss2->eaddress);
							}
						}
					printf("\n");
					}
				}
			}
		}
		else
		{
			for (k=0; k < lengthDept; k++)
			{
				tDepartment ss1 = getDepartmentFromListByIndex (deptl, k);
				field1 = getFieldDept(argument1[0],ss1); // Get required field
				// printf(">>> %s", field1);

				// Some error, exiting
				if ((!strncmp(field1,argument1[0],strlen(field1))) || !strncmp(argument1[0],"\"",1))
				{
					printf("\n ERROR: Condition error;");
					k = lengthDept;
				}

				for(p = 0; p < lengthDept;p++)
				{
					// Second list
					tDepartment ss2 = getDepartmentFromListByIndex (deptl, p);
					for(conditionLoop = 0; conditionLoop< conditionLength; conditionLoop++)
					{
						field1 = getFieldDept(argument1[conditionLoop],ss1); // Get required field
						field2 = getFieldDept(argument2[conditionLoop],ss2);
						// printf("\n >>>2 %s %s",field1, field2);

						if ((!strncmp(field2,argument2[conditionLoop],strlen(field2)) && k != lengthDept)|| !strncmp(argument2[conditionLoop],"\"",1))
						{
							p = lengthDept;
							ss2 = ss1;
						}

						if (!strncmp(operator[conditionLoop],"=",1))
						{
							len = max(strlen(field1),strlen(field2));
							printFlag = !strncmp(field1,field2,len);
							// printf("\n Printflag1 is %s %s", field1, field2);
						}
						else
						{
							atoi1 = atoi(field1);
							atoi2 = atoi(field2);
							if (atoi1 != NULL && atoi2 != NULL)
								if (!strncmp(operator[conditionLoop],">",1))
									printFlag = atoi1 > atoi2;
								if (!strncmp(operator[conditionLoop],"<",1))
									printFlag = atoi1 < atoi2;
						}
						if(!printFlag && isAndOrOrFlag == 0)
						{
							break;
						}
						else if(printFlag && isAndOrOrFlag == 1)
						{
							break;
						}
					}
					// printf("\n Printflag2 is %d", printFlag);
					// printf("\n>>>1 %s", ss2->dlocation);
					if (printFlag)
					{
						if (indice == 0)
							printf("%s %s %s", ss2->dnum, ss2->dname, ss2->dlocation);
						else
						{
							i = 0;
							for (i=0; i< indice; i++)
							{
								field = auxillary[i];
								// if(!strncmp(field,"indexNumber",10))
								// 	printf(" %d ",ss2->indexNumber);
								if(!strncmp(field,"dnum",6))
									printf(" %s ",ss2->dnum);
								if(!strncmp(field,"dname",9))
									printf(" %s ",ss2->dname);
								if(!strncmp(field,"dlocation",6))
									printf(" %s ",ss2->dlocation);
							}
						}
					printf("\n");
					}
				}
			}
		}
		conditionLength = 0;
	}
	return 0;
}

void yyerror (char const *message)
{
	if (strncmp(message,"syntax error",12))
		fprintf (stderr, "%s\n", message);
}

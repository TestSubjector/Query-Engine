#ifndef Employee
#define Employee

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct tEEmployee
{
	char *ename;
	int eage;
	char *eaddress;
	int salary;
	int indexNumber;
};

typedef struct tEEmployee *tEmployee;

struct tSNodeEmployee
{
	tEmployee tEmployee;
	struct tSNodeEmployee *sig;
};

typedef struct tSNodeEmployee *tNodeEmployee;

struct tEEmployeeList
{
	tNodeEmployee head;
	tNodeEmployee tail;
};

typedef struct tEEmployeeList *tEmployeeList;

tEmployee createEmployee (char *ename, int eage, char *eaddress, int salary, int indexNumber);

tEmployeeList createEmployeeList ();

int isEmptyEmployeeList (tEmployeeList EmployeeList);

void deleteEmployeeList (tEmployeeList *EmployeeList);

int addEmployeeToList (tEmployeeList EmployeeList, tEmployee Employee);

void removeFromEmployeeListIndex (tEmployeeList EmployeeList, int index);

int lengthEmployeeList (tEmployeeList EmployeeList);

tEmployee getEmployeeFromListByIndex (tEmployeeList EmployeeList, int index);

#endif

#ifndef Employee
#define Employee

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct tEEmployee
{
	char *nombre;
	char *apellidos;
	char *puesto;
	char *anho;
	int idEmpleado;
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

tEmployee createEmployee (char *nombre,char *apellidos,char *puesto, char *anho, int idEmpleado);

tEmployeeList createEmployeeList ();

int isEmptyEmployeeList (tEmployeeList EmployeeList);

void deleteEmployeeList (tEmployeeList *EmployeeList);

int addEmployeeToList (tEmployeeList EmployeeList, tEmployee Employee);

void removeFromEmployeeListIndex (tEmployeeList EmployeeList, int index);

int lengthEmployeeList (tEmployeeList EmployeeList);

tEmployee getEmployeeFromListByIndex (tEmployeeList EmployeeList, int index);

#endif

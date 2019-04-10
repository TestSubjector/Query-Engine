#include "employee.h"

tEmployee createEmployee (char *nombre,char *apellidos,char *puesto, char *anho, int idEmpleado)
{
	tEmployee tmp = (tEmployee) malloc (sizeof (struct tEEmployee));

	if (tmp == NULL)
		return NULL;

	tmp->nombre = (char*) malloc (sizeof (char) * strlen (nombre)+1);
	strcpy (tmp->nombre, nombre);
	tmp->apellidos = (char*) malloc (sizeof (char) * strlen (apellidos)+1);
	strcpy (tmp->apellidos, apellidos);

	tmp->puesto = (char*) malloc (sizeof (char) * strlen (puesto)+1);
	strcpy (tmp->puesto, puesto);

	tmp->anho = (char*) malloc (sizeof (char) * strlen (anho)+1);
	strcpy (tmp->anho, anho);
	tmp->idEmpleado = idEmpleado;
	return tmp;
}


tEmployeeList createEmployeeList ()
{
	tEmployeeList tmp = (tEmployeeList) malloc (sizeof (struct tEEmployeeList));
	if (tmp == NULL)
		return NULL;

	tmp->head = NULL;
	tmp->tail = NULL;
	return tmp;

}

int isEmptyEmployeeList (tEmployeeList EmployeeList)
{
	if (EmployeeList->head == NULL)
		return 1;
	return 0;
}


void deleteEmployeeList (tEmployeeList *EmployeeList)
{
	tNodeEmployee employee;
	while (!isEmptyEmployeeList (*EmployeeList))
	{
		employee = (tNodeEmployee)(*EmployeeList)->head;
		(*EmployeeList)->head = employee->sig;
		free (employee->tEmployee->nombre);
		free (employee->tEmployee->apellidos);
		free (employee->tEmployee->puesto);
		free (employee->tEmployee->anho);
		free (employee->tEmployee);
		free (employee);
	}
	free (*EmployeeList);
	(*EmployeeList) = NULL;
}


int addEmployeeToList (tEmployeeList EmployeeList, tEmployee employee)
{

	tNodeEmployee tmp = (tNodeEmployee) malloc (sizeof (struct tSNodeEmployee));

	if (tmp == NULL)
		return 1;

	tmp->tEmployee = employee;
	tmp->sig = NULL;

	if (isEmptyEmployeeList (EmployeeList))
	{
		EmployeeList->head = tmp;
	} else
	{
		EmployeeList->tail->sig = tmp;
	}
	EmployeeList->tail = tmp;
}


void removeFromEmployeeListIndex (tEmployeeList EmployeeList, int index)
{
	tNodeEmployee aux = EmployeeList->head;
	int count = 1;

	if ((aux->sig == NULL))
	{
		if (index == 0){
			EmployeeList->head = NULL;
			EmployeeList->tail = NULL;
		}
		return;
	}

	if (index == 0)
	{
		EmployeeList->head = EmployeeList->head->sig;
		return;
	}

	while ((aux->sig != NULL) && (count < index))
	{
		aux = aux->sig;
		count ++;
	}
	tNodeEmployee employee;
	employee = aux->sig;
	aux->sig = (aux->sig)->sig;
	free (employee->tEmployee->nombre);
	free (employee->tEmployee->apellidos);
	free (employee->tEmployee->puesto);
	free (employee->tEmployee->anho);
	free (employee->tEmployee);
	free (employee);
}

int lengthEmployeeList (tEmployeeList EmployeeList)
{
	tNodeEmployee aux = EmployeeList->head;
	int count = 0;

	while (aux != NULL)
	{
		aux = aux->sig;
		count ++;
	}
	return count;
}


tEmployee getEmployeeFromListByIndex (tEmployeeList EmployeeList, int index)
{

	tNodeEmployee aux = EmployeeList->head;
	int count = 0;

	while ((aux != NULL) && (count < index))
	{
		aux = aux->sig;
		count ++;
	}

	if (aux == NULL)
		return NULL;
	return aux->tEmployee;
}

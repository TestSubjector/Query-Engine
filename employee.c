#include "employee.h"

tEmployee createEmployee (char *ename, int eage, char *eaddress, int salary, int indexNumber)
{
	tEmployee tmp = (tEmployee) malloc (sizeof (struct tEEmployee));

	if (tmp == NULL)
		return NULL;

	tmp->ename = (char*) malloc (sizeof (char) * strlen (ename)+1);
	strcpy (tmp->ename, ename);
	tmp->eage = eage;

	tmp->eaddress = (char*) malloc (sizeof (char) * strlen (eaddress)+1);
	strcpy (tmp->eaddress, eaddress);

	tmp->salary = salary;
	tmp->indexNumber = indexNumber;
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
		free (employee->tEmployee->ename);
		free (employee->tEmployee->eaddress);
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
	tNodeEmployee auxillary = EmployeeList->head;
	int count = 1;

	if ((auxillary->sig == NULL))
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

	while ((auxillary->sig != NULL) && (count < index))
	{
		auxillary = auxillary->sig;
		count ++;
	}
	tNodeEmployee employee;
	employee = auxillary->sig;
	auxillary->sig = (auxillary->sig)->sig;
	free (employee->tEmployee->ename);
	free (employee->tEmployee->eaddress);
	free (employee->tEmployee);
	free (employee);
}

int lengthEmployeeList (tEmployeeList EmployeeList)
{
	tNodeEmployee auxillary = EmployeeList->head;
	int count = 0;

	while (auxillary != NULL)
	{
		auxillary = auxillary->sig;
		count ++;
	}
	return count;
}


tEmployee getEmployeeFromListByIndex (tEmployeeList EmployeeList, int index)
{

	tNodeEmployee auxillary = EmployeeList->head;
	int count = 0;

	while ((auxillary != NULL) && (count < index))
	{
		auxillary = auxillary->sig;
		count ++;
	}

	if (auxillary == NULL)
		return NULL;
	return auxillary->tEmployee;
}

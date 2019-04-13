 #include "department.h"

tDepartment createDepartment (int dnum, char *dname, char *dlocation, int indexNumber)
{
	tDepartment tmp = (tDepartment) malloc (sizeof (struct tEDepartment));

	if (tmp == NULL)
		return NULL;

	tmp->dname = (char*) malloc (sizeof (char) * strlen (dname)+1);
	strcpy (tmp->dname, dname);
	tmp->dnum = dnum;

	tmp->dlocation = (char*) malloc (sizeof (char) * strlen (dlocation)+1);
	strcpy (tmp->dlocation, dlocation);
	tmp->indexNumber = indexNumber;
	// printf("\n &&&&& %d", indexNumber);
	return tmp;
}


tDepartmentList createDepartmentList ()
{
	tDepartmentList tmp = (tDepartmentList) malloc (sizeof (struct tEDepartmentList));
	if (tmp == NULL)
		return NULL;

	tmp->head = NULL;
	tmp->tail = NULL;
	return tmp;

}

int isEmptyDepartmentList (tDepartmentList DepartmentList)
{
	if (DepartmentList->head == NULL)
		return 1;
	return 0;
}


void deleteDepartmentList (tDepartmentList *DepartmentList)
{
	tNodeDepartment Department1;
	while (!isEmptyDepartmentList (*DepartmentList))
	{
		Department1 = (tNodeDepartment)(*DepartmentList)->head;
		(*DepartmentList)->head = Department1->sig;
		free (Department1->tDepartment->dname);
		free (Department1->tDepartment->dlocation);
		free (Department1->tDepartment);
		free (Department1);
	}
	free (*DepartmentList);
	(*DepartmentList) = NULL;
}


int addDepartmentToList (tDepartmentList DepartmentList, tDepartment Department1)
{

	tNodeDepartment tmp = (tNodeDepartment) malloc (sizeof (struct tSNodeDepartment));
	if (tmp == NULL)
		return 1;

	tmp->tDepartment = Department1;
	tmp->sig = NULL;

	if (isEmptyDepartmentList (DepartmentList))
	{
		DepartmentList->head = tmp;
	} else
	{
		DepartmentList->tail->sig = tmp;
	}
	DepartmentList->tail = tmp;
}


void removeFromDepartmentListIndex (tDepartmentList DepartmentList, int index)
{
	tNodeDepartment auxillary = DepartmentList->head;
	int count = 1;

	if ((auxillary->sig == NULL))
	{
		if (index == 0){
			DepartmentList->head = NULL;
			DepartmentList->tail = NULL;
		}
		return;
	}

	if (index == 0)
	{
		DepartmentList->head = DepartmentList->head->sig;
		return;
	}

	while ((auxillary->sig != NULL) && (count < index))
	{
		auxillary = auxillary->sig;
		count ++;
	}
	tNodeDepartment Department1;
	Department1 = auxillary->sig;
	auxillary->sig = (auxillary->sig)->sig;
	free (Department1->tDepartment->dname);
	free (Department1->tDepartment->dlocation);
	free (Department1->tDepartment);
	free (Department1);
}

int lengthDepartmentList (tDepartmentList DepartmentList)
{
	tNodeDepartment auxillary = DepartmentList->head;
	int count = 0;

	while (auxillary != NULL)
	{
		auxillary = auxillary->sig;
		count ++;
	}
	return count;
}


tDepartment getDepartmentFromListByIndex (tDepartmentList DepartmentList, int index)
{

	tNodeDepartment auxillary = DepartmentList->head;
	int count = 0;

	while ((auxillary != NULL) && (count < index))
	{
		auxillary = auxillary->sig;
		count ++;
	}

	if (auxillary == NULL)
		return NULL;
	return auxillary->tDepartment;
}

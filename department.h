#ifndef Department
#define Department

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct tEDepartment
{
	int indexNumber;
	int dnum;
	char *dname;
	char *dlocation;
};

typedef struct tEDepartment *tDepartment;

struct tSNodeDepartment
{
	tDepartment tDepartment;
	struct tSNodeDepartment *sig;
};

typedef struct tSNodeDepartment *tNodeDepartment;

struct tEDepartmentList
{
	tNodeDepartment head;
	tNodeDepartment tail;
};

typedef struct tEDepartmentList *tDepartmentList;

tDepartment createDepartment (int dnum, char *dname, char *dlocation, int indexNumber);

tDepartmentList createDepartmentList();

int isEmptyDepartmentList (tDepartmentList DepartmentList);

int addDepartmentToList (tDepartmentList DepartmentList, tDepartment Department1);

void deleteDepartmentList (tDepartmentList *DepartmentList);

void removeFromDepartmentListIndex (tDepartmentList DepartmentList, int index);

int lengthDepartmentList (tDepartmentList DepartmentList);

tDepartment getDepartmentFromListByIndex (tDepartmentList DepartmentList, int index);

#endif

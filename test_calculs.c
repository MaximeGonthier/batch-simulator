#include <stdio.h>
//~ #include <string.h>
//~ #include <stdint.h>
//~ #include <limits.h>
//~ #include <stdlib.h>
#include <stdbool.h>
//~ #include <math.h>
//~ #include <time.h>
//~ #include <limits.h>

bool is_true()
{
	printf("Return true.\n");
	return true;
}

int main()
{
	int a1 = 1234;
	int b1 = 43;
	printf("%d\n", a1/b1);
	double a2 = 1234;
	double b2 = 43;
	printf("%f\n", a2/b2);
	float a3 = 1234;
	float b3 = 43;
	printf("%f\n", a3/b3);
	
	int i = 0;
	for (i = 0; i < 20; i++)
	{
		
	}
	printf("i: %d\n", i);
	
	int c = 2;

	if (c == 1 && is_true() == true)
	{
		printf("Dans le if.\n");
	}
	else
	{
		printf("Dans le else.\n");
	}

	int d = 1;

	if (d == 1 || is_true() == true)
	{
		printf("dans le if du OU\n");
	}
	else
	{
		printf("dans le else du OU\n");
	}

	return 1;
}

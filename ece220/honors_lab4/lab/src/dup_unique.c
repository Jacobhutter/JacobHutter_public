#include <stdio.h>
#include <stdlib.h>

/*
 * find_duplicate
 *   DESCRIPTION: finds the duplicate character in the string
 *   INPUTS: arr -- array
 *           len -- length of array
 *   OUTPUTS: none
 *   RETURN VALUE: duplicated character, else 0
 *   SIDE EFFECTS: none
 */
char find_duplicate(char arr[], int len)
{
  int i,k;//ptr;
	//*ptr = &arr; // ptr points to the the address of the first element in arr
	for(i=0;i<=len;i++)
	 {
	  for(k=i+1;k<=len;k++)
	   { if(arr[k]==arr[i])
		return arr[k];
	   }
		 	//*ptr++;
	 }


    return 0;
}

/*
 * find_unique
 *   DESCRIPTION: finds the unique character in the string
 *   INPUTS: arr -- array
 *           len -- length of array
 *   OUTPUTS: none
 *   RETURN VALUE: unique character, else 0
 *   SIDE EFFECTS: none
 */
char find_unique(char arr[], int len)
{	int i,k;	
  for(i=0;i<=len;i++)
   {if(arr[i]!=0)
    {for(k=i+1;k<=len;k++)
     { if(arr[k]==0)
	break;

       if(arr[k]==arr[i])
	{
         arr[k]=0;
	 arr[i]=0;
	 break;
	}
      }
     }
    }
   for(i=0;i<=len;i++)
    {
	if(arr[i]!=0)
	 return arr[i];
    }

  return 0;
}

int main(int argc, char *argv[])
{
  //Checking for input
  if (argc != 3)
  {
    return 0;
  }

  //Test type
  int func_check = atoi(argv[1]);

  //Opening test file
  FILE *file = fopen(argv[2], "r");
  if (file == NULL)
  {
    return 0;
  }

  //Getting input length
  int len = 0;
  fscanf(file, "%d", &len);

  //Reading string
  char *arr = (char*)malloc((len + 1) * sizeof(char));
  fscanf(file, "%s", arr);

  //Calling correct function
  char res = 0;
  switch (func_check)
  {
    case 0:
      res = find_duplicate(arr, len);
      break;
    case 1:
      res = find_unique(arr, len);
      break;
    default:
      return 0;
  }

  //Printing output
  if (res < 0)
  {
    printf("-1\n");
  }
  else if (res == 0)
  {
    printf("0\n");
  }
  else
  {
    printf("%c\n", res);
  }

  //Freeing memory
  free(arr);

  return 0;
}
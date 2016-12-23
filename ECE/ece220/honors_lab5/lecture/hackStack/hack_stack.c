#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define USER "potok2"
#define PASSWORD "password"

#define HACKING 1

int main(int argc, char **argv);

char safeChar(char c)
{
  if (c >= 'a' && c <= 'z') return(c);
  if (c >= 'A' && c <= 'Z') return(c);
  if (c >= '0' && c <= '9') return(c);
  if (c == ' ') return(c);
  if (c == '.') return(c);
  if (c == '-') return(c);
  if (c == ',') return(c);
  if (c == '(') return(c);
  if (c == ')') return(c);
  if (c == '[') return(c);
  if (c == ']') return(c);
  if (c == '{') return(c);
  if (c == '}') return(c);
  return '@';
}

void printStack(int *p,int len)
{
  int i;
  for(i=0;i<len;i++,p++)
  {
    char c1=safeChar((char)((*p>>24)&0xff));
    char c2=safeChar((char)((*p>>16)&0xff));
    char c3=safeChar((char)((*p>>8)&0xff));
    char c4=safeChar((char)((*p)&0xff));
    printf("%p: 0x%08x %c%c%c%c\n",p,p[0],c4,c3,c2,c1);
  }
 }

int login()
{
  char password[10], username[10];
  memset(password, 'p', sizeof(char) * 10);
  memset(username, 'u', sizeof(char) * 10);

  if (HACKING)
  {
    printStack((int*)username,11);
  }

  //Getting user input
  printf("Input username: \n");
  gets(username);
  printf("Input password: \n");
  gets(password);

  if (HACKING)
  {
    printStack((int*)username,11);
  }

  //Checking if user input is correct
  if(!strcmp(username,USER) && !strcmp(password,PASSWORD))
  {
    printf("Login successful!\n");
    return 1;
  }
  
  printf("Login failed!\n");
  return 0;
}

int generateSessionKey()
{
  int key=0;
  key|=rand()&0xff<<24;
  key|=rand()&0xff<<16;
  key|=rand()&0xff<<8;
  key|=rand()&0xff;
  printf("Your new key is: %d\n",key);
  return key;
}

int main(int argc, char **argv)
{
  //Checking number of arguments
  if(argc!=1)
  {
    printf("Please input: ./hackStack <username> <password>");
  }

  //Setting a random seed
  srand(time(NULL));

  //Address of functions
  if (HACKING)
  {
    printf("Address of login: %p\n",login);
    printf("Address of generateSessionKey: %p\n",generateSessionKey);
  }

  //Getting login info and generating a random session key
  if(login())
  {
    generateSessionKey();
  }

  return 0;
}

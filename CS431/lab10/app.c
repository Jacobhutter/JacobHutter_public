#include <includes.h>
#include <p33Fxxxx.h>
#define FCY 12800000UL
#include <libpic30.h>


/*
*********************************************************************************************************
*                                                CONSTANTS
*********************************************************************************************************
*/

// control task frequency (Hz)
#define RT_FREQ 50

//setpoint parameters
#define SPEED 0.08  // tested up to .12!
#define RADIUS 350
#define CENTER_X 1650
#define CENTER_Y 1500
#define X_DIM 1
#define Y_DIM 2
#define MOTOR_X_CHAN 1
#define MOTOR_Y_CHAN 2
/*
*********************************************************************************************************
*                                                VARIABLES
*********************************************************************************************************
*/

OS_STK  AppStartTaskStk[APP_TASK_START_STK_SIZE];
OS_STK  AppLCDTaskStk[APP_TASK_START_STK_SIZE];
OS_STK  AppTouchTaskStk[APP_TASK_TOUCH_STK_SIZE];
OS_STK  AppPidTaskStk[APP_TASK_PID_STK_SIZE];

// TODO define task stacks

// control setpoint
double Xpos_set = 1800.0, Ypos_set = 900.0;

// raw, unfiltered X and Y position of the ball
CPU_INT16U Xpos, Ypos;

// filtered X and Y position of the ball
CPU_INT16U Xposf, Yposf;

CPU_INT08U select = X_DIM; // fix it

/*
*********************************************************************************************************
*                                            FUNCTION PROTOTYPES
*********************************************************************************************************
*/

static  void  AppStartTask(void *p_arg);
static  void  AppTaskCreate(void);
static  void  AppLcdTask(void);
static  void  AppTouchTask(void);
static  void  AppPidTask(void);

// TODO declare function prototypes

/*
*********************************************************************************************************
*                                                main()
*
* Description : This is the standard entry point for C code.
* Arguments   : none
*********************************************************************************************************
*/

CPU_INT16S  main (void)
{
    CPU_INT08U  err;
    BSP_IntDisAll();                                                    /* Disable all interrupts until we are ready to accept them */
    OSInit();

                                               /* Initialize "uC/OS-II, The Real-Time Kernel"              */
    OSTaskCreateExt(AppStartTask,                                       /* Create the start-up task for system initialization       */
                    (void *)0,
                    (OS_STK *)&AppStartTaskStk[0],
                    APP_TASK_START_PRIO,
                    APP_TASK_START_PRIO,
                    (OS_STK *)&AppStartTaskStk[APP_TASK_START_STK_SIZE-1],
                    APP_TASK_START_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR); 
    OSTaskNameSet(APP_TASK_START_PRIO, (CPU_INT08U *)"Start Task", &err);
    OSStart(); /* Start multitasking (i.e. give control to uC/OS-II)       */
    return (-1);                                                        /* Return an error - This line of code is unreachable       */
}


/*
*********************************************************************************************************
*                                          STARTUP TASK
*
* Description : This is an example of a startup task.  As mentioned in the book's text, you MUST
*               initialize the ticker only once multitasking has started.
*
* Arguments   : p_arg   is the argument passed to 'AppStartTask()' by 'OSTaskCreate()'.
*
* Notes       : 1) The first line of code is used to prevent a compiler warning because 'p_arg' is not
*                  used.  The compiler should not generate any code for this statement.
*               2) Interrupts are enabled once the task start because the I-bit of the CCR register was
*                  set to 0 by 'OSTaskCreate()'.
*********************************************************************************************************
*/


static  void  AppStartTask (void *p_arg)
{
    	(void)p_arg;

    BSP_Init();                                                         /* Initialize BSP functions                                 */
    OSStatInit();                                                       /* Determine CPU capacity                                   */
    DispInit();
    DispClrScr();
    //initialize touchscreen and motors
    touch_init(); // init touch screeen
    motor_init(); // init servo motors
    
    AppTaskCreate();
    /* Create additional user tasks                             */
    while (DEF_TRUE) {
	    OSTimeDlyHMSM(0, 0, 5, 0);
    }
}


/*
*********************************************************************************************************
*                              CREATE ADDITIONAL APPLICATION TASKS
*********************************************************************************************************
*/
int counter = 0;
static  void  AppTaskCreate (void)
{       
        CPU_INT08U  err;
        // LCD updating Every 1 Second
        OSTaskCreateExt(AppLcdTask,                                       
                    (void *)0,
                    (OS_STK *)&AppLCDTaskStk[0],
                    APP_TASK_LCD_PRIO,
                    APP_TASK_LCD_PRIO,
                    (OS_STK *)&AppLCDTaskStk[APP_TASK_START_STK_SIZE-1],
                    APP_TASK_START_STK_SIZE,
                    (void *) 0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
        OSTaskNameSet(APP_TASK_LCD_PRIO, (CPU_INT08U *)"LCD Task", &err);

        OSTaskCreateExt(AppPidTask,
                    (void *)0,
                    (OS_STK *)&AppPidTaskStk[0],
                    APP_TASK_PID_PRIO,
                    APP_TASK_PID_PRIO,
                    (OS_STK *)&AppPidTaskStk[APP_TASK_PID_STK_SIZE-1],
                    APP_TASK_PID_STK_SIZE,
                    (void *) 0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
        OSTaskNameSet(APP_TASK_PID_PRIO, (CPU_INT08U *)"PID Task", &err);

        /*Create touch screen task*/
        OSTaskCreateExt(AppTouchTask,
                    (void *)0,
                    (OS_STK *)&AppTouchTaskStk[0],
                    APP_TASK_TOUCH_PRIO,
                    APP_TASK_TOUCH_PRIO,
                    (OS_STK *)&AppTouchTaskStk[APP_TASK_TOUCH_STK_SIZE-1],
                    APP_TASK_TOUCH_STK_SIZE,
                    (void *) 0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
        OSTaskNameSet(APP_TASK_TOUCH_PRIO, (CPU_INT08U *)"Touch Task", &err);


	// TODO create tasks
}
int ledLit = 4;
int secondsSinceReset = 0;
CPU_INT08U timeString[5] = {0,0,0,0,'\0'};
CPU_INT08U xPosString[5] = {0,0,0,0,'\0'};
CPU_INT08U yPosString[5] = {0,0,0,0,'\0'};

static void numToString(int num, CPU_INT08U *string){
    string[3] = num%10 + 48;
    string[2] = (num/10)%10 + 48;
    string[1] = (num/100)%10 + 48;
    string[0] = (num/1000)%10 + 48;
    return;
}

static void setLEDS(){
    switch(ledLit) {
        case 0:
            CLEARLED(LED5_PORT);
            SETLED(LED1_PORT);
            break;
        case 1:
            CLEARLED(LED1_PORT);
            SETLED(LED2_PORT);
            break;
        case 2:
            CLEARLED(LED2_PORT);
            SETLED(LED3_PORT);
            break;
        case 3:
            CLEARLED(LED3_PORT);
            SETLED(LED4_PORT);
            break;
        case 4:
            CLEARLED(LED4_PORT);
            SETLED(LED5_PORT);
    }
    return;
}

static void AppLcdTask (void){
    /*Initial Print to screen*/
    DispStr(0,0, (CPU_INT08U *)"Save the Whales");
    DispStr(1,0, (CPU_INT08U *)"Seconds Since Reset: ");
    DispStr(1,20, timeString);

    // 1 second task
    while (DEF_TRUE) {
	    OSTimeDlyHMSM(0, 0, 1, 0);
            ledLit = (++ledLit)%5;
            ++secondsSinceReset;
            numToString(secondsSinceReset, timeString); //needs to be fixed
            setLEDS();
            DispStr(2,0, timeString);
            //DispStr(2,4, "        ");
            /*Display X and Y position*/
            numToString((int)Xposf, xPosString);
            numToString((int)Yposf, yPosString);

            DispStr(3,0, "X: ");
            DispStr(3,3, xPosString);
            //DispStr(3,7, "        ");
            DispStr(4,0, "Y: ");
            DispStr(4,3, yPosString);
            //DispStr(4,7, "        ");


        }
}

double x_pos, y_pos, x_prev, y_prev;
double x_deriv, x_int, y_deriv, y_int;

double Kp_x = 0.95, Kd_x = 0.30, Ki_x = 0.02;
double Kp_y = 0.95, Kd_y = 0.30, Ki_y = 0.02;

/*
 double Kp_x = 0.75, Kd_x = 0.22, Ki_x = 0.02;
double Kp_y = 0.75, Kd_y = 0.22, Ki_y = 0.02;
 */

int pidX_controller(double Xp) {
  double pid;
  // TODO: Implement PID X
    x_pos = Xp - Xpos_set;
    x_deriv = (Xp -  x_prev) / 0.05;
    x_int -= (Xpos_set - Xp) * 0.05;

   pid = (-Kp_x * (float)x_pos - Kd_x * x_deriv - Ki_x * x_int);
   x_prev = Xp;

  return (int)pid;
}


int pidY_controller(double Yp) {
    double pid;
    // TODO: Implement PID Y
    y_pos = Yp - Ypos_set;
    y_deriv = (Yp -  y_prev) / 0.05;
    y_int -= (Ypos_set - Yp) * 0.05;

    pid = (-Kp_y * (float)y_pos - Kd_y * y_deriv - Ki_y * y_int);

    y_prev = Yp;
  return (int)pid;
}

int force_low = -2000;
int force_high = 2000;
uint16_t findMotorDuty(int force){
    if(force < force_low)
        force = force_low;
    if(force > force_high)
        force = force_high;

    unsigned int pos_force = force + abs(force_low);
    float ratio = (float)pos_force/(force_high-force_low);
    ratio = (ratio*(2.0-1.0) + 1.0); //
    ratio = (ratio)*1000;

    return (uint16_t)ratio;

}

static void AppPidTask(void){
     int pidX, pidY;
     uint32_t tick = 0;
     uint16_t duty_us_x, duty_us_y;
     while (DEF_TRUE) {
     OSTimeDlyHMSM(0, 0, 0, 50);
      Xpos_set = CENTER_X + RADIUS * cos(tick * SPEED);
      Ypos_set = CENTER_Y + RADIUS * sin(tick * SPEED);
      tick += 2;

      pidX = pidX_controller((double)Xposf);
      pidY = pidY_controller((double)Yposf);

      // TODO: Convert PID to motor duty cycle (900.0-2100 us)
      duty_us_x = findMotorDuty(pidX);
      duty_us_y = findMotorDuty(pidY);

      // setMotorDuty is a wrapper function that calls your motor_set_duty
      // implementation in flexmotor.c. The 2nd parameter expects a value
      // between 900-2100 us
      motor_set_duty(MOTOR_X_CHAN, duty_us_x);
      motor_set_duty(MOTOR_Y_CHAN, duty_us_y);
     }
}

CPU_INT16U xPositions [5] = {1650,1650,1650,1650,1650};
CPU_INT16U yPositions [5] = {1550,1550,1550,1550,1550};

CPU_INT16U xOutPositions [5] = {1650,1650,1650,1650,1650};
CPU_INT16U yOutPositions [5] = {1550,1550,1550,1550,1550};


double coefs [5] = {0.3913, 0.6381, 0.0789, -0.1541, 0.0415};

double A[2] = {0.3695, 0.1958};
double B[3] = {0.3913, 0.7827, 0.3913};


void butter(CPU_INT16U *positions, CPU_INT16U *outPositions){
    int j;
    double output = 0;
    /*
    for (j = 0; j < 5; ++j)
        output += positions[j] * coefs[4-j]; //ECB: should be checked

    */
    output = B[0]*positions[0] + B[1]*positions[1] + B[2]*positions[2]
            - A[0]*outPositions[0] - A[1]*outPositions[1];
    if (select == X_DIM)
        Yposf = (CPU_INT16U) output;
    else
        Xposf = (CPU_INT16U) output;
}

uint16_t samples[5];
uint16_t * sort_me(uint16_t * arr){
    uint8_t i = 0,j=0;
    uint16_t temp;
    for(j = 0; j<5; j++){
        for(i = 0; i<4; i++){
            if(arr[i] > arr[i+1]){
                temp = arr[i+1];
                arr[i+1] = arr[i];
                arr[i] = temp;
            }
        }
    }
    return arr;
}

CPU_INT16U x_samples[5];
CPU_INT16U y_samples[5];
static  void  AppTouchTask(void){
    CPU_INT16U *cur_pos_array, *out_pos_array;
    int i = 0;
    while (DEF_TRUE) {
        OSTimeDlyHMSM(0, 0, 0, 10);
        if (select == X_DIM){
            for (i = 0; i < 5; ++i)
                x_samples[i] = SampleADC_X();
            sort_me(x_samples);
            Xpos = x_samples[2];
            select = Y_DIM;
            touch_select_dim(select);
            cur_pos_array = xPositions;
            out_pos_array = xOutPositions;
        } else {
            for (i = 0; i < 5; ++i)
                y_samples[i] = SampleADC_Y();
            sort_me(y_samples);
            Ypos = y_samples[2];
            select = X_DIM;
            touch_select_dim(select);
            cur_pos_array = yPositions;
            out_pos_array = yOutPositions;
        }
        //Should filter in this routine, might need to take out the 10 millisec delay in touch_select_dim
        //add new value to array of positions
        
        for (i = 0; i < 4; i++){
            cur_pos_array[i+1] = cur_pos_array[i];
        }
        
        
        if (select ==Y_DIM){
            cur_pos_array [0] = Xpos;
            //filter
            butter(cur_pos_array, out_pos_array);

        }else {
            cur_pos_array[0] = Ypos;
            //filter
            butter(cur_pos_array, out_pos_array);
        }

        for (i = 0; i < 4; i++){
            out_pos_array[i+1] = out_pos_array[i];
        }
        if (select ==Y_DIM){
            out_pos_array [0] = Xposf;


        }else {
            out_pos_array[0] = Yposf;

        }

    }

}
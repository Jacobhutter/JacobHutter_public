import state as s
import random
import numpy as np

Gameboard = np.zeros((12, 12, 2, 3, 12))

def assign_reward():
    return 0

def get_move(discrete_paddle_pos, ball_pos, ball_speed):
    ball_x = (ball_pos[0], ball_pos[2])
    ball_y = (ball_pos[1], ball_pos[3])
    ballxspeed = ball_speed[0]
    ballyspeed = ball_speed[1]

    if ballxspeed < 0: # discretize x speed
        ballxspeed = -1
    else:
        ballxspeed = 1

    if abs(ballyspeed) < 7.5: # discretize y speed
        ballyspeed = 0
    elif ballyspeed > 0:
        ballyspeed = 1
    else:
        ballyspeed = -1

    if ball_x[0] >= 500:
        print "passed wall!"

    return random.randrange(-1,2)

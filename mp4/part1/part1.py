import state as s
import random
import numpy as np

Gameboard = np.zeros((12, 12))

def get_move(discrete_paddle_pos, ball_pos, ball_speed):
    print discrete_paddle_pos, ball_pos, ball_speed
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
    print ballxspeed, ballyspeed
    return random.randrange(-1,2)

Pong = s.State()

print Pong.get_tuple

print Pong.action(2) # move up

print Pong.action(1) # move down

print Pong.action(0) # nothing

print Pong.action(3)

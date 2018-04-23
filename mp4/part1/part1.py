import state
import random
import numpy as np
import math

gamma = 0.1
alpha = 0.1
hit_wall = 0

scoreboard = np.zeros((12, 12, 2, 3, 12))

def assign_reward(cur_state, hit_wall, hit_paddle):
    cur_state = cur_state.get_tuple()
    prev_reward = scoreboard[(cur_state)]
    prev_reward *= (1-alpha)



    return 0

def get_cur_state(ballx, bally, xspeed, yspeed, paddle_pos):
    return state.State(ballx, bally, xspeed, yspeed, paddle_pos)

def get_move(discrete_paddle_pos, ball_pos, ball_speed, hit_paddle):
    ball_x = (ball_pos[0], ball_pos[2])
    ball_y = (ball_pos[1], ball_pos[3])
    discrete_ball_x = math.floor((12* (ball_x[0] + 7.5) )/(500- 15) )
    discrete_ball_y = math.floor((12* (ball_y[0] + 7.5) )/(500- 15) )
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

    cur_state = get_cur_state(discrete_ball_x, discrete_ball_y, ballxspeed, ballyspeed, discrete_paddle_pos)
    if ball_x[0] >= 500:
        hit_wall = -1;
    else:
        hit_wall = 0

    move = assign_reward(cur_state, hit_wall, hit_paddle)

    return random.randrange(-1,2)

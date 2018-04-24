import state
import random
import numpy as np
import math

gamma = 0.5
alpha = 10
hit_wall = 0



def assign_reward(cur_state, hit_wall, hit_paddle, scoreboard):
    cur_state = cur_state.get_tuple()
    cur_state = (min(int(cur_state[0]), 11), min(int(cur_state[1]), 11), int(cur_state[2]), int(cur_state[3]), int(cur_state[4]))

    prev_reward = scoreboard[cur_state[0]][cur_state[1]][cur_state[2]][cur_state[3]][cur_state[4]]
    prev_reward *= (1-alpha)
    neighbor_up = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], min(cur_state[4] + 1, 11)]
    neighbor_down = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], max(cur_state[4] - 1, 0)]
    cur = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], cur_state[4]]
    print neighbor_up, cur, neighbor_down
    max_neighbor = max(neighbor_up, neighbor_down)
    learned_value = (hit_wall + hit_paddle) + gamma * max_neighbor
    scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], cur_state[4]] = prev_reward + alpha * learned_value


    if(cur == neighbor_up and cur == neighbor_down):
        print "stay"
        return 0

    if(neighbor_up > cur and neighbor_up > neighbor_down):
        print "up"
        return 1

    if(neighbor_down > neighbor_up and neighbor_down > cur):
        print "down"
        return -1

    if(neighbor_up == neighbor_down and neighbor_up > cur):
        print "random"
        return random.randrange(-1, 2)


    print "stay"
    return 0


def get_cur_state(ballx, bally, xspeed, yspeed, paddle_pos):
    return state.State(ballx, bally, xspeed, yspeed, paddle_pos)

def get_move(discrete_paddle_pos, ball_pos, ball_speed, hit_paddle, scoreboard):
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
        cur_state.change_ball_x(11)
    else:
        hit_wall = 0

    if ball_y[0] >= 500:
        cur_state.change_ball_y(11)

    move = assign_reward(cur_state, hit_wall, hit_paddle, scoreboard)

    return move

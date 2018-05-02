# https://github.com/kidscancode/intro-python-code/blob/master/pong%20game.py
from Tkinter import *
import random
import state
import math
# import part1
import state as s
import numpy as np

# Define ball properties and functions
class Ball:
    def __init__(self, canvas, color, size, paddle):
        self.canvas = canvas
        self.paddle = paddle
        self.id = canvas.create_oval(10, 10, size, size, fill=color)
        self.canvas.move(self.id, 250, 250)
        self.xspeed = 15 # initial is .03 * 500
        self.yspeed = 5 # initial is .01 * 500
        self.hit_right = False
        self.score = 0

    def draw(self):
        pos = self.canvas.coords(self.id)
        if pos[1] <= 0:
            self.yspeed = -self.yspeed
        if pos[3] >= 500:
            self.yspeed = -self.yspeed
        if pos[0] <= 0:
            self.xspeed = -self.xspeed
        if self.hit_paddle(pos) == True:
            self.yspeed = self.yspeed + 15 * random.randrange(-1, 2)

            if self.yspeed < -500:
                self.yspeed = -500
            if self.yspeed > 500:
                self.yspeed = 500

            self.xspeed = -self.xspeed + 7.5 * random.randrange(-1, 2)
            if self.xspeed <= 0 and self.xspeed > -15:
                self.xspeed = -15
            if self.xspeed > 0 and self.xspeed < 15:
                self.xspeed = 15

            if self.xspeed < -500:
                self.xspeed = -500
            if self.xspeed > 500:
                self.xspeed = 500


            self.score += 1
        if pos[2] >= 500 and self.hit_paddle(pos) == False:
            self.hit_right = True

        self.canvas.move(self.id, self.xspeed, self.yspeed)
    def hit_paddle(self, pos):
        paddle_pos = self.canvas.coords(self.paddle.id)

        # first check we didnt hit on edge
        if((pos[1] <= paddle_pos[1] and pos[3] >= paddle_pos[3]) or (pos[3] <= paddle_pos[3] and pos[1] >= paddle_pos[1])) and pos[0] >= paddle_pos[0]:
            return 0

        # then check if we hit in general
        if pos[2] >= paddle_pos[0] and pos[3] >= paddle_pos[1] and pos[1] <= paddle_pos[3]:
            return 1

        if pos[2] >= paddle_pos[0] and pos[0] <= paddle_pos[2]:
            if pos[3] >= paddle_pos[1] and pos[3] <= paddle_pos[3]:
                return 1
        return 0

    def reset(self, canvas, color, size, paddle):
        pos = self.canvas.coords(self.paddle.id)

        self.canvas.move(self.id, -pos[0], -pos[1])
        ball.draw()
        self.canvas.move(self.id, 250, 250)
        self.xspeed = 15 # initial is .03 * 500
        self.yspeed = 5 # initial is .01 * 500
        self.hit_right = False
        self.score = 0

# Define paddle properties and functions
class Paddle:
    def __init__(self, canvas, color):
        self.canvas = canvas
        self.id = canvas.create_rectangle(0,0, 10, 100, fill=color)
        self.canvas.move(self.id, 490, 200)
        self.yspeed = 0
        #self.canvas.bind_all('<KeyPress-Up>', self.move_up)
        #self.canvas.bind_all('<KeyPress-Down>', self.move_down)

    def draw(self):
        self.canvas.move(self.id, 0, self.yspeed)
        self.yspeed = 0
        pos = self.canvas.coords(self.id)
        if pos[1] <= 0:
            self.yspeed = 0
        if pos[1] >= 400:
            self.yspeed = 0

    def move_up(self):
        pos = self.canvas.coords(self.id)
        if pos[1] > 0:
            self.yspeed = -20
    def move_down(self):
        pos = self.canvas.coords(self.id)
        if pos[1] < 400:
            self.yspeed = 20
    def reset(self, canvas, color):
        pos = self.canvas.coords(self.id)
        self.canvas.move(self.id, 0, 200-pos[1])
        self.yspeed = 0

# Create window and canvas to draw on


gamma = 0.8
hit_wall = 0
scoreboard = np.zeros((12, 12, 2, 3, 12))
hitmask = np.zeros((12, 12, 2, 3, 12))
path = []

def calc_alpha(cur_state):
    return 2000/(2000 + hitmask[cur_state[0]][cur_state[1]][cur_state[2]][cur_state[3]][cur_state[4]])

def assign_reward(cur_state, hit_wall, hit_paddle, path):

    cur_state = cur_state.get_tuple()
    cur_state = (min(int(cur_state[0]), 11), min(int(cur_state[1]), 11), int(cur_state[2]), int(cur_state[3]), int(cur_state[4]))
    alpha = calc_alpha(cur_state)
    hitmask[cur_state[0]][cur_state[1]][cur_state[2]][cur_state[3]][cur_state[4]] += 1
    prev_reward = scoreboard[cur_state[0]][cur_state[1]][cur_state[2]][cur_state[3]][cur_state[4]]
    prev_reward *= (1-alpha)
    neighbor_up = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], min(cur_state[4] + 1, 11)]
    neighbor_down = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], max(cur_state[4] - 1, 0)]


    neighbor_right = scoreboard[min(cur_state[0] + 1, 11), cur_state[1], cur_state[2], cur_state[3], cur_state[4]]
    neighbor_left = scoreboard[max(cur_state[0] - 1, 11), cur_state[1], cur_state[2], cur_state[3], cur_state[4]]


    cur = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], cur_state[4]]
    max_neighbor = max(neighbor_up, neighbor_down)
    learned_value = (hit_wall + hit_paddle) + gamma * max_neighbor
    scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], cur_state[4]] = prev_reward + alpha * learned_value
    if hit_wall or hit_paddle:
        for i in range(len(path)):
            s = path[i]
            scoreboard[s[0], s[1], s[2], s[3], s[4]] = prev_reward + alpha * learned_value
        path = []
    else:
        path.append(cur_state)



    if(cur == neighbor_up and cur == neighbor_down):
        if cur_state[1] == cur_state[4]:
            return 0, prev_reward + alpha * learned_value
        elif cur_state[1] < cur_state[4]:
            return 1, prev_reward + alpha * learned_value
        else:
            return -1, prev_reward + alpha * learned_value

    if(neighbor_up > cur and neighbor_up > neighbor_down):
        return 1, prev_reward + alpha * learned_value

    if(neighbor_down > neighbor_up and neighbor_down > cur):
        return -1, prev_reward + alpha * learned_value

    if(neighbor_up == neighbor_down and neighbor_up > cur):
        if cur_state[1] == cur_state[4]:
            return 0, prev_reward + alpha * learned_value
        elif cur_state[1] < cur_state[4]:
            return 1, prev_reward + alpha * learned_value
        else:
            return -1, prev_reward + alpha * learned_value

    return 0, prev_reward + alpha * learned_value


def get_cur_state(ballx, bally, xspeed, yspeed, paddle_pos):
    return state.State(ballx, bally, xspeed, yspeed, paddle_pos)

def get_move(discrete_paddle_pos, ball_pos, ball_speed, hit_paddle, path):
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

    move, reward = assign_reward(cur_state, hit_wall, hit_paddle, path)

    return move, reward

def get_move_sarsa(discrete_paddle_pos, ball_pos, ball_speed, hit_paddle, scoreboard, path):
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

    move, reward= sarsa_method(cur_state, hit_wall, hit_paddle, scoreboard, path)

    return move, reward

def sarsa_method(cur_state, hit_wall, hit_paddle, scoreboard, path):
    # Q(s, a) = Q(s, a) + alpha[r + gamma * Q(s+1, a+1) - Q(s, a)]
    cur_state = cur_state.get_tuple()
    cur_state = (min(int(cur_state[0]), 11), min(int(cur_state[1]), 11), int(cur_state[2]), int(cur_state[3]), int(cur_state[4]))
    
    prev_reward = scoreboard[cur_state[0]][cur_state[1]][cur_state[2]][cur_state[3]][cur_state[4]]
    neighbor_up = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], min(cur_state[4] + 1, 11)]
    neighbor_down = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], max(cur_state[4] - 1, 0)]
    
    cur = scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], cur_state[4]]
    alpha = calc_alpha(cur_state)
    max_neighbor = max(neighbor_up, neighbor_down) # Q(s+1, a+1)
    learned_value = (hit_wall + hit_paddle) + gamma * max_neighbor - prev_reward
    
    scoreboard[cur_state[0], cur_state[1], cur_state[2], cur_state[3], cur_state[4]] = prev_reward + alpha * learned_value
    if hit_wall or hit_paddle:
        for i in range(len(path)):
            s = path[i]
            scoreboard[s[0], s[1], s[2], s[3], s[4]] = prev_reward + alpha * learned_value
        path = []
    else:
        path.append(cur_state)
    
    if(cur == neighbor_up and cur == neighbor_down):
        if cur_state[1] == cur_state[4]:
            return 0, prev_reward + alpha * learned_value
        elif cur_state[1] < cur_state[4]:
            return 1, prev_reward + alpha * learned_value
        else:
            return -1, prev_reward + alpha * learned_value

    if(neighbor_up > cur and neighbor_up > neighbor_down):
        return 1, prev_reward + alpha * learned_value
    
    if(neighbor_down > neighbor_up and neighbor_down > cur):
        return -1, prev_reward + alpha * learned_value

    if(neighbor_up == neighbor_down and neighbor_up > cur):
        if cur_state[1] == cur_state[4]:
            return 0, prev_reward + alpha * learned_value
        elif cur_state[1] < cur_state[4]:
            return 1, prev_reward + alpha * learned_value
    else:
        return -1, prev_reward + alpha * learned_value

    return 0, prev_reward + alpha * learned_value


# #####################################################################################
tk = Tk()
tk.title("AI Pong")
canvas = Canvas(tk, width=500, height=500, bd=0, bg='white')
canvas.pack()
label = canvas.create_text(5, 5, anchor=NW, text="Score: 0" + "\nGames: 0" + "\nHigh Score: 0")
#tk.update()
paddle = Paddle(canvas, 'black')
ball = Ball(canvas, 'red', 25, paddle)
# Animation loop
g = 0
hs = 0
reward = 0
mean_episode_array = []
games_array = []
score_array = []
trials = 0
#while g <= 100:
#    while ball.hit_right == False:
#        ball.draw()
#        paddle.draw()
#        if ball.score > hs:
#            hs = ball.score
#        canvas.itemconfig(label, text="Score: "+str(ball.score) + "\nGames:  " + str(g) + "\nHigh Score: " + str(hs))
#        #tk.update_idletasks()
#        #tk.update()
#        discrete_paddle = math.floor(12 * paddle.canvas.coords(paddle.id)[1] / (500 - 100))
#        if paddle.canvas.coords(paddle.id)[1] == 400:
#            discrete_paddle = 11
#        ball_pos = ball.canvas.coords(ball.id)
#        ball_speed = (ball.xspeed, ball.yspeed)
#        move, reward_i = get_move(discrete_paddle, ball_pos, ball_speed, ball.hit_paddle(ball_pos), path)
#        reward += reward_i
#        trials += 1
#        if move > 0:
#            paddle.move_up()
#        elif move < 0:
#            paddle.move_down()
#        # time.sleep(0.05)
#    reward /= trials
#    score_array.append(ball.score)
#    games_array.append(g)
#    mean_episode_array.append(reward)
#
#    g += 1
#    print g, ball.score
#    paddle.reset(canvas, 'black')
#    paddle.draw()
#    ball.canvas.coords(ball.id, (245, 245, 260, 260))
#    ball.xspeed = 15 # initial is .03 * 500
#    ball.yspeed = 5 # initial is .01 * 500
#    ball.hit_right = False
#    ball.score = 0
#    ball.draw()
#    #canvas.delete(ball) #Deletes the rectangle
#    # tk.update()
#    # ball = Ball(canvas, 'red', 25, paddle)
#    # time.sleep(0.0)

iteration = 0

## Training
while iteration < 5000:
    while ball.hit_right == False:
        ball.draw()
        paddle.draw()
        if ball.score > hs:
            hs = ball.score
        canvas.itemconfig(label, text="Score: "+str(ball.score) + "\nGames:  " + str(g) + "\nHigh Score: " + str(hs))
#        tk.update_idletasks()
#        tk.update()
        discrete_paddle = math.floor(12 * paddle.canvas.coords(paddle.id)[1] / (500 - 100))
        if paddle.canvas.coords(paddle.id)[1] == 400:
            discrete_paddle = 11
        ball_pos = ball.canvas.coords(ball.id)
        ball_speed = (ball.xspeed, ball.yspeed)
        move, reward_i = get_move_sarsa(discrete_paddle, ball_pos, ball_speed, ball.hit_paddle(ball_pos), scoreboard, path)
        reward += reward_i
        trials += 1
        if move > 0:
            paddle.move_up()
        elif move < 0:
            paddle.move_down()
    reward /= trials
    score_array.append(ball.score)
    games_array.append(g)
    mean_episode_array.append(reward)
    print g, ball.score

    g += 1
    paddle.reset(canvas, 'black')
    paddle.draw()
    ball.canvas.coords(ball.id, (245, 245, 260, 260))
    ball.xspeed = 15 # initial is .03 * 500
    ball.yspeed = 5 # initial is .01 * 500
    ball.hit_right = False
    ball.score = 0
    ball.draw()
#    canvas.delete(ball) #Deletes the rectangle
#    tk.update()
#    ball = Ball(canvas, 'red', 25, paddle)
#    tk.update()
    iteration += 1

iteration = 0
count = 0

# Real Deal
while iteration < 200:
    while ball.hit_right == False:
        ball.draw()
        paddle.draw()
        if ball.score > hs:
            hs = ball.score
        canvas.itemconfig(label, text="Score: "+str(ball.score) + "\nGames:  " + str(g) + "\nHigh Score: " + str(hs))
        tk.update_idletasks()
        tk.update()
        discrete_paddle = math.floor(12 * paddle.canvas.coords(paddle.id)[1] / (500 - 100))
        if paddle.canvas.coords(paddle.id)[1] == 400:
            discrete_paddle = 11
        ball_pos = ball.canvas.coords(ball.id)
        ball_speed = (ball.xspeed, ball.yspeed)
        move, reward_i = get_move_sarsa(discrete_paddle, ball_pos, ball_speed, ball.hit_paddle(ball_pos), scoreboard, path)
        reward += reward_i
        trials += 1
        if move > 0:
            paddle.move_up()
        elif move < 0:
            paddle.move_down()
    reward /= trials
    score_array.append(ball.score)
    games_array.append(g)
    mean_episode_array.append(reward)

    g += 1
    paddle.reset(canvas, 'black')
    paddle.draw()
#    canvas.delete(ball) #Deletes the rectangle
#    tk.update()
#    ball = Ball(canvas, 'red', 25, paddle)
#    tk.update()
    iteration += 1

print str(count) + " out of 200 games."

f = open('data.txt', 'w')
for item in games_array:
  f.write("%s\n" % item)
f.write("\n")
for item in mean_episode_array:
  f.write("%s\n" % item)
f.write("\n")
for item in score_array:
  f.write("%s\n" % item)
f.write("\n")


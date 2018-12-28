# https://github.com/kidscancode/intro-python-code/blob/master/pong%20game.py
# Simple pong game - don't let the ball hit the bottom!
# KidsCanCode - Intro to Programming
from Tkinter import *
import random
import time
import math
import sys
import part2move
import part1
import state as s
import numpy as np

scoreboard = np.zeros((12, 12, 2, 3, 12))
path = []

# Define ball properties and functions
class Ball:
    def __init__(self, canvas, color, size, paddle):
        self.canvas = canvas
        self.paddle = paddle
        self.player = player
        self.id = canvas.create_oval(10, 10, size, size, fill=color)
        self.canvas.move(self.id, 250, 250)
        self.xspeed = 15 # initial is .03 * 500
        self.yspeed = 5 # initial is .01 * 500
        self.hit_right = False
        self.hit_left = False
        self.score = 0

    def draw(self):
        pos = self.canvas.coords(self.id)
        if pos[1] <= 0:
            self.yspeed = -self.yspeed
        if pos[3] >= 500:
            self.yspeed = -self.yspeed

        if self.hit_player(pos) == True:
            self.xspeed = -self.xspeed

        if self.hit_paddle(pos) == True:
            print "hit me"
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

        if pos[0] < 0 and self.hit_player(pos) == False:
            self.hit_left = True

        self.canvas.move(self.id, self.xspeed, self.yspeed)
    def hit_paddle(self, pos):
        paddle_pos = self.canvas.coords(self.paddle.id)
        player_pos = self.canvas.coords(self.player.id)

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

    def hit_player(self, pos):
        player_pos = self.canvas.coords(self.player.id)

        if((pos[1] <= player_pos[1] and pos[3] >= player_pos[3]) or (pos[3] <= player_pos[3] and pos[1] >= player_pos[1])) and pos[0] >= player_pos[0]:
            return 0
        # then check if we hit in general
        if pos[0] < player_pos[2] and pos[3] >= player_pos[1] and pos[1] <= player_pos[3]:
            return 1

        if pos[0] < player_pos[2] and pos[2] > player_pos[0]:
            if pos[3] >= player_pos[1] and pos[3] <= player_pos[3]:
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
    def stop(self):
	self.yspeed = 0
    def reset(self, canvas, color):
        pos = self.canvas.coords(self.id)
        self.canvas.move(self.id, 0, 200-pos[1])
        self.yspeed = 0

class Player:
    def __init__(self, canvas, color):
        self.canvas = canvas
        self.id = canvas.create_rectangle(0,0, 10, 100, fill=color)
        self.canvas.move(self.id, 0, 200)
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
    def stop(self):
	self.yspeed = 0
    def reset(self, canvas, color):
        pos = self.canvas.coords(self.id)
        self.canvas.move(self.id, 0, 200-pos[1])
        self.yspeed = 0


# Create window and canvas to draw on

tk = Tk()
tk.title("AI Pong")
canvas = Canvas(tk, width=500, height=500, bd=0, bg='white')
canvas.pack()
label = canvas.create_text(5, 5, anchor=NW, text="Score: 0" + "\nGames: 0" + "\nHigh Score: 0")
tk.update()
paddle = Paddle(canvas, 'black')
player = Player(canvas, 'black')
ball = Ball(canvas, 'red', 25, paddle)
time.sleep(1.0)
# Animation loop
g = 0
hs = 0
print "Game\t\tScore"
scores = []
while True:
    while ball.hit_right == False:
        ball.draw()
        paddle.draw()
        if ball.score > hs:
            hs = ball.score
        canvas.itemconfig(label, text="Score: "+str(ball.score) + "\nGames:  " + str(g) + "\nHigh Score: " + str(hs))
        tk.update_idletasks()
        tk.update()
        discrete_paddle = paddle.canvas.coords(paddle.id)[3] / 500 - 0.2
        ball_pos = ball.canvas.coords(ball.id)
	action = part2move.get_move(discrete_paddle, ball_pos, ball.xspeed, ball.yspeed)
	move = part1.get_move(discrete_paddle, ball_pos, (ball.xspeed, ball.yspeed), ball.hit_paddle(ball_pos) or ball.hit_player, scoreboard, path)
        if move > 0:
            paddle.move_up()
        elif move < 0:
            paddle.move_down()
	else:
	    paddle.stop()
	if action > 0:
            player.move_up()
        elif action < 0:
            player.move_down()
        else:
            player.stop()
        time.sleep(0.1)

    g += 1
    print str(g) + "\t\t" + str(ball.score)
    scores.append(ball.score)
    paddle.reset(canvas, 'black')
    paddle.draw()
    canvas.delete(ball) #Deletes the rectangle
    tk.update()
    ball = Ball(canvas, 'red', 25, paddle)
    tk.update()
    time.sleep(0.0)
    if g == 1000:
	print "Average Bounces:\t" + str(np.mean(np.asarray(scores)))
	histogram = {}
	for score in scores:
		if histogram.get(score) == None:
			histogram[score] = 1
		else:
			histogram[score] += 1
	for key in sorted(histogram):
		print str(key) + ":\t", histogram[key]
	break
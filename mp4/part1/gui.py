# https://github.com/kidscancode/intro-python-code/blob/master/pong%20game.py
# Simple pong game - don't let the ball hit the bottom!
# KidsCanCode - Intro to Programming
from Tkinter import *
import random
import time

# Define ball properties and functions
class Ball:
    def __init__(self, canvas, color, size, paddle):
        self.canvas = canvas
        self.paddle = paddle
        self.id = canvas.create_oval(10, 10, size, size, fill=color)
        self.canvas.move(self.id, 245, 100)
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
            self.yspeed = self.yspeed + 15 * random.randrange(-1, 1)

            if self.yspeed < -500:
                self.yspeed = -500
            if self.yspeed > 500:
                self.yspeed = 500

            self.xspeed = -self.xspeed + 7.5 * random.randrange(-1, 1)
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
            return False

        # then check if we hit in general
        if pos[2] >= paddle_pos[0] and pos[3] >= paddle_pos[1] and pos[1] <= paddle_pos[3]:
            return True

        if pos[2] >= paddle_pos[0] and pos[0] <= paddle_pos[2]:
            if pos[3] >= paddle_pos[1] and pos[3] <= paddle_pos[3]:
                return True
        return False

# Define paddle properties and functions
class Paddle:
    def __init__(self, canvas, color):
        self.canvas = canvas
        self.id = canvas.create_rectangle(0,0, 10, 100, fill=color)
        self.canvas.move(self.id, 490, 200)
        self.yspeed = 0
        self.canvas.bind_all('<KeyPress-Up>', self.move_up)
        self.canvas.bind_all('<KeyPress-Down>', self.move_down)

    def draw(self):
        self.canvas.move(self.id, 0, self.yspeed)
        self.yspeed = 0
        pos = self.canvas.coords(self.id)
        if pos[1] <= 0:
            self.yspeed = 0
        if pos[1] >= 400:
            self.yspeed = 0

    def move_up(self, evt):
        pos = self.canvas.coords(self.id)
        if pos[1] > 0:
            self.yspeed = -20
    def move_down(self, evt):
        pos = self.canvas.coords(self.id)
        if pos[1] < 400:
            self.yspeed = 20

# Create window and canvas to draw on
tk = Tk()
tk.title("AI Pong")
canvas = Canvas(tk, width=500, height=500, bd=0, bg='white')
canvas.pack()
label = canvas.create_text(5, 5, anchor=NW, text="Score: 0")
tk.update()
paddle = Paddle(canvas, 'black')
ball = Ball(canvas, 'red', 25, paddle)
time.sleep(1.0)
# Animation loop
while ball.hit_right == False:
    ball.draw()
    paddle.draw()
    canvas.itemconfig(label, text="Score: "+str(ball.score))
    tk.update_idletasks()
    tk.update()
    time.sleep(0.05)

# Game Over
go_label = canvas.create_text(250,200,text="GAME OVER",font=("Helvetica",30))
tk.update()
time.sleep(3.0)

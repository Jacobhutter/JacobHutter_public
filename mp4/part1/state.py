class State:
    def __init__(self, ball_x=0.0, ball_y=0.0, velocity_x=0.03, velocity_y=0.0, paddle_y=0.5):
         self.ball_x = ball_x
         self.ball_y = ball_y
         self.velocity_x = velocity_x
         self.velocity_y = velocity_y
         self.paddle_y = paddle_y

    def get_tuple(self):
        return (self.ball_x, self.ball_y, self.velocity_x, self.velocity_y, self.paddle_y)

    def action(self, choice=0):
        if choice == 2: # move up
            self.paddle_y -= 0.04
            self.paddle_y = max(self.paddle_y, 0)
        elif choice == 1: # move down
            self.paddle_y += 0.04
            self.paddle_y = min(self.paddle_y, 0.8)
        else: # nothing
            self.paddle_y += 0.0
        return self.get_tuple()

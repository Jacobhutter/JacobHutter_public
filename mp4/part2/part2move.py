import part2
import numpy as np

with open("weights", "r") as w_in:
	weights = np.load(w_in)
with open("biases", "r") as b_in:
	biases = np.load(b_in)

def get_move(discrete_paddle, ball_pos, ball_vx, ball_vy):
	ball_x = ((((ball_pos[0] + ball_pos[2]) / 2) / 500) - 0.5049281) / 0.288522263838
	ball_y = ((((ball_pos[1] + ball_pos[3]) / 2) / 500) - 0.5153992) / 0.279170531467

	ball_vx = ((ball_vx / 500.0) - 0.0004494) / 0.0463340332762
	ball_vy = ((ball_vy / 500.0) - 3.75e-05) / 0.0304211948113

	discrete_paddle = (discrete_paddle - 0.498532) / 0.218275616998
	
	x = np.array([ball_x, ball_y, ball_vx, ball_vy, discrete_paddle])
	return (-1 * part2.flnn(x, weights, biases, 0, 1)) + 1 

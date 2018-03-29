from scipy import signal
from scipy import misc
from PIL import Image
import numpy as np
import math
import sys
import harris


def get_neighbor_coords(im, x, y, X, Y):

    neighbors = lambda x, y : [l_im[x2][y2] for x2 in range(x-1, x+2)
                                   for y2 in range(y-1, y+2)
                                   if (-1 < x <= X and
                                       -1 < y <= Y and
                                       (0 <= x2 <= X) and
                                       (0 <= y2 <= Y))]
    coords = neighbors(x,y)
    return neighbors(x, y)

def GetImage(filename):
    # create jpg of from file name
    try:
        img = Image.open(filename)
    except IOError, ioe:
        print("That file Does not exist")
        sys.exit();
    return img

def GetImages(str1, str2):
    return np.array(GetImage(str1).convert('L')), np.array(GetImage(str2).convert('L'))

[l_im, r_im] = GetImages('images/uttower_left.jpg', 'images/uttower_right.jpg')
harris_l_im = harris.compute_harris_response(l_im)
harris_r_im = harris.compute_harris_response(r_im)
l_coords = harris.get_harris_points(harris_l_im)
r_coords = harris.get_harris_points(harris_r_im)

neighborhood_coords_l = np.empty((0,0))
for i in range(len(l_coords)):
    print l_coords[i], '\n', neighborhood_coords_l
    if i == 0:
        neighborhood_coords_l = get_neighbor_coords(l_im, l_coords[i][0], l_coords[i][1], l_im.shape[0], l_im.shape[1])
    else:
        neighborhood_coords_l.append(get_neighbor_coords(l_im, l_coords[i][0], l_coords[i][1], l_im.shape[0], l_im.shape[1]))

#print neighborhood_coords_l

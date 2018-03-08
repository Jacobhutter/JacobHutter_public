import numpy as np
import scipy
from skimage import data, io, filters
from skimage.transform import resize
import matplotlib
import math
import sys
from PIL import Image

n = 10
base = 2
k = 1
neighborhood_dim = 5
method = input("Downsample Image(1) or Create New Filter(2)?: ")

def level_supression( stack ):
    h = stack.shape[0]
    w = stack.shape[1]
    for level in range(1,n-1): # exclude level 0 and level n
        for i in range(h):
            for j in range(w):
                prev_pixel = stack[i,j,level-1]
                cur_pixel = stack[i,j,level]
                next_pixel = stack[i,j,level+1]
                if(prev_pixel > cur_pixel or next_pixel > cur_pixel):
                    stack[i,j,level] = 0

def nonmaximum_supression( im ):
    h = im.shape[0]
    w = im.shape[1]
    cur_filter = scipy.ndimage.filters.rank_filter(im, -1, size=9)
    filtered_im = np.empty((h,w))
    for i in range(h):
        for j in range(w):
            if(cur_filter[i][j] != im[i][j]):
                filtered_im[i][j] = 0
            else:
                filtered_im[i][j] = cur_filter[i][j]
    return filtered_im

def main( im ):
    w = im.size[0]
    h = im.size[1]
    im = np.divide(np.reshape(np.array(im), (h, w)).astype(float), 255) # convert to array and normalize


    if(not(h%2)): # make array odd by odd
        new_row = np.zeros((1,w))
        im = np.vstack([im, new_row])
        h+=1
    if(not(w%2)):
        new_col = np.zeros((h,1))
        im = np.append(im, new_col, axis=1)
        w+=1

    scale_space = np.empty((h,w,n)) # [h,w] - dimensions of image, n - number of levels in scale space

    if(method == 1):
        for i in range(n):
            small_im = resize(im, (h/(base + (k*i)), w/(base + (k*i))))
            cur_filter = scipy.ndimage.filters.gaussian_laplace(small_im, sigma = base)
            scale_space[:,:,i] = resize(im, (h,w))
    else:
        for i in range(n):
            cur_filter = scipy.ndimage.filters.gaussian_laplace(im, sigma = base+(k*i))
            scale_space[:,:,i] = cur_filter

    for i in range(n):
        scale_space[:,:,i] = nonmaximum_supression(scale_space[:,:,i])

    scale_space = level_supression(scale_space)

    return (Image.fromarray(im * 255)).convert('RGB')

def GetImage(filename):
    # create jpg of from file name
    try:
        Img = Image.open(filename)
    except IOError, ioe:
        print("That file Does not exist")
        sys.exit()
    return Img

im1 = GetImage('source_images/butterfly.jpg').convert('L')
#im2 = GetImage('source_images/einstein.jpg').convert('L')
#im3 = GetImage('source_images/fishes.jpg').convert('L')
#im4 = GetImage('source_images/sunflowers.jpg').convert('L')
im1 = main(im1)
#im2 = main(im2)
#im3 = main(im3)
#im4 = main(im4)
im1.save('output_images/butterfly.jpg')
#im2.save('output_images/einstein.jpg')
#im3.save('output_images/fishes.jpg')
#im4.save('output_images/sunflowers.jpg')

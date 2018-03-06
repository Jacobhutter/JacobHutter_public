import numpy as np
import scipy
from skimage import data, io, filters
import matplotlib
import math
import sys
from PIL import Image

def main(im):
    w = im.size[0]
    h = im.size[1]
    im = np.divide(np.reshape(np.array(im), (h, w)).astype(float), 255) # convert to array and normalize
    blob = scipy.ndimage.filters.gaussian_laplace(im, 2.502)
    return (Image.fromarray(blob)).convert('RGB')

def GetImage(filename):
    # create jpg of from file name
    try:
        Img = Image.open(filename)
    except IOError, ioe:
        print("That file Does not exist")
        sys.exit()
    return Img

im1 = GetImage('source_images/butterfly.jpg').convert('L')
im2 = GetImage('source_images/einstein.jpg').convert('L')
im3 = GetImage('source_images/fishes.jpg').convert('L')
im4 = GetImage('source_images/sunflowers.jpg').convert('L')
im1 = main(im1)
im2 = main(im2)
im3 = main(im3)
im4 = main(im4)
im1.save('output_images/butterfly.jpg')
im2.save('output_images/einstein.jpg')
im3.save('output_images/fishes.jpg')
im4.save('output_images/sunflowers.jpg')

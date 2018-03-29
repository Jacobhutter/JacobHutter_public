from scipy import signal
from scipy import misc
from PIL import Image
import numpy as np
import math
import scipy
import sys
import harris
import cv2

# https://docs.opencv.org/3.1.0/da/df5/tutorial_py_sift_intro.html
# plus a lot of freaking googling to realize i needed opencv-contrib aswell for xfeatures2d........ >:(
l_im = cv2.imread('images/uttower_left.jpg')
l_gray = cv2.cvtColor(l_im, cv2.COLOR_BGR2GRAY)
r_im = cv2.imread('images/uttower_right.jpg')
r_gray = cv2.cvtColor(r_im, cv2.COLOR_BGR2GRAY)

l_mask = np.ones((l_im.shape[1], l_im.shape[0]), np.uint8)
l_mask[:((l_im.shape[1]/2))] = 0
l_mask = np.transpose(l_mask)

r_mask = np.ones((r_im.shape[1], r_im.shape[0]), np.uint8)
r_mask[(r_im.shape[1]/2):] = 0
r_mask = np.transpose(r_mask)

l_sift = cv2.xfeatures2d.SIFT_create(nfeatures=200)
l_kp = l_sift.detect(l_gray, mask=l_mask)
l_kp, l_des = l_sift.compute(l_gray, l_kp)

r_sift = cv2.xfeatures2d.SIFT_create(nfeatures=200)
r_kp= r_sift.detect(r_gray, mask=r_mask)
r_kp, r_des = r_sift.compute(r_gray, r_kp)

dist_hash = {}
for i in range(l_des.shape[0]):
    print i
    for j in range(r_des.shape[0]):
        dist_hash[(i, j)] = scipy.spatial.distance.cdist(zip(l_des[i]), zip(r_des[j]), 'sqeuclidean')

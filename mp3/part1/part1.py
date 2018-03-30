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
# plus a lot of freaking googling to realize i needed opencv-contrib as well for xfeatures2d........ >:(
print "reading images..."
l_im = cv2.imread('images/uttower_left.jpg')
l_gray = cv2.cvtColor(l_im, cv2.COLOR_BGR2GRAY)
r_im = cv2.imread('images/uttower_right.jpg')
r_gray = cv2.cvtColor(r_im, cv2.COLOR_BGR2GRAY)
print "creating keypoints and descriptors..."
l_mask = np.ones((l_im.shape[1], l_im.shape[0]), np.uint8)
l_mask[:((l_im.shape[1]/2))] = 0
l_mask = np.transpose(l_mask)

r_mask = np.ones((r_im.shape[1], r_im.shape[0]), np.uint8)
r_mask[(r_im.shape[1]/2):] = 0
r_mask = np.transpose(r_mask)

l_sift = cv2.xfeatures2d.SIFT_create(nfeatures=100)
l_kp = l_sift.detect(l_gray, mask=l_mask)
l_kp, l_des = l_sift.compute(l_gray, l_kp)



r_sift = cv2.xfeatures2d.SIFT_create(nfeatures=100)
r_kp= r_sift.detect(r_gray, mask=r_mask)
r_kp, r_des = r_sift.compute(r_gray, r_kp)

img=cv2.drawKeypoints(r_gray, r_kp, r_im)
cv2.imwrite('sift_keypoints.jpg',img)
print "hashing descriptor average distances..."
reverse_hash = {}
dist_hash = {}
for i in range(l_des.shape[0]):
    for j in range(r_des.shape[0]):
        dist_hash[(i, j)] = np.mean(np.array(scipy.spatial.distance.cdist(zip(l_des[i]), zip(r_des[j]), 'sqeuclidean'))) # returns mean of dist_mat
        reverse_hash[dist_hash[(i, j)]] = (i, j)
n = 300 # get 300 'good' keypoints
print "finding the ", n, "th smallest mean distance descriptors..."
vals = np.array(dist_hash.values())

n_min_vals = vals.argsort()[:n]
n_min_descriptors = np.empty((0,0))
for i in range(len(n_min_vals)):
    n_min_descriptors = np.append(n_min_descriptors, (reverse_hash[vals[n_min_vals[i]]][0], reverse_hash[vals[n_min_vals[i]]][1]))

print "running ransac on 'good' keypoints..."

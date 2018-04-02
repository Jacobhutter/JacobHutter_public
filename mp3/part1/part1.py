from scipy import signal
from scipy import misc
from PIL import Image
from matplotlib import pyplot as plt
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
print "hashing descriptor average distances..."
reverse_hash = {}
dist_hash = {}

for i in range(l_des.shape[0]):
    for j in range(r_des.shape[0]):
        dist_hash[(i, j)] = np.mean(np.array(scipy.spatial.distance.cdist(zip(l_des[i]), zip(r_des[j]), 'sqeuclidean'))) # returns mean of dist_mat
        reverse_hash[dist_hash[(i, j)]] = (i, j)

n = 100 # get 100 'good' keypoints
print "finding the ", n, "th smallest mean distance descriptors..."
vals = np.array(dist_hash.values())
n_min_vals = vals.argsort()[:n]
left_good_keypoints = []
right_good_keypoints = []

print "running ransac on 'good' keypoints..."
#https://docs.opencv.org/3.0-beta/doc/py_tutorials/py_feature2d/py_feature_homography/py_feature_homography.html
for i in range(len(n_min_vals)):
    left_good_keypoints.append(np.float32((l_kp[reverse_hash[vals[n_min_vals[i]]][0]].pt[0], l_kp[reverse_hash[vals[n_min_vals[i]]][0]].pt[1])))
    right_good_keypoints.append(np.float32((r_kp[reverse_hash[vals[n_min_vals[i]]][1]].pt[0], r_kp[reverse_hash[vals[n_min_vals[i]]][1]].pt[1])))

left_good_keypoints =  np.asarray(left_good_keypoints)
right_good_keypoints = np.asarray(right_good_keypoints)

M, mask = cv2.findHomography(left_good_keypoints, right_good_keypoints, cv2.RANSAC, 5.0)
matchesMask = mask.ravel().tolist()

h = l_im.shape[0]
w = l_im.shape[1]
pts = np.float32([ [0,0],[0,h-1],[w-1,h-1],[w-1,0] ]).reshape(-1,1,2)
dst = cv2.perspectiveTransform(pts, M)

img2 = cv2.polylines(r_im,[np.int32(dst)],True,255,3, cv2.LINE_AA)

draw_params = dict(matchColor = (0,255,0), # draw matches in green color
                   singlePointColor = None,
                   matchesMask = matchesMask, # draw only inliers
                   flags = 2)

img3 = cv2.drawMatches(l_im,l_kp,img2,r_kp, matchesMask ,None,**draw_params)

plt.imshow(img3, 'gray'),plt.show()

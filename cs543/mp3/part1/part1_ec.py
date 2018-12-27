from scipy import signal
from scipy import misc
from PIL import Image, ImageOps
from skimage import transform
from matplotlib import pyplot as plt
import numpy as np
import math
import scipy
import sys
import harris
import cv2

# https://docs.opencv.org/3.1.0/da/df5/tutorial_py_sift_intro.html
# https://docs.opencv.org/3.0-beta/doc/py_tutorials/py_feature2d/py_feature_homography/py_feature_homography.html
# plus a lot of freaking googling to realize i needed opencv-contrib as well for xfeatures2d........ >:(
print "reading images..."
l_im = cv2.imread('images/hill/1.JPG')
l_gray = cv2.cvtColor(l_im, cv2.COLOR_BGR2GRAY)
r_im = cv2.imread('images/hill/2.JPG')
r_gray = cv2.cvtColor(r_im, cv2.COLOR_BGR2GRAY)
rr_im = cv2.imread('images/hill/3.JPG')
rr_gray = cv2.cvtColor(rr_im, cv2.COLOR_BGR2GRAY)

l_color = cv2.imread('images/hill/1.JPG', cv2.IMREAD_COLOR)
r_color = cv2.imread('images/hill/2.JPG', cv2.IMREAD_COLOR)
rr_color = cv2.imread('images/hill/3.JPG', cv2.IMREAD_COLOR)

l_color = ImageOps.expand(Image.fromarray(l_color),border=600,fill='black')
l_color = np.array(l_color)

r_color = ImageOps.expand(Image.fromarray(r_color),border=600,fill='black')
r_color = np.array(r_color)

rr_color = ImageOps.expand(Image.fromarray(rr_color),border=600,fill='black')
rr_color = np.array(rr_color)

l_gray = ImageOps.expand(Image.fromarray(l_gray),border=600,fill='black')
l_gray = np.array(l_gray)

r_gray = ImageOps.expand(Image.fromarray(r_gray),border=600,fill='black')
r_gray = np.array(r_gray)

rr_gray = ImageOps.expand(Image.fromarray(rr_gray),border=600,fill='black')
rr_gray = np.array(rr_gray)

print "creating keypoints and descriptors1..."
l_sift = cv2.xfeatures2d.SIFT_create()
l_kp = l_sift.detect(l_gray)
l_kp, l_des = l_sift.compute(l_gray, l_kp)

r_sift = cv2.xfeatures2d.SIFT_create()
r_kp= r_sift.detect(r_gray)
r_kp, r_des = r_sift.compute(r_gray, r_kp)

FLANN_INDEX_KDTREE = 0
index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
search_params = dict(checks = 50)

flann = cv2.FlannBasedMatcher(index_params, search_params)

matches = flann.knnMatch(l_des, r_des,k=2)
good = []
for m,n in matches:
    if m.distance < 0.20*n.distance:
        good.append(m)

src_pts = np.float32([ l_kp[m.queryIdx].pt for m in good ]).reshape(-1,1,2)
dst_pts = np.float32([ r_kp[m.trainIdx].pt for m in good ]).reshape(-1,1,2)

M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC,5.0)
############################################################
print "creating keypoints and descriptor2..."
l_sift = cv2.xfeatures2d.SIFT_create()
l_kp = l_sift.detect(r_gray)
l_kp, l_des = l_sift.compute(r_gray, l_kp)

r_sift = cv2.xfeatures2d.SIFT_create()
r_kp= r_sift.detect(rr_gray)
r_kp, r_des = r_sift.compute(rr_gray, r_kp)

FLANN_INDEX_KDTREE = 0
index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
search_params = dict(checks = 50)

flann = cv2.FlannBasedMatcher(index_params, search_params)

matches = flann.knnMatch(l_des, r_des,k=2)
good = []
for m,n in matches:
    if m.distance < 0.50*n.distance:
        good.append(m)

src_pts = np.float32([ l_kp[m.queryIdx].pt for m in good ]).reshape(-1,1,2)
dst_pts = np.float32([ r_kp[m.trainIdx].pt for m in good ]).reshape(-1,1,2)

M_2, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC,5.0)
#############################################################
estimated_transform = transform.ProjectiveTransform(M_2)
warped_im_r = 256 * transform.warp(rr_gray, estimated_transform, output_shape=(rr_gray.shape[0], rr_gray.shape[1]))
cv2.imwrite('rr.png', warped_im_r)
warped_im_r_color = 256 * transform.warp(rr_color, estimated_transform, output_shape=(rr_color.shape[0], rr_color.shape[1]))

estimated_transform = transform.ProjectiveTransform(np.linalg.inv(M))
warped_im_l = 256 * transform.warp(l_gray, estimated_transform, output_shape=(l_gray.shape[0], l_gray.shape[1]))
cv2.imwrite('left.png', warped_im_l)

warped_im_l_color = 256 * transform.warp(l_color, estimated_transform, output_shape=(l_color.shape[0], l_color.shape[1]))

composite = cv2.addWeighted(warped_im_l, 0.5, r_gray.astype('float'), 0.5, 0)
composite = cv2.addWeighted(composite, 1.0, warped_im_r, 0.5, 0)
cv2.imwrite('composite_gray.png', composite)

composite = cv2.addWeighted(warped_im_l_color, 0.333, r_color.astype('float'), 0.333, 0)
composite = cv2.addWeighted(composite, 1.0, warped_im_r_color, 0.3333, 0)
cv2.imwrite('composite_color.png', composite)

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
l_im = cv2.imread('images/uttower_left.jpg')
l_gray = cv2.cvtColor(l_im, cv2.COLOR_BGR2GRAY)
r_im = cv2.imread('images/uttower_right.jpg')
r_gray = cv2.cvtColor(r_im, cv2.COLOR_BGR2GRAY)
r_gray_2 = cv2.cvtColor(r_im, cv2.COLOR_BGR2GRAY)
print "creating keypoints and descriptors..."
l_mask = np.ones((l_im.shape[1], l_im.shape[0]), np.uint8)
l_mask[:((l_im.shape[1]/2))] = 0
l_mask = np.transpose(l_mask)

r_mask = np.ones((r_im.shape[1], r_im.shape[0]), np.uint8)
r_mask[(r_im.shape[1]/2):] = 0
r_mask = np.transpose(r_mask)

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
matchesMask = mask.ravel().tolist()

h = l_gray.shape[0]
w = l_gray.shape[1]
pts = np.float32([ [0,0],[0,h-1],[w-1,h-1],[w-1,0] ]).reshape(-1,1,2)
dst = cv2.perspectiveTransform(pts, M)

r_gray_new = cv2.polylines(r_gray,[np.int32(dst)],True,255,3, cv2.LINE_AA)

draw_params = dict(matchColor = (0,255,0), # draw matches in green color
                   singlePointColor = None,
                   matchesMask = matchesMask, # draw only inliers
                   flags = 2)

img3 = cv2.drawMatches(l_gray,l_kp,r_gray_new,r_kp,good,None,**draw_params)

# plt.imshow(img3, 'gray'),plt.show()
l_gray = ImageOps.expand(Image.fromarray(l_gray),border=0,fill='black')
l_gray = np.array(l_gray)

#r_gray = ImageOps.expand(Image.fromarray(r_gray_2),border=0,fill='black')
#r_gray = np.array(r_gray)


warp1 = cv2.warpPerspective(l_gray, M, (l_gray.shape[0],r_gray.shape[1]))
cv2.imwrite('left2.png', warp1)

warp2 = cv2.warpPerspective(r_gray, np.linalg.inv(M), (r_gray.shape[0], r_gray.shape[1]))
cv2.imwrite('right2.png', warp2)

composite = cv2.addWeighted(warp1, 0.5, warp2, 0.5, 0)
cv2.imwrite('composite2.png', composite)


estimated_transform = transform.ProjectiveTransform(M)
warped_im_r= 256 * transform.warp(r_gray, estimated_transform, output_shape=(r_gray.shape[0],  r_gray.shape[1]))
cv2.imwrite('right.png', warped_im_r)

estimated_transform = transform.ProjectiveTransform(np.linalg.inv(M))
warped_im_l = 256 * transform.warp(l_gray, estimated_transform, output_shape=(l_gray.shape[0], l_gray.shape[1]))
cv2.imwrite('left.png', warped_im_l)
composite = cv2.addWeighted(warped_im_l, 0.5, r_gray.astype('float'), 0.5, 0)
cv2.imwrite('composite.png', composite)

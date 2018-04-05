from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
import math
import cv2

def get_matches():
    img1 = cv2.imread('house1.jpg')
    img1 = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)

    img2 = cv2.imread('house2.jpg')
    img2 = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)

    sift1 = cv2.xfeatures2d.SIFT_create()
    kp1 = sift1.detect(img1)
    kp1, des1 = sift1.compute(img1, kp1)

    sift2 = cv2.xfeatures2d.SIFT_create()
    kp2 = sift2.detect(img2)
    kp2, des2 = sift2.compute(img2, kp2)

    FLANN_INDEX_KDTREE = 0
    index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
    search_params = dict(checks = 50)

    flann = cv2.FlannBasedMatcher(index_params, search_params)

    matches = flann.knnMatch(des1, des2,k=2)
    good = []
    for m,n in matches:
        if m.distance < 0.50*n.distance:
            good.append(m)

    src_pts = np.float32([ kp1[m.queryIdx].pt for m in good ]).reshape(-1,1,2)
    dst_pts = np.float32([ kp2[m.trainIdx].pt for m in good ]).reshape(-1,1,2)
    src_pts = np.reshape(src_pts, (src_pts.shape[0], src_pts.shape[2]))
    dst_pts = np.reshape(dst_pts, (dst_pts.shape[0], dst_pts.shape[2]))
    matches = np.hstack((src_pts, dst_pts))
    print matches.shape
    return matches

def shape( column ):
    mu = np.mean(column)
    column = np.subtract(column, mu) # center data around 0
    absolute_max = max(np.absolute(column))
    column = np.divide(column, absolute_max) # scale between -1 and 1
    column = np.multiply(column, math.sqrt(2.0) )
    return column

def fit_fundamental( matches ):
    x = []
    xp = []
    for i in range(len(matches)):
        row = matches[i]
        x.append([row[0], row[1]])
        xp.append([row[2], row[3]])

    x = np.asarray(x)
    xp = np.asarray(xp)

    u = shape(x[:, 0])
    up = shape(xp[:, 0])
    v = shape(x[:, 1])
    vp = shape(xp[:, 1])


    x_new = np.hstack((np.reshape(u, (u.shape[0], 1)), np.reshape(v, (v.shape[0], 1))))
    x_new = np.hstack((x_new, np.ones((u.shape[0], 1))))
    xp_new = np.hstack((np.reshape(up, (up.shape[0], 1)), np.reshape(vp, (vp.shape[0], 1))))
    xp_new = np.hstack((xp_new, np.ones((up.shape[0], 1)))) # change to homogenous coords
    T = np.linalg.lstsq(x, x_new)[0]
    Tp = np.linalg.lstsq(xp, xp_new)[0]

    a = np.transpose(np.asarray([np.multiply(up,u), np.multiply(up,v), up, np.multiply(vp, u), np.multiply(vp, v), vp, u, v, np.ones(u.shape)]))
    b = np.zeros((matches.shape[0], 1))
    F = np.linalg.lstsq(a, b, rcond=-1)[3]
    F = np.reshape(np.asarray(F), (3,3))
    U, s, V = np.linalg.svd(F)
    s = np.asarray([[s[0], 0, 0],[0,s[1],0],[0,0,0]]) # set rank 2 s matrix
    F_rank_2 =  np.dot(np.dot(U, s), V)
    return F_rank_2

##**************************************************
## load images and match files for the first example
##**************************************************

I1 = Image.open('house1.jpg');
I2 = Image.open('house2.jpg');
matches = get_matches(); # TODO: get matches via sift instead

# this is a N x 4 file where the first two numbers of each row
# are coordinates of corners in the first image and the last two
# are coordinates of corresponding corners in the second image:
# matches(i,1:2) is a point in the first image
# matches(i,3:4) is a corresponding point in the second image

N = len(matches)

##**************************************************
## display two images side-by-side with matches
## this code is to help you visualize the matches, you don't need
## to use it to produce the results for the assignment
##**************************************************

I3 = np.zeros((I1.size[1],I1.size[0]*2,3) )
I3[:,:I1.size[0],:] = I1;
I3[:,I1.size[0]:,:] = I2;
fig, ax = plt.subplots()
ax.set_aspect('equal')
ax.imshow(np.array(I3).astype(float))
ax.plot(matches[:,0],matches[:,1],  '+r')
ax.plot( matches[:,2]+I1.size[0],matches[:,3], '+r')
ax.plot([matches[:,0], matches[:,2]+I1.size[0]],[matches[:,1], matches[:,3]], 'r')
plt.show()

##
## display second image with epipolar lines reprojected
## from the first image
##

# first, fit fundamental matrix to the matches
F = fit_fundamental(matches); # this is a function that you should write
M = np.c_[matches[:,0:2], np.ones((N,1))].transpose()
L1 = np.matmul(F, M).transpose() # transform points from
# the first image to get epipolar lines in the second image

# find points on epipolar lines L closest to matches(:,3:4)
l = np.sqrt(L1[:,0]**2 + L1[:,1]**2)
L = np.divide(L1,np.kron(np.ones((3,1)),l).transpose())# rescale the line
pt_line_dist = np.multiply(L, np.c_[matches[:,2:4], np.ones((N,1))]).sum(axis = 1)
closest_pt = matches[:,2:4] - np.multiply(L[:,0:2],np.kron(np.ones((2,1)), pt_line_dist).transpose())

# find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - np.c_[L[:,1], -L[:,0]]*10# offset from the closest point is 10 pixels
pt2 = closest_pt + np.c_[L[:,1], -L[:,0]]*10

# display points and segments of corresponding epipolar lines
fig, ax = plt.subplots()
ax.set_aspect('equal')
ax.imshow(np.array(I2).astype(float))
ax.plot(matches[:,2],matches[:,3],  '+r')
ax.plot([matches[:,2], closest_pt[:,0]],[matches[:,3], closest_pt[:,1]], 'r')
ax.plot([pt1[:,0], pt2[:,0]],[pt1[:,1], pt2[:,1]], 'g')
plt.show()

from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from skimage import transform

def fit_fundamental( matches ):
    x = []
    xp = []
    for i in range(len(matches)):
        row = matches[i]
        x.append([row[0], row[1], 1])
        xp.append([row[2], row[3], 1])

    x = np.asarray(x)
    xp = np.asarray(xp)
    u = x[:,0]
    up = xp[:,0]
    v = x[:,1]
    vp = xp[:,1]

    a = np.transpose(np.asarray([np.multiply(up,u), np.multiply(up,v), up, np.multiply(vp, u), np.multiply(vp, v), vp, u, v, np.ones(u.shape)]))
    b = np.zeros((len(matches), 1))
    F = np.linalg.lstsq(a, b, rcond=-1)[3]
    F = np.reshape(np.asarray(F), (3,3))
    U, s, V = np.linalg.svd(F)
    s = np.asarray([[s[0], 0, 0],[0,s[1],0],[0,0,0]])
    F_rank_2 =  np.dot(np.dot(U, s), V)
    return F_rank_2

##**************************************************
## load images and match files for the first example
##**************************************************

I1 = Image.open('library1.jpg');
I2 = Image.open('library2.jpg');
matches = np.loadtxt('library_matches.txt');

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
print np.average(pt_line_dist)
pt_line_dist2 = np.multiply(L, np.c_[matches[:,0:2], np.ones((N,1))]).sum(axis = 1)
print np.average(pt_line_dist2)
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
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from skimage import transform

def get_coords( matches ):
    x = []
    xp = []
    for i in range(len(matches)):
        row = matches[i]
        x.append([row[0], row[1], 1])
        xp.append([row[2], row[3], 1])
    return np.asarray(x), np.asarray(xp)


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
    b = np.zeros((168, 1))
    F = np.linalg.lstsq(a, b, rcond=-1)[3]
    F = np.reshape(np.asarray(F), (3,3))
    U, s, V = np.linalg.svd(F)
    s = np.asarray([[s[0], 0, 0],[0,s[1],0],[0,0,0]])
    F_rank_2 =  np.dot(np.dot(U, s), V)
    return F_rank_2

##**************************************************
## load images and match files for the first example
##**************************************************

I1 = Image.open('house1.jpg');
I2 = Image.open('house2.jpg');
matches = np.loadtxt('house_matches.txt');

# this is a N x 4 file where the first two numbers of each row
# are coordinates of corners in the first image and the last two
# are coordinates of corresponding corners in the second image:
# matches(i,1:2) is a point in the first image
# matches(i,3:4) is a corresponding point in the second image

N = len(matches)
#
# ##**************************************************
# ## display two images side-by-side with matches
# ## this code is to help you visualize the matches, you don't need
# ## to use it to produce the results for the assignment
# ##**************************************************
#
# I3 = np.zeros((I1.size[1],I1.size[0]*2,3) )
# I3[:,:I1.size[0],:] = I1;
# I3[:,I1.size[0]:,:] = I2;
# fig, ax = plt.subplots()
# ax.set_aspect('equal')
# ax.imshow(np.array(I3).astype(float))
# ax.plot(matches[:,0],matches[:,1],  '+r')
# ax.plot( matches[:,2]+I1.size[0],matches[:,3], '+r')
# ax.plot([matches[:,0], matches[:,2]+I1.size[0]],[matches[:,1], matches[:,3]], 'r')
# # plt.show()
#
# ##
# ## display second image with epipolar lines reprojected
# ## from the first image
# ##
#
# # first, fit fundamental matrix to the matches
# F = fit_fundamental(matches); # this is a function that you should write
# M = np.c_[matches[:,0:2], np.ones((N,1))].transpose()
# L1 = np.matmul(F, M).transpose() # transform points from
# # the first image to get epipolar lines in the second image
#
# # find points on epipolar lines L closest to matches(:,3:4)
# l = np.sqrt(L1[:,0]**2 + L1[:,1]**2)
# L = np.divide(L1,np.kron(np.ones((3,1)),l).transpose())# rescale the line
# pt_line_dist = np.multiply(L, np.c_[matches[:,2:4], np.ones((N,1))]).sum(axis = 1)
# closest_pt = matches[:,2:4] - np.multiply(L[:,0:2],np.kron(np.ones((2,1)), pt_line_dist).transpose())
#
# # find endpoints of segment on epipolar line (for display purposes)
# pt1 = closest_pt - np.c_[L[:,1], -L[:,0]]*10# offset from the closest point is 10 pixels
# pt2 = closest_pt + np.c_[L[:,1], -L[:,0]]*10
#
# # display points and segments of corresponding epipolar lines
# fig, ax = plt.subplots()
# ax.set_aspect('equal')
# ax.imshow(np.array(I2).astype(float))
# ax.plot(matches[:,2],matches[:,3],  '+r')
# ax.plot([matches[:,2], closest_pt[:,0]],[matches[:,3], closest_pt[:,1]], 'r')
# ax.plot([pt1[:,0], pt2[:,0]],[pt1[:,1], pt2[:,1]], 'g')
# # plt.show()
#
P1 = np.loadtxt('house1_camera.txt')
U1, s1, V1 = np.linalg.svd(P1)
print V1
center_1 = V1[:, V1.shape[1]-1]
print center_1
P2 = np.loadtxt('house2_camera.txt')
U2, s2, V2 = np.linalg.svd(P2)
print V2
center_2 = V2[:, V2.shape[1]-1]
print center_2
x, xp = get_coords(matches)

A = []
points = []

for i in range(len(x)):
    x1 = x[i]
    x2 = xp[i]
    x1_mat = np.asarray([[0, -x1[2], x1[1]],[x1[2], 0, -x1[0]],[-x1[1], x1[0], 0]])
    x2_mat = np.asarray([[0, -x2[2], x2[1]],[x2[2], 0, -x2[0]],[-x2[1], x2[0], 0]])
    x1_cross_p = np.dot(x1_mat, P1)
    x2_cross_p = np.dot(x2_mat, P2)
    A = np.concatenate((x1_cross_p, x2_cross_p), axis=0)
    b = np.zeros((A.shape[0], 1))
    X_i = (np.linalg.lstsq(A, b, rcond=-1)[3])[:3] # pull off last point
    X_i = np.transpose(np.reshape(X_i, (X_i.shape[0], 1)))
    if(i == 0):
        points = X_i
    else:
        points = np.concatenate((points, X_i), axis=0)

x_points = points[:, 0]
y_points = points[:, 1]
z_points = points[:, 2]
T1 = np.linalg.lstsq(x, points)[0]
T2 = np.linalg.lstsq(xp, points)[0]
T1i = np.linalg.inv(T1)
T2i = np.linalg.inv(T2)
print T1.shape, T2.shape
c1 = np.dot(T1, center_1[0:3])
c2 = np.dot(T2, center_2[0:3])
print c1, c2
projections = []
for i in range(len(points)):
    cur_3dpt = points[i]
    cur_2dpt1 = np.dot(T1i, cur_3dpt)[:2]
    cur_2dpt2 = np.dot(T2i, cur_3dpt)[:2]
    metric_pt = np.transpose(np.array([cur_2dpt1[0], cur_2dpt1[1], cur_2dpt2[0], cur_2dpt2[1]]))
    metric_pt = np.reshape(metric_pt, (1,4))
    print metric_pt
    if i == 0:
        projections = metric_pt
    else:
        projections = np.concatenate((projections, metric_pt), axis=0)
residual = np.average(np.multiply(np.subtract(matches, projections), np.subtract(matches, projections)))
print residual

fig = plt.figure()
ax = Axes3D(fig)
ax.scatter(x_points, y_points, z_points)
ax.scatter(c1[0], c1[1], c1[2], c='r')
ax.scatter(c2[0], c2[1], c2[2], c='g')
plt.show()
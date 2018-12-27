from scipy import signal
from scipy import misc
from PIL import Image
import numpy as np
import math
import sys


def Normalize( a ):
    mi = np.amin(a)
    ma = np.amax(a)
    r = ma - mi
    step1 = np.subtract(a,mi).astype('float')
    step2 = 1 * step1 / r
    step2 = step2 - np.mean(step2) # center unit norm around 0
    return step2

def GetImage():
    # create jpg of from file name
    filename = raw_input("Give a input filename: ")
    try:
        brgImg = Image.open(filename)
    except IOError, ioe:
        print("That file Does not exist")
        sys.exit();
    return brgImg

def FindOffset(norm1, norm2, norm3):
    #norm1 = norm1.flatten()

    corr_first = 0
    corr_prev = 0
    global_i_first = 0
    global_j_first = 0
    for j in range (0,2):
        for i in range(-2,10): # rotate 2nd
            layer1 = np.roll(norm2, i, axis=j)
            #layer1 = layer1.flatten()
            print norm1.shape, layer1.shape
            corr1 = signal.correlate2d(norm1, layer1)[0]
            if i == 0 and j == 0:
                corr1 = corr1 * 1.003
            if corr1 > corr_first:
                corr_first = corr1
                global_i_first = i
                global_j_first = j

    # rotate 3rd
    corr_prev = 0
    corr_second = 0
    global_i_second = 0
    global_j_second = 0
    for j in range(0,2):
        for i in range(-2,10):
            layer1 = np.roll(norm3, i, axis=j)
            # layer1 = layer1.flatten()
            corr1 = signal.correlate2d(norm1, layer1)[0]
            if corr1 > corr_second:
                corr_second = corr1
                global_i_second = i
                global_j_second = j
    return global_i_first, global_j_first, corr_first, global_i_second, global_j_second, corr_second








brgImg = GetImage()
brgImg = brgImg.crop((10, 10, brgImg.size[0] - 10, brgImg.size[1] - 10 )) # attempt to crop out white border

width = brgImg.size[0]
height = brgImg.size[1]/3

bImg = np.array(brgImg.crop((0, 0, width, height)).getdata())
gImg = np.array(brgImg.crop((0, height, width, 2*height)).getdata())
rImg = np.array(brgImg.crop((0, 2*height, width, 3*height)).getdata())

br = np.reshape(bImg, (height, width))
gr = np.reshape(gImg, (height, width))
rr = np.reshape(rImg, (height, width))

bImgNorm = Normalize(br)

gImgNorm = Normalize(gr)

rImgNorm = Normalize(rr)

i1, j1, c1, i2, j2, c2 = FindOffset(bImgNorm, gImgNorm, rImgNorm)
i3, j3, c3, i4, j4, c4 = 0 # FindOffset(gImgNorm, bImgNorm, rImgNorm)
i5, j5, c5, i6, j6, c6 = 0 # FindOffset(rImgNorm, gImgNorm, bImgNorm)

m = max(c1,c2, c3,c4, c5,c6)
if m == c1 or m == c2:
    bi = 0
    bj = 0
    gi = i1
    gj = j1
    ri = i2
    rj = j2
    print gi, gj, "first"
    print ri, rj
elif m == c3 or m == c4:
    bi = i3
    bj = j3
    gi = 0
    gj = 0
    ri = i4
    rj = j4
    print bi, bj, "second"
    print ri, rj
else:
    bi = i6
    bj = j6
    gi = i5
    gj = j5
    ri = 0
    rj = 0
    print bi, bj, "third"
    print gi, gj

rImg = np.reshape(rImg, (height, width))
gImg = np.reshape(gImg, (height, width))
bImg = np.reshape(bImg, (height, width))

rImg = np.roll(rImg, ri, axis=0)
rImg = np.roll(rImg, rj, axis=1)

gImg = np.roll(gImg, gi, axis=0)
gImg = np.roll(gImg, gj, axis=1)

bImg = np.roll(bImg, bi, axis=0)
bImg = np.roll(bImg, bj, axis=1)


rgbArray = np.zeros((height,width,3), 'uint8')

for i in range(0, height-1):
    for j in range(0, width-1):
        rgbArray[i][j] = (rImg[i][j], gImg[i][j], bImg[i][j])

img = Image.fromarray(rgbArray)
img.save('myimg.jpg')

<<<<<<< HEAD
from scipy import signal
from scipy import misc
from PIL import Image
import numpy as np
=======
from PIL import Image
>>>>>>> 11bd125dde048d51bb741267699a98c7b42cee3b
import sys

# create jpg of from file name
filename = raw_input("Give a input filename: ")
try:
    brgImg = Image.open(filename)
except IOError, ioe:
    print("That file Does not exist")
    sys.exit();
width = brgImg.size[0]
<<<<<<< HEAD
height = brgImg.size[1]/3

# begin cropping and convert to 1d list
bImg = np.array(brgImg.crop((0, 0, width, height)).getdata())
gImg = np.array(brgImg.crop((0, height, width, 2*height)).getdata())
rImg = np.array(brgImg.crop((0, 2*height, width, 3*height)).getdata())

bImgNorm = bImg - sum(bImg)/len(bImg)
#bImgNorm = np.reshape(bImgNorm, (height, width))

gImgNorm = gImg - sum(gImg)/len(gImg)
gImgNorm = np.reshape(gImgNorm, (height, width))

rImgNorm = rImg - sum(rImg)/len(rImg)
rImgNorm = np.reshape(rImgNorm, (height, width))

corr = 0
global_i = 0
for i in range(0,15): # green on blue
    layer1 = np.roll(gImgNorm, i, axis=0)
    if i > 0:
        for k in range(0,i):
            layer1[k] = 255 # black circular shifted rows
    layer1_col = list(zip(*layer1))
    layer1 = layer1.flatten()
    corr1 = np.correlate(bImgNorm, layer1)[0]
    if corr1 > corr:
        corr = corr1
        global_i = i
print global_i
gImg = np.reshape(gImg, (height, width)) # shift green filtered image
gImg = np.roll(gImg, global_i, axis=0)
for k in range(0, global_i):
    gImg[k] = 255 # white circular shifted rows

# now blue on red
corr = 0
global_i = 0
for i in range(0,15): # figure out how much we should shift the red on blue
    layer1 = np.roll(rImgNorm, i, axis=0)
    if i > 0:
        for k in range(0,i):
            layer1[k] = 255 # black circular shifted rows
    layer1_col = list(zip(*layer1))
    layer1 = layer1.flatten()
    corr1 = np.correlate(bImgNorm, layer1)[0]
    if corr1 > corr:
        corr = corr1
        global_i = i

rImg = np.reshape(rImg, (height, width)) # shift green filtered image
rImg = np.roll(rImg, global_i, axis=0)
print global_i
for k in range(0,global_i):
    rImg[k] = 255 # white out circular shifted rows

bImg = np.reshape(bImg, (height, width)) # shift green filtered image

rgbArray = np.zeros((height,width,3), 'uint8')
for i in range(0, height-1):
    for j in range(0, width-1):
        rgbArray[i][j] = (rImg[i][j], gImg[i][j], bImg[i][j])

img = Image.fromarray(rgbArray)
img.save('myimg.jpeg')
=======
height = brgImg.size[1]
height = height/3

# begin cropping
bImg = brgImg.crop((0, 0, width, height));
gImg = brgImg.crop((0, height, width, 2*height));
rImg = brgImg.crop((0, 2*height, width, 3*height));

bImg.save("b1.jpg");
gImg.save("g1.jpg");
rImg.save("r1.jpg");
>>>>>>> 11bd125dde048d51bb741267699a98c7b42cee3b

from PIL import Image
import sys

# create jpg of from file name
filename = raw_input("Give a input filename: ")
try:
    brgImg = Image.open(filename)
except IOError, ioe:
    print("That file Does not exist")
    sys.exit();
width = brgImg.size[0]
height = brgImg.size[1]
height = height/3

# begin cropping
bImg = brgImg.crop((0, 0, width, height));
gImg = brgImg.crop((0, height, width, 2*height));
rImg = brgImg.crop((0, 2*height, width, 3*height));

bImg.save("b1.jpg");
gImg.save("g1.jpg");
rImg.save("r1.jpg");

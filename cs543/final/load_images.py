import os
import cv2
import numpy as np

path = 'orig_photos'
numcards = 53
min_x = 2127
min_y = 1525
for filename in os.listdir(path):
    if filename.endswith(".jpg"):
        p = 'orig_photos/' + filename
        im = cv2.imread(p)
        gray = cv2.cvtColor(im,cv2.COLOR_BGR2GRAY)
        blur = cv2.GaussianBlur(gray,(1,1),1000)
        flag, thresh = cv2.threshold(blur, 120, 255, cv2.THRESH_BINARY)
        _, contours, _ = np.array(cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE))
        contours = sorted(contours, key=cv2.contourArea,reverse=True)[:1]
        for i in range(len(contours)):
            card = np.array(contours[i], np.float32)
            peri = cv2.arcLength(card, True)
            approx = cv2.approxPolyDP(card,0.02*peri,True)

        h = np.array([ [0,0],[449,0],[449,449],[0,449] ], np.float32)
        transform = cv2.getPerspectiveTransform(approx,h)
        warp = cv2.warpPerspective(gray, transform,(450,450))
        p = 'loaded_photos/' + filename
        cv2.imwrite(p, warp)

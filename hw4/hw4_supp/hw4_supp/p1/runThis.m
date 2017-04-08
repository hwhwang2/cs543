clear all 
close all
img = imread('house2.jpg');
[cIndMap, time, imgVis] = slic(img, 128, 20);
disp(time);
m = 20;
k = 128;
 for m = [10 20 30]
     [cIndMap, time, imgVis] = slic(img, k, m)
     m
     k
     time
 end
 m = 20;
k = 128;
 for k = [64 256 1024]
     [cIndMap, time, imgVis] = slic(img, k, m)
     m
     k
     time
 end
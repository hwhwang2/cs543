clear all 
close all
img = imread('house2.jpg');
[cIndMap, time, imgVis] = slic(img, 128, 20);
disp(time);
 for m = [10 20 30]
     [cIndMap, time, imgVis] = slic(img, 128, m)
     disp('K= 128');
     disp('m = '+string(m) );
     disp('time = '+string(time) );
 end
 for k = [64 256 1024]
     [cIndMap, time, imgVis] = slic(img, K, 20)
     disp('K= 128'+string(k));
     disp('m =20');
     disp('time = '+string(time) );
 end
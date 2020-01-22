function [ res_x, res_y ] = hough_nav_test( img )
gr = rgb2gray(img);
bw = edge(gr,'canny');

[H,theta,rho] = hough(bw);

P = houghpeaks(H,16,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(bw,theta,rho,P,'FillGap',22,'MinLength',40);
size(lines);


end
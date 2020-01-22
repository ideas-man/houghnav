function [ res_x, res_y, xy, lines, theta ] = hough_nav( img )
gr = rgb2gray(img);
bw = edge(gr,'canny');
[H,theta,rho] = hough(bw);
P = houghpeaks(H,16,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(bw,theta,rho,P,'FillGap',22,'MinLength',40);
size(lines);
Diag = [];
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   if abs(lines(k).theta) > 15
       Diag = [Diag,k];
   end
end
Cross = [];
for ii = 1: length(Diag) - 1
    for jj = ii + 1: length(Diag)
        [cr_x, cr_y]  = linecross([lines(Diag(ii)).point1,lines(Diag(ii)).point2],...
                                 [lines(Diag(jj)).point1,lines(Diag(jj)).point2]);
        Cross = [Cross; cr_x cr_y];
    end
end
%%plot(round(sum(Cross(:,1)) / size(Cross,1)),round(sum(Cross(:,2))/ size(Cross,1)),'+r', 'MarkerSize',16);
res_x = round(sum(Cross(:,1)) / size(Cross,1));
res_y = round(sum(Cross(:,2))/ size(Cross,1));
end
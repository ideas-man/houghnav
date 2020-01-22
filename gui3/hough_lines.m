function [ res_x, res_y] = hough_lines( img )
gr = rgb2gray(img);
bw = edge(gr,'canny');
[H,theta,rho] = hough(bw);  %,'RhoResolution',0.5,'ThetaResolution',0.5
P = houghpeaks(H,16,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(bw,theta,rho,P,'FillGap',22,'MinLength',40);
size(lines);
%max_len = 0;
 Diag = []
 for k = 1:length(lines)
    %xy = [lines(k).point1; lines(k).point2];   
  if (abs(lines(k).theta) > 15 && abs(lines(k).theta) <= 85)
       Diag = [Diag,k];
  end
 end

Cross = [];
for ii = 1: length(Diag) - 1
    for jj = ii + 1: length(Diag)
        [cr_x cr_y]  = linecross([lines(Diag(ii)).point1,lines(Diag(ii)).point2],...
                                 [lines(Diag(jj)).point1,lines(Diag(jj)).point2]);
        Cross = [Cross; cr_x cr_y];
    end
end

X_f = medfilt1 (Cross(:,1));
Y_f = medfilt1 (Cross(:,2));

if (size(Cross,1)==0)
    res_x=0;
    res_y=0;
else
    res_x = round(round(mean(X_f)));
    res_y = round(round(mean(Y_f)));
end;
end


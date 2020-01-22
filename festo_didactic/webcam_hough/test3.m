addpath('C:\MATLAB\SupportPackages\R2015a\usbwebcams');

camList = webcamlist;
main_cam = webcam(1);

for idx = 1:100
    img = snapshot(main_cam);
imshow(img), hold on

%gr = rgb2gray(img);
bw = edge(rgb2gray(img),'canny');

[H,theta,rho] = hough(bw);  %,'RhoResolution',0.5,'ThetaResolution',0.5
P = houghpeaks(H,16,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(bw,theta,rho,P,'FillGap',22,'MinLength',40);
size(lines);

max_len = 0;
Diag = [];
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   
   if abs(lines(k).theta) > 85
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','yellow');
   elseif abs(lines(k).theta) > 15
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       Diag = [Diag,k];
   else
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','cyan');
   end
   
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

end

Cross = [];
for ii = 1: length(Diag) - 1
    for jj = ii + 1: length(Diag)
        [cr_x cr_y]  = linecross([lines(Diag(ii)).point1,lines(Diag(ii)).point2],...
                                 [lines(Diag(jj)).point1,lines(Diag(jj)).point2]);
        Cross = [Cross; cr_x cr_y];
    end
end

res_x = round(sum(Cross(:,1)) / size(Cross,1)) 
res_y = round(sum(Cross(:,2))/ size(Cross,1))
hold on,
    if(res_x <= 0 || res_y <= 0)
        hold on, plot(320, 240,'+y', 'MarkerSize',16)
    else
        hold on, plot(res_x, res_y,'+r', 'MarkerSize',16), hold on
    end;

end
clear main_cam;
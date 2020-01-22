addpath('C:\MATLAB\SupportPackages\R2015a\usbwebcams');

camList = webcamlist;
main_cam = webcam(1);

for idx = 1:100
    img = snapshot(main_cam);
imshow(img), hold on

gr = rgb2gray(img);

 %bw = imread('..\ss.bmp');
bw = edge(gr,'canny');

[H,theta,rho] = hough(bw);  %,'RhoResolution',0.5,'ThetaResolution',0.5
%figure
%imshow(H,[],'XData',theta,'YData',rho,...
%        'InitialMagnification','fit');
%xlabel('\theta'), ylabel('\rho');
%%axis on, axis normal, hold on;

P = houghpeaks(H,16,'threshold',ceil(0.3*max(H(:))))
%x = theta(P(:,2)); 
%y = rho(P(:,1));
%plot(x,y,'s','color','white');

lines = houghlines(bw,theta,rho,P,'FillGap',22,'MinLength',40);
size(lines);

%figure(6), imshow(im), hold on
%figure(5), imshow(im), hold on
max_len = 0;
Diag = [];
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   
   if abs(lines(k).theta) > 85
       %figure(5)
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','yellow');
   elseif abs(lines(k).theta) > 15
       %figure(5)
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       %figure(6)
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       Diag = [Diag,k];
   else
       %figure(5)
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','cyan');
   end

   % Отображение начала и конца линий
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

%    % Определение конечной точки
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
end

% Окрашивание линий
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
Cross = [];
for ii = 1: length(Diag) - 1
    for jj = ii + 1: length(Diag)
        [cr_x cr_y]  = linecross([lines(Diag(ii)).point1,lines(Diag(ii)).point2],...
                                 [lines(Diag(jj)).point1,lines(Diag(jj)).point2]);
        Cross = [Cross; cr_x cr_y];
    end
end
%Cross
%figure(6),hold on
%plot(round(Cross(:,1)),round(Cross(:,2)),'ob')
%axis([0 320 0 240])
res_x = round(sum(Cross(:,1)) / size(Cross,1))
res_y = round(sum(Cross(:,2))/ size(Cross,1))
hold on, plot(res_x,res_y,'+r', 'MarkerSize',16)


end
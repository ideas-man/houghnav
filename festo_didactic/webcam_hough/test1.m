addpath('C:\MATLAB\SupportPackages\R2015a\usbwebcams');

camList = webcamlist;
main_cam = webcam(1);

for idx = 1:100
    img = snapshot(main_cam);
    [res_x, res_y, xy, lines, theta] = hough_nav(img);
    
    if(res_x <= 0 || res_y <= 0)
        imshow(img), hold on, plot(320, 240,'+y', 'MarkerSize',16)
    else
        imshow(img), hold on, plot(res_x, res_y,'+r', 'MarkerSize',16), hold on
    end;
end

clear main_cam;
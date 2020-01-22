im = (imread('sh_corr_mov_01.jpg'));

gr = rgb2gray(im);
bw = edge(gr,'canny');
[H,theta,rho] = hough(bw);

P = houghpeaks(H,16,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(bw,theta,rho,P,'FillGap',22,'MinLength',40);
size(lines)



max_len = 0;
Diag = [];
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   
   if abs(lines(k).theta) > 85
       figure(5)
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','yellow');
   elseif abs(lines(k).theta) > 15
       figure(5)
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       figure(6)
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       Diag = [Diag,k];
   else
       figure(5)
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','cyan');
   end

   % Отображение начала и конца линий
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

end



Cross = [];
for ii = 1: length(Diag) - 1
    for jj = ii + 1: length(Diag)
        [cr_x, cr_y]  = linecross([lines(Diag(ii)).point1,lines(Diag(ii)).point2],...
                                 [lines(Diag(jj)).point1,lines(Diag(jj)).point2]);
        Cross = [Cross; cr_x cr_y];
    end
end
Cross
figure(6),hold on
plot(round(Cross(:,1)),round(Cross(:,2)),'ob')
axis([0 320 0 240])
hold on, plot(round(sum(Cross(:,1)) / size(Cross,1)),round(sum(Cross(:,2))/ size(Cross,1)),'+r', 'MarkerSize',16)
close all;
clear all;
image = im2double(imread("Car On Mountain Road.tif"));


e = exp(1);
sigma = 4;
n = 25;
cen = n/2+0.5;
for x=1:n
   for y=1:n
       LoG(x,y) = (((x-cen)^2 + (y-cen)^2 - 2*sigma^2) / sigma^4) * exp(-((x-cen)^2 + (y-cen)^2)/(2*sigma^2));
       %G(x,y) =  exp(((x-cen)^2 + (y-cen)^2)/(2*sigma^2));
   end
end


% mask = [ 0, 0,-1, 0, 0;
%          0,-1,-2,-1, 0;
%         -1,-2,16,-2,-1;
%          0,-1,-2,-1, 0;
%          0, 0,-1, 0, 0];
     
% L_mask = [1, 1, 1;
%           1,  -8, 1;
%           1, 1, 1];

figure;
imshow(image);
title("original");
      
image_LoG =  conv2(image, LoG, 'same');

figure;
imshow(image_LoG, 'DisplayRange',[0 max(max(image_LoG))]);
title("after LoG");

%zero crossing
x_size = size(image_LoG,1);
y_size = size(image_LoG,2);

%threshold = 0.04*max(max(image_edge));
for threshold = [0, 0.04*max(max(image_LoG))]
    image_edge_zero_crossing = zeros(x_size, y_size);
    for x=2:x_size-1
        for y=2:y_size-1
            if(sign(image_LoG(x-1,y))*sign(image_LoG(x+1,y)) == -1 && abs(image_LoG(x-1,y)-image_LoG(x+1,y)) > threshold)
                image_edge_zero_crossing(x,y) = 1;
            elseif (sign(image_LoG(x,y-1))*sign(image_LoG(x,y+1)) == -1 && abs(image_LoG(x,y-1)-image_LoG(x,y+1)) > threshold)
                image_edge_zero_crossing(x,y) = 1;
            elseif (sign(image_LoG(x-1,y-1))*sign(image_LoG(x+1,y+1)) == -1 && abs(image_LoG(x-1,y-1)-image_LoG(x+1,y+1)) > threshold)
                image_edge_zero_crossing(x,y) = 1;
            elseif (sign(image_LoG(x+1,y-1))*sign(image_LoG(x-1,y+1)) == -1 && abs(image_LoG(x+1,y-1)-image_LoG(x-1,y+1)) > threshold)
                image_edge_zero_crossing(x,y) = 1;
            end
        end
    end

    figure;
    imshow(image_edge_zero_crossing);
    str = sprintf("after zero crossing, threshold=%5f",threshold);
    title(str);
end

[H,T,R] = hough(image_edge_zero_crossing, 'RhoResolution', 1, 'Theta', -90:1:89);
figure;
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
axis on, axis normal; hold on;
colormap(gca,hot);
% P  = houghpeaks(H,10,'threshold',ceil(0.3*max(H(:))));
% plot(T(P(:,2)),R(P(:,1)),'d','color','blue');

figure;
imshow(image);
hold on;
Theta(1) = T(5)*pi/180;
Rho(1) = R(900);

Theta(2) = T(4)*pi/180;
Rho(2) = R(917);

Theta(3) = T(100)*pi/180;
Rho(3) = R(1521);

Theta(4) = T(100)*pi/180;
Rho(4) = R(1615);

for i=1:size(Theta,2)
    plot([0,size(image,2)],[Rho(i)/sin(Theta(i)),(Rho(i)-size(image,2)*cos(Theta(i)))/sin(Theta(i))],'-','LineWidth',2);
    hold on;
end

%% Read Image
image = imread('Car On Mountain Road.tif');
image = im2double(image);
sigma = 4.5;

%% LoG
LoG = zeros(25);
for i = 1:25
    for j = 1:25
       LoG(i, j) = -(((i-13)^2 + (j-13)^2 - 2*sigma^2) / sigma^4) * exp(-((i-13)^2 + (j-13)^2)/(2*sigma^2));
    end
end

LoG_Laplacian_image = conv2(image, LoG, 'same');
figure, imshow(LoG_Laplacian_image, []), title('LoG Image');
%% Zero Crossing
for threshold = [0, 0.04*max(max(LoG_Laplacian_image))]
    zero_crossing_image = zeros(size(image));
    [row,column] = size(zero_crossing_image);
    for i = 2:row-1
        for j = 2:column-1
            if((sign(LoG_Laplacian_image(i-1, j))*sign(LoG_Laplacian_image(i+1, j)) == -1) && (abs(LoG_Laplacian_image(i-1, j)-(LoG_Laplacian_image(i+1, j))) > threshold))
                zero_crossing_image(i, j) = 1;
            elseif((sign(LoG_Laplacian_image(i, j-1))*sign(LoG_Laplacian_image(i, j+1)) == -1) && (abs(LoG_Laplacian_image(i, j-1)-(LoG_Laplacian_image(i, j+1))) > threshold))
                zero_crossing_image(i, j) = 1;
            elseif((sign(LoG_Laplacian_image(i-1, j-1))*sign(LoG_Laplacian_image(i+1, j+1)) == -1) && (abs(LoG_Laplacian_image(i-1, j-1)-(LoG_Laplacian_image(i+1, j+1))) > threshold))
                zero_crossing_image(i, j) = 1;
            elseif((sign(LoG_Laplacian_image(i-1, j+1))*sign(LoG_Laplacian_image(i+1, j-1)) == -1) && (abs(LoG_Laplacian_image(i-1, j+1)-(LoG_Laplacian_image(i+1, j-1))) > threshold))
                zero_crossing_image(i, j) = 1;
            end
        end
    end
    zero_crossing_image = 255*zero_crossing_image;
    figure, imshow(zero_crossing_image), title(['Threshold = ', num2str(threshold)]);
end

%% Edge Linking
[H, theta, rho] = hough(zero_crossing_image);
figure, imshow(imadjust(rescale(H)),'XData',theta,'YData',rho,'InitialMagnification','fit'), hold on;
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;
colormap(gca,hot);

BW = zero_crossing_image;
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:)))); % 從霍夫變換矩陣H中提取5個極值點
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black'); 
% 找原圖中的線
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
figure, imshow(image), hold on;
max_len = 0;

for k = 1:length(lines)
    % 繪製各條線
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');   
    % 繪製線的起點（黃色）、終點（紅色）
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');   
    % 計算線的長度，找最長線段
    len = norm(lines(k).point1 - lines(k).point2);
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end
% 以紅色線高亮顯示最長的線
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
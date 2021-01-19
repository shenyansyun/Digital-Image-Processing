clear all;
close all;
image = im2double(imread("fruit on tree.tif"));
r = image(:, :, 1);

r_ = im2uint8(r);
[counts,x] = imhist(r_,256);
global_var = var(double(r_(:)));
global_mean = mean(double(r_(:)));
between_class_var = zeros(255);
for i=1:255
    P = sum(counts(1:i))/sum(counts(:));
    m = (counts(1:i)/sum(counts(:)))'*(1:i)';
    between_class_var(i) = (global_mean*P-m)^2/(P*(1-P));
end
figure;
plot(1:255, between_class_var);
title("between class var");

T = graythresh(r);
x_size = size(image,1);
y_size = size(image,2);

for x=1:x_size
   for y=1:y_size
       if image(x, y, 1) < T
           image_otsu(x, y, 1) = 0.5;
           image_otsu(x, y, 2) = 0.5;
           image_otsu(x, y, 3) = 0.5;
       else
           image_otsu(x, y, 1) = image(x ,y, 1);
           image_otsu(x, y, 2) = image(x ,y, 2);
           image_otsu(x, y, 3) = image(x ,y, 3);
       end
   end
end
figure;
imshow(image);
title("original");
figure;
imshow(image_otsu);
title("otsu");

for threshold=[1,5,10]
    [L,centers] = imsegkmeans(im2uint8(image),2, 'Threshold', threshold);
    
    figure;
    %imshow(double(L)/double(max(max(L))));
    imagesc(uint8(L));
    s = sprintf("k-mean clustering, threshold=%5f",threshold);
    title(s);
end



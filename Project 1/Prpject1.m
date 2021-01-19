image = imread('Bird feeding 3 low contrast.tif');
image_double = double(image);
figure(1);
imshow(image);
figure(2);
imhist(image);

im_after_transfer = zeros(512);
im_after_transfer = transformation(image_double);

figure(3);
imshow(uint8(im_after_transfer));
figure(4);
imhist(uint8(im_after_transfer));

output = 0:255;
for i = 1:256
    output(i) = atan((i-128)/32);
    range = ((atan((255-128)/32))-(atan((0-128)/32)));
    output(i) = (255/range)*(output(i)-(atan((0-128)/32)));
end
output = uint8(output);

function output = transformation(im)
    for i = 1:512
        for j = 1:512
            output(i, j) = (atan((im(i, j)-128)/32));
            range = ((atan((255-128)/32))-(atan((0-128)/32)));
            output(i, j) = (255/range)*(output(i, j)-(atan((0-128)/32))); %h{}
        end
    end
end
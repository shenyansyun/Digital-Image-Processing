image  = imread('Bird 2.tif');

%DFT
F_img = fftshift(fft2(image));
S_img = abs(F_img);
figure, imagesc(((log(abs(F_img)))));
title("DFT magnitude in Log scale");
colormap gray;

%construct mask_inside and mask_outside
for i = 1:512
    for j = 1:512
        radius = ((i-256)^2+(j-256)^2)^0.5;
        if (radius<30)
            mask_inside(i,j) = 1;
        else
            mask_inside(i,j) = 0;
        end
    end
end
mask_outside = 1-mask_inside;

%generate input image to output image
F_output_inside = F_img.*mask_inside;
F_output_outside = F_img.*mask_outside;

F_output_inside = uint8(abs(ifft2(ifftshift(F_output_inside))));
F_output_outside = uint8(abs(ifft2(ifftshift(F_output_outside))));

figure, imshow(uint8(F_output_inside)),title("Image constructed by DFT coefficients inside the circular region");

figure, imshow(uint8(F_output_outside)), title("Image constructed by DFT coefficients outside the circular region");

%generate top 25 frequency
frequency = S_img(:,1:256);
[top_frequency,index_temp] = sort(frequency(:), 1,'descend');
[ind_row,ind_col] = ind2sub(size(frequency),index_temp(1:25));

file = fopen('project2.xls', 'w');
fprintf(file, 'magnitude | (u, v)\n');
for i = 1:25
    fprintf(file, '%f | (%d; %d)\n', [top_frequency(i); ind_row(i)-1; ind_col(i)-1])
end
fclose(file);


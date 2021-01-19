image = imread('Bird 2 degraded.tif');;

%Hufnagel & Stanley
H = [600, 600];
k = 0.001; %using k=0.001 for mild turbulence
for u = 1:600
    for v = 1:600
        H(u,v) = exp(-k*(((u-300)^2+(v-300)^2)^(5/6)));
    end
end
figure, imshow(H);
title("Fourier magnitude spectrum of degradation model H(u,v)");

%DFT
im_dft = fftshift(fft2((image)));
figure, imagesc(log(abs(im_dft)));
title("Fourier magnitude spectrum of the degraded image Bird 2 degraded");
colormap gray;

%mask on G and H
G_50 = [600, 600];
G_85 = [600, 600];
G_120 = [600, 600];
H_50 = [600, 600];
H_85 = [600, 600];
H_120 = [600, 600];
for i = 1:600
    for j = 1:600
        if((i-300)^2+(j-300)^2<50*50)
            H_50(i, j) = H(i, j);
            G_50(i, j) = im_dft(i, j);
        else
            H_50(i, j) = 1;
            G_50(i, j) = 1;
        end
        
        if((i-300)^2+(j-300)^2<85*85)
            H_85(i, j) = H(i, j);
            G_85(i, j) = im_dft(i, j);
        else
            H_85(i, j) = 1;
            G_85(i, j) = 1;
        end
        
        if((i-300)^2+(j-300)^2<120*120)
            H_120(i, j) = H(i, j);
            G_120(i, j) = im_dft(i, j);
        else
            H_120(i, j) = 1;
            G_120(i, j) = 1;
        end
    end
end

%inverse filter
F_50_fft = [600,600];
F_50_fft = G_50./H_50;
F_50 = ifft2(ifftshift(F_50_fft));
figure, imshow(uint8(abs(F_50)));
title("radius = 50");

F_85_fft = [600,600];
F_85_fft = G_85./H_85;
F_85 = ifft2(ifftshift(F_85_fft));
figure, imshow(uint8(abs(F_85)));
title("radius = 85");

F_120_fft = [600,600];
F_120_fft = G_120./H_120;
F_120 = ifft2(ifftshift(F_120_fft));
figure, imshow(uint8(abs(F_120)));
title("radius = 120");

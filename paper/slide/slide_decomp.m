rgb = imread('apple_red.png');
[x,y,z] = size(rgb);

I = rgb2gray(rgb);
C = rgb-I;

for i = 1:x
    for j = 1:y
        if C(x,y,:) == [0;0;0]
            C(x,y,:) = [1;1;1];
        end
    end
end

figure;
imshow(rgb);
figure;
imshow(C);
figure;
imshow(I);

% yuv = rgb2ycbcr(rgb);
% imshow(yuv(:,:,3));
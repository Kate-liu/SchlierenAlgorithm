%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Schlieren MATLAB code
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; 
clc;  
clf;
close all;

%% read single image
data_image = imread('./Data/ExplosiveProducts/1.jpg');

[height, width, depth] = size(data_image);


%% to gray
if depth > 0
    data_image = rgb2gray(data_image);
end

figure(1);
imshow(data_image);


%% median filter
% data_image=medfilt2(data_image);
% figure(2)
% imshow(data_image)


%% gradient calculate
% https://www.mathworks.com/help/images/ref/imgradient.html
% [Gmag,Gdir] = imgradient(I,method) 
% returns the gradient magnitude and direction using the specified method.
% method ¡ª Gradient operator
% 'sobel' (default) | 'prewitt' | 'central' | 'intermediate' | 'roberts'
sobel_image = imgradient(data_image);


threshold = max(max(sobel_image)) * 0.018;

new_image = zeros(height, width);
for i = 1: height
    for j = 1: width
        if sobel_image(i, j) >= threshold
            new_image(i, j) = 1;
        end
    end
end

figure(4);
imshow(new_image);

%% Remove other point influence
% bwareaopen Remove small objects from binary image.
% fix(X) rounds the elements of X to the nearest integers towards zero.
new_image = bwareaopen(new_image, fix(height * width * 0.003));

figure(5);
imshow(new_image);

%% Change left picture edge
% Lable of the connection area
% bwlabel Label connected components in 2-D binary image.
new_image = bwlabel(new_image);

% regionprops Measure properties of image regions.
rr = regionprops(new_image, 'Centroid');
aa = regionprops(new_image, 'Area');

beatiful_image = zeros(height, width);

for i = 1: max(max(new_image))
    cc = rr(i).Centroid;
    dd = aa(i).Area / (cc(1) * cc(2));
    
    if  dd < 1
        pp = find(new_image == i);
        beatiful_image(pp) = 1;
    end
end

figure(7);
imshow(beatiful_image);




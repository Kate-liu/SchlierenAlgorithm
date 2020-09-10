function output=processJ(file_extension,display,max)
% logic:
% ��ͼ->�Ҷ�ͼ->ROI����->���ԭʼͼ��������Сǿ��ֵ(ǿ������������)->
% ��ȥ��Сǿ��ֵ->���Ա���->����ͼ��->�Ƿ�չʾͼ��

% Schlieren image processing code
% This code scales up the image intensity and cropst he area of interest

% Assemble entire filename
folder='E:\05-MatlabWorkSpace\SchlierenAlgorithm\Data';
%filename=[folder,'1',file_extension,'.jpg'];
filename='E:\CUPT8\80\932-938\3 .jpg';
% Read the image into Matlab and convert into a grayscale image

image=imread(filename);
grayimage=rgb2gray(image);

% Crop full image down to the area of interest
sized_image=imcrop(grayimage, [115 517 322 463]);

% Use the greatest and least intense pixels to rescale the image to use the
% full intensity range 0-255
image_size=size(sized_image);

min_intensity=255;
max_intensity=0;
for m=1:image_size(1) % m corresponds to the x pixel location
    for n=1:image_size(1) % n corresponds to the y pixel location
        if grayimage(m,n)<min_intensity
            min_intensity=sized_image(m,n);
        end
        if grayimage(m,n)>max_intensity
           max_intensity=sized_image(m,n);
        end
    end
end

full_scale=(sized_image-min_intensity) * (max/ (max_intensity-min_intensity));

% Write the processed image to file
savename=[folder,'4';file_extension,'.jpg'];
imwrite(full_scale,savename,'jpg','quality',100);

% Display the processed image if display=1
if display==1
   imshow(savename);
end

output=1;
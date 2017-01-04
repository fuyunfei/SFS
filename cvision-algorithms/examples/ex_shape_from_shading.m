% (C) Copyright Kirill Lykov 2013.
%
% Distributed under the FreeBSD Software License (See accompanying file license.txt)

% clear all;
close all;
load('regions.mat');
% image = double(rgb2gray(imread('1_gray.jpg')));

image = double( imread('1_gray.jpg'));
% imshow(image,[0 255]);
depthlist={};
for i= 1:size(regions,1)
region_idx= regions(i,1).PixelList;
idx = sub2ind(size(I),region_idx(:,2),region_idx(:,1));
bckgroud=min(image(:));
b=ones(480)*255; 
b(idx)=image(idx);
% imageblur = imgaussfilt(b,1);
%% edge smooth 
%Its edges
E = edge(b,'canny');
%Dilate the edges
Ed = imdilate(E,strel('disk',2));
%Filtered image
Ifilt = imgaussfilt(b,2);
%Use Ed as logical index into I to and replace with Ifilt
imageblur=b; 
imageblur(Ed) = Ifilt(Ed);
% imshow(imageblur,[0 255]);
%% SFS
depth = shapeFromShading(imageblur, 1000, 1/5);
depth=ones(size(depth))*depth(20,20)-depth;
depthlist{i}=depth;
% depth(idx)=depth(idx)+depth1(idx);

figure
% mesh(depth);
% title('Surface reconstruction');
% clf;
surf(depth*10)
shading interp;
axis('equal');
view(110,45);
axis('off');
camlight('headlight') 
end 
sum=zeros(size(depth));
for i=1:10
sum=sum+depthlist{i};
end
figure
surf(sum(20:450,20:450)*10)
shading interp;
axis('equal');
view(110,45);
axis('off');
camlight('headlight') 

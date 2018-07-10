clc
clear
close all
A = imread('Connected.bmp');
figure
imshow(A)
title('ORIGINAL IMAGE')
S= size(A);
% for thresholding
for i = 1:600
for j = 1:800
if (A(i,j)== 0)
BW(i,j) = 1;
else
BW(i ,j) = 0;
end
end
end
% B is the binary image
figure
imshowpair(A,BW,'montage');
title('THRESHOLDED IMAGE');
C = ones([S(1)+2,S(2)+2]);
C(2:size(C,1)-1,2:size(C,2)-1)= BW ;
Original = C;
k =1;
equi = [];
for i=2:size(C,1)-1
for j=2:size(C,2)-1
Nn = C(i-1,j);
Wn = C(i,j-1);
val = [];
if( i-2 ==0 || C(i,j)== BW(i-2,j-1))
val(length(val)+1) = Nn;
end
if(j-2 == 0 || C(i,j)== BW(i-1,j-2))
val(length(val)+1)= Wn;
end
if (isempty(val) || max(val)<2)
k = k+1;
C(i,j)=k;
equi(k) = k;
else
if(min(val)>1)
C(i,j)=min(val);
if(min(val)~=max(val))
equi(max(val)) = min(val);
end
else
C(i,j)=max(val);
end
end
end
end
% loop for finding equivalent labels and finding their root
D = C(2:size(C,1)-1,2:size(C,2)-1);
for label = length(equi) : -1 : 2
assigned = label;
while ( equi(assigned) ~= assigned )
assigned = equi(assigned);
end
equi(label) = assigned;
end
flabel = zeros ( 1, length(equi) );
p = 0;
% counting equivalent classes' elements
for comp = 1 : length(equi)
if ( equi(comp) == comp )
p = p + 1;
flabel(comp) = p;
end
end
flabel = flabel*(ceil(256/max(flabel)));
for i = 1:size(D,1)
for j = 1:size(D,2)
D(i,j)= flabel(equi(D(i,j)));
end
end
figure
imshow(uint8(D));
title('CONNECTED COMPONENTS')
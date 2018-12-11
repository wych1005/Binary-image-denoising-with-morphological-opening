function out = morph_open(n, BI) 
%% to create a disc-shaped structuring element (for odd n)
[X,Y] = meshgrid(-floor(n/2):floor(n/2), -floor(n/2):floor(n/2));
kern = sqrt(X.^2 + Y.^2);

for i=1:size(kern,1)
    for j=1:size(kern,2)
        if kern(i,j)>ceil(sqrt(n))+1
            kern(i,j)=0;
        else
            kern(i,j)=1;
        end
    end
end
%% Erosion
Pad=zeros(size(BI,1)+(n-1),size(BI,2)+(n-1));       
Pad((n-(n-1)/2):(end-(n-1)/2),(n-(n-1)/2):(end-(n-1)/2))=BI;
C = Pad;
D=zeros(size(BI));
B = kern;
for i=1:size(C,1)-(n-1)
    for j=1:size(C,2)-(n-1)
        In=C(i:i+(n-1),j:j+(n-1));
        %Find the position of ones in the structuring element
        In1=find(B==1);
        %Check whether the elements in the window have the value one in the
        %same positions of the structuring element
        if(In(In1)==1)
        D(i,j)=1;
        end
    end
end

%% Dilation
Pad=zeros(size(BI,1)+(n-1),size(BI,2)+(n-1));        % BI is the matrix of binary (BW) image
Pad((n-(n-1)/2):(end-(n-1)/2),(n-(n-1)/2):(end-(n-1)/2))=D;
C = Pad;

E=zeros(size(BI));
for i=1:size(C,1)-(n-1)
    for j=1:size(C,2)-(n-1)
        %Perform logical AND operation
        E(i,j)=sum(sum(B&C(i:i+(n-1),j:j+(n-1))));
    end
end

out = imshow(E);
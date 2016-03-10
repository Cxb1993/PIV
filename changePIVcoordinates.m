%function to change the coordinates of the vectorial field (the speed is
%not affected) it recognizes the borders of the image though the detection
%of the limits where speed is consirable low (less than 20 percent of the
%average of the rest).
%   PARAMETERS
%    OpenFile: name of the txt file whose coordinates are going to be
%       changed
%    safeFile: name of the txt file where the 
%    Xn: 2-size horizontal vector withthe inferior and superior limit of
%       the x coordinate. It may be an empy vector in case only the
%       vertical coordinates are to be changed.
%    Yn: a vector that can be empty in case on changing only the X
%       cordinates, a scalar in case of wanting to change only the inferior
%       point and scaling with the scale factor given by Xn
%    forced: true for forcing a scale factor to 1 and adjust the limits
%       given. Useful when the actual scale factor obtained from the
%       coordinates given by the user is close to 1.
function scale=changePIVcoordinates(openFile,saveFile,Xn, Yn,forced)
fid = fopen(openFile);
C = textscan(fid, '%f %f %f %f');
fclose(fid);
X=C{1};
Y=C{2};
U=C{3};
V=C{4};


if(size(Xn)==[1 2])
    %find the max and min X inside the tube by looking for the x position
    %were there is considerably more movement
    Xu=unique(X);
    n=size(Xu,1);
    S=(U.^2+V.^2).^0.5;
    S=reshape(S,n,int32(size(S,1)/n));
    Sm=sum(S==0,2);
    [Smm k]=sort(Sm,'descend');
    i=setdiff(1:size(Sm,1),k(1:3));
    
    xmin=min(Xu(i));
    xmax=max(Xu(i));
    
    scale(1,1)=(Xn(2)-Xn(1))/(xmax-xmin);
    if(forced(1))
        Xnn(1)=(Xn(2)*(scale(1,1)-1)+Xn(1)*(scale(1,1)+1))/(2*scale(1,1));
        Xnn(2)=Xn(1)-Xnn(1)+Xn(2);
        Xn=Xnn;
        scale(1,1)=(Xn(2)-Xn(1))/(xmax-xmin);
    end
        
        
    Xr=(X-xmin)*scale(1,1)+Xn(1);
else
    scale(1,1)=1;
    Xr=X;
end

if(size(Yn)==[1 2])
    Yu=unique(Y);
    scale(1,2)=(Yn(2)-Yn(1))/(max(Yu)-min(Yu));
    
	if(forced(2))
        Ynn(1)=(Yn(2)*(scale(1,2)-1)+Yn(1)*(scale(1,2)+1))/(2*scale(1,2));
        Ynn(2)=Yn(1)-Ynn(1)+Yn(2);
        Yn=Ynn;
        scale(1,2)=(Yn(2)-Yn(1))/(max(Yu)-min(Yu));
    end
    Yr=(Y-min(Yu))*scale(1,2)+Yn(1);
    
elseif(size(Yn)==[1 1])
    Yu=unique(Y);
    scale(1,2)=scale(1,1);
    Yr=(Y-min(Yu))*scale(1,2)+Yn(1);
else
    Yr=Y;
end
fid = fopen(saveFile,'w+');
fprintf(fid, '%.1f\t %.1f\t %.3f\t %.3f\n', [Xr Yr U V]');
 
fclose(fid);




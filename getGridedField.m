%Recieves matrices X and Y containing the x and y coordinates of all the
% PIV files analysed were each column contains the information of one only
% file and a partition vector which indacates the partition of the vector 
% field that might be performe. 
% It's suposed tu return an array of struct containg the sub division
% of the field for posterior analysis.
function [matrix, XX, YY]= getGridedField(X,Y, U,V,time, partition)

xi=min(min(X));
xf=max(max(X));
yi=min(min(Y));
yf=max(max(Y));

%Calculation of the intervals for making the partition.
XX=linspace(min(X(:)),max(X(:)),partition(1)+1);
YY=linspace(min(Y(:)),max(Y(:)),partition(2)+1);


%initialization of the structure for the matrix:
% matrix has:
%       x: vector containing the interval of x axe for the cell.
%       y: vector containing the interval of x axe for the cell.
%       x: vector containing the interval of x axe for the cell.

matrix.xlim=[];
matrix.ylim=[];

matrix.u=[];
matrix.v=[];
matrix.urms=[];
matrix.vrms=[];
matrix.It=[];
matrix.xlim=[];
matrix.ylim=[];

matrix.Umean=zeros(size(time));
matrix.stdUmean=zeros(size(time));
matrix.Vmean=zeros(size(time));
matrix.stdVmean=zeros(size(time));
matrix.weight=zeros(size(time));


matrix.fit.V.vmean=[];
matrix.fit.V.u0=[];
matrix.fit.V.Cd=[];
matrix.fit.V.vcor=[];
matrix.fit.V.rsquare=[];
matrix.fit.V.u0_upper=[];
matrix.fit.V.u0_lower=[];
matrix.fit.V.Cd_upper=[];
matrix.fit.V.Cd_lower=[];  
matrix.fit.V.vcor_upper=[];
matrix.fit.V.vcor_lower=[];  


matrix(1:partition(1),1:partition(2))=matrix;



%Ploting the partition on the velocity vector field graph
figure(1);
hold on;
for i=1:partition(1)+1
    plot([XX(i) XX(i)],[YY(1) YY(partition(2)+1)],'red');
end
for i=1:partition(2)+1
    plot([XX(1) XX(partition(1)+1)],[YY(i) YY(i)],'red');
end
hold off


for i=1:partition(1)

    for j=1:partition(2)

        matrix(i,j).xlim=[XX(i) XX(i+1)];
        matrix(i,j).ylim=[YY(j) YY(j+1)];
        for k=1:size(time,1)
            l=X(:,k)>= matrix(i,j).xlim(1) & X(:,k)<= matrix(i,j).xlim(2) & ...
              Y(:,k)>= matrix(i,j).ylim(1) & Y(:,k)<= matrix(i,j).ylim(2);
            
            
            [m2 n2]=size(U(l,k));
            if(k>1)
                [m1 n1]=size(matrix(i,j).u);
                
                if(m1<m2)
                    matrix(i,j).u(m1+1:m2,:)=zeros(m2-m1,n1);
                    matrix(i,j).v(m1+1:m2,:)=zeros(m2-m1,n1);
                    matrix(i,j).x(m1+1:m2,:)=zeros(m2-m1,n1);
                    matrix(i,j).y(m1+1:m2,:)=zeros(m2-m1,n1);
                    
                end
   
            end
            
            matrix(i,j).u(1:m2,k)=U(l,k);
            matrix(i,j).v(1:m2,k)=V(l,k);
            matrix(i,j).x(1:m2,k)=X(l,k);
            matrix(i,j).y(1:m2,k)=Y(l,k);
%calculation of velocity means excluding values whose mean geometrical
%velocity is 0
            r=matrix(i,j).u(:,k)~=0;
            p=matrix(i,j).v(:,k)~=0;
            q=r|p;
            matrix(i,j).Umean(k)=mean(matrix(i,j).u(q,k));
            matrix(i,j).stdUmean(k)=std(matrix(i,j).u(q,k));
            matrix(i,j).Vmean(k)=mean(matrix(i,j).v(q,k));
            matrix(i,j).stdVmean(k)=std(matrix(i,j).v(q,k));
            matrix(i,j).weight(k)=mean(numel(matrix(i,j).v(q,k)));
        end

        
    end
end




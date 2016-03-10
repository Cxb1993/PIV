function pColorMatrix(Q)
[m n]=size(Q);
Q(m+1,:)=Q(m,:);
Q(:,n+1)=Q(:,n);
pcolor(Q);
Q=Q(m,n);


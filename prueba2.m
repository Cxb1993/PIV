i=1;
j=5;
k=100;

uij=matrix(i,j).u(:,k);
vij=matrix(i,j).v(:,k);
xij=matrix(i,j).x(:,k);
yij=matrix(i,j).y(:,k);

vectorialFieldFigure(xij, yij, vij, vij, ...
    [min(xij(:)) max(xij(:))], [min(yij(:)) max(yij(:))] ,t(k));

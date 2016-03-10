function matrix=parameterSmoothing(matrix,time, MCd,Mu0,Mvcor)
n=10;
MCd=smoothts(smoothts(MCd,'e',1/n),'e',n);
Mvcor=smoothts(smoothts(Mvcor,'e',1/n),'e',n);
Mu0=smoothts(smoothts(Mu0,'e',1/n),'e',n);

for i=numel(matrix)
    
    matrix(i).fit.V.Cd=MCd(i);
    matrix(i).fit.V.u0=Mu0(i);
    matrix(i).fit.V.vcor=Mvcor(i);
    matrix(i).fit.V.vmean=VelocityParticule(time,MCd(i),Mu0(i),Mvcor(i));
    
end



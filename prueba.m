function prueba()
global param
rhop=param.Solid.rho; %particule density
D=param.Solid.D; %particle diameter
g=param.g; %gravity
%Cd=param.Cd; %friction coefficient for particle and air
R=param.R; %ideal gas constant
Va=param.Va; %Volume of gas reservoir
Atube=param.Atube; 
Afinal=param.Afinal;
rho=param.Air.rho; %air density
Cp=param.Air.Cp; %air heat capacity
T0=param.Air.T0; %initial air temprature
P0=param.Air.P0; %initial air pressure
Pf=param.Air.Pf; %final air pressure
M=param.Air.M; %final air pressure

t=0:1E-3:0.3;
Cv=Cp-R;
Tf=T0*(Pf/P0)^(R/Cp);
tf=2*Cv*Va/(sqrt(2*Cp*Tf/M)*Atube*R)*atan(sqrt((T0-Tf)/Tf));

vair(t<tf)=sqrt(2*Cp*Tf/M)*tan(atan(sqrt((T0-Tf)/Tf))-sqrt(2*Cp*Tf/M)*Atube*R*t(t<tf)/(2*Cv*Va));
gamma=Cp/Cv;


Psi=(P0/Pf)^(R/Cp);
tau=Cv*Va/(Atube*R)*sqrt(2*M*Psi/(Cp*T0));
tf=tau*atan(sqrt(Psi-1));

vsonic=2*Va*sqrt(2*gamma*R*T0)./(sqrt(2*gamma*R*T0)*(gamma-1)*Atube*t+2*Va*sqrt(M*(gamma+1)));

vair2(t<tf)=sqrt(2*Cp*T0/(M*Psi))*(sqrt(Psi-1)-tan(t(t<tf)/tau))./(1+sqrt(Psi-1)*tan(t(t<tf)/tau));


vair(t>=tf)=0;
vair2(t>=tf)=0;
figure(11)
plot(t,vair)
hold on
plot(t,vair2,'+')
plot(t,vsonic)
hold off
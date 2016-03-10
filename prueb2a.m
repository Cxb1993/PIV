function prueba()
global param

param.Solid.rho=490; %particule density 2500 glass / 490 Starch
param.Solid.D=25e-6; %particle diameter mean([83 90])*1-6 86e-6 glass 25e-6 Starch
param.g=9.81; %gravity
param.Cd=0.4; %friction coefficient for particle and air
param.R=8.314; %ideal gas constant
param.Va=50e-6; %Volume of gas reservoir
param.Atube=pi*(3.23E-3/2).^2; %3.23E-3
param.Afinal=7e-2^2;
param.Air.rho=1.14; %air density
param.Air.Cp=29; %air heat capacity
param.Air.T0=298; %initial air temprature
param.Air.P0=8e5; %initial air pressure
param.Air.Pf=1e5; %final air pressure
param.Air.M=29E-3; %molar weight

rhop=param.Solid.rho; %particule density
D=param.Solid.D; %particle diameter
g=param.g; %gravity
%Cd=param.Cd; %friction coefficient for particle and air
R=param.R %ideal gas constant
Va=param.Va %Volume of gas reservoir
Ab=param.Atube
Ac=param.Afinal;
rho=param.Air.rho; %air density
Cp=param.Air.Cp %air heat capacity
Ta0=param.Air.T0 %initial air temperature
Pa0=param.Air.P0 %initial air pressure
Pc=param.Air.Pf %final air pressure
M=param.Air.M %final air pressure

Cv=Cp-R;
gamma=Cp/Cv;
t=0:1e-4:0.2;

%% sonic
v_choked0=sqrt(2*gamma*R*Ta0/((gamma+1)*M));
tau_choked=2*Va/((gamma-1)*Ab*v_choked0);
tau_choked=2*Va/((gamma-1)*Ab*v_choked0)*((gamma+1)/2)^(1/(gamma-1));
t_choked=tau_choked*(sqrt(2/(gamma+1))*(Pa0/Pc)^((gamma-1)/(2*gamma))-1)

v(t<=t_choked)=v_choked0*(1+t(t<=t_choked)/tau_choked).^-1;
Pa(t<=t_choked)=Pa0*(1+t(t<=t_choked)/tau_choked).^(-2*gamma/(gamma-1));
Ta(t<=t_choked)=Ta0*(1+t(t<=t_choked)/tau_choked).^-2;
%dtadt=@(t,Ta)-Ab*R/(Cv*Va)*sqrt(gamma*R/M)*(2/(gamma+1))^((gamma+1)/(2*gamma-2))*Ta.^(3/2);
%[tnum Tanum]=ode23s(dtadt,[t(t<=t_choked)],Ta0);
%Ta(t<=t_choked)=Tanum;
Tb(t<=t_choked)=Ta0*(2/(gamma+1))*(1+t(t<=t_choked)/tau_choked).^-2;
Pb(t<=t_choked)=Pa0*(2/(gamma+1))^(gamma/(gamma-1))*(1+t(t<=t_choked)/tau_choked).^(-2*gamma/(gamma-1));


%% subsonic
Pa0x=Pc*((gamma+1)/(2))^(gamma/(gamma-1))
tau_subsonic=Va/Ab*sqrt(2*M/(gamma*(gamma-1)*R*Ta0))*(Pa0/Pc)^((gamma-1)/(2*gamma))*6.7
t_subsonic=tau_subsonic*atan(sqrt((Pa0x/Pc)^((gamma-1)/gamma)-1))+t_choked
t2=t_choked:1e-4:t_subsonic;
v_subsonic=sqrt(2*gamma*R*Ta0/((gamma-1)*M))*(Pc/Pa0)^((gamma-1)/(2*gamma))*tan((t_subsonic-t2)/tau_subsonic);
P_subsonic=Pc*(sec((t_subsonic-t2)/tau_subsonic)).^(2*gamma/(gamma-1));
T_subsonic=Ta0*(Pc/Pa0)^((gamma-1)/gamma)*(sec((t_subsonic-t2)/tau_subsonic)).^2;
Tbf=Ta0*(Pc/Pa0)^((gamma-1)/gamma);
dtadt=@(t,Ta)-Ab*R/(Cv*Va)*Tbf^(1/(gamma-1))*Ta.^((gamma-2)/(gamma-1)).*sqrt(2*Cp*abs(Ta-Tbf))*(1-1*cast(Tbf>Ta,'double'));
[tnum Tanum]=ode23s(dtadt,[t(t>=t_choked)],Ta0*(1+t_choked/tau_choked).^-2);
Ta(t>=t_choked)=Tanum;
Ta(Ta<Tbf)=Tbf;

Pa(t>=t_choked)=Pa0*(Tanum/Ta0).^(gamma/(gamma-1));
v(t>=t_choked)=sqrt(2*Cp*(Ta(t>=t_choked)-Tbf)/M);
Tb(t>=t_choked)=Ta0*(Pc/Pa0)^((gamma-1)/gamma);
Pb(t>=t_choked)=Pc;
t_disp=t(length(v(v>0))+1)
min(Ta-Tbf)

%% plot data
figure(10)
%------------VELOCITY-------------
subplot(1,3,1)
plot(t,v)
hold on
plot(t_choked*[1 1],[min(v) max(v)],':k')
plot(t2,v_subsonic,'g')
hold off
%---------TEMPERATURE--------------
subplot(1,3,2)
plot(t,Tb,'r')
hold on
plot(t,Ta)
plot(t_choked*[1 1],[min(Ta) max(Ta)],':k')
plot(t2,T_subsonic);
hold off
%--------PRESSURE
subplot(1,3,3)
plot(t,Pb*1E-5,'r')
hold on
plot(t2,P_subsonic*1e-5,'g')
plot(t,Pa*1e-5)
plot(t_choked*[1 1],1E-5*[min(Pa) max(Pa)],':k')
hold off




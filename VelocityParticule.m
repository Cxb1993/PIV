%function of the velocity of particles dispersed with an air pulse as a
%function of time
%   INPUT PARAMETERS
%       t: time vector
%       Co: Discharge coefficient 0<=Co<=1
%       u0: Initial velocity for the sedimentation model
%   OUPUT PARAMETERS
%       vel: velocity of particles vair +
%       vair: velocity of air
%       vsed: velocity of
function [ vel, vair, vsed, t_sonic, t_subsonic, tau_choked,tau_p,v_choked0,v_chokedf,phi] =VelocityParticule(t,K,u0)

global param
rhop=param.Solid.rho; %particule density
D=param.Solid.D; %particle diameter
g=param.g; %gravity
Cd=param.Cd; %friction coefficient for particle and air
rho=param.Air.rho; %air density
mu=param.Air.mu;

%% Air velocity
if(nargout>=4)
    [vair , t_sonic, t_subsonic,tau_choked,v_choked0,v_chokedf]=chamberexpansion(t,K, false);
else
    [vair]=chamberexpansion(t,K, false);
end
%% Particule sedimentation, particule velocity relative to air
tau_p=rhop*D^2/(18*mu);
phi=g*D^2*(rhop-rho)/(18*mu);
u=(u0+phi)*exp(-t/tau_p)-phi;

%% cartesian velocity
vel=vair(:)+u(:);
vair=vair(:);
vsed=u;

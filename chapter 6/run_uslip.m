%% U-SLIP for PATRICK
clear;clc;close all;

% Define start and stop times, set a dt to keep outputs at constant time
% interval
tstart = 0;
tfinal = 50;
dt = 0.001;

% Initialize state and contact mode
x0 = [0; 0; 1.25; 0];
mode = 1;

M = 0.35;
m = 0.05;
X = 1;
Y = 1;
r_0 = 0.25;
pw = 1;
V = M/1.2;
g = 9.81;
k =  10;
alpha = 60*pi/180;
x_t = 0;
td = 0;
r_s = 0.1;
delr = 1/10;


a = X*r_0/(m + M);
b = Y*r_0/(m + M);
c = (M - pw*V)/(m + M);
d = k*r_0/(m*g + M*g);

a = 2.5;
b = 5;
c = 0.3;
d = 10;
alpha = 2*pi/5;
delr = 1/10;
r_0 = 0.3;
r_s = 0.1;

% a1 = y;
% a2 = x + y + 1;
% a3 = (x - 2)^2 + (y - 1)^2;
%% Main Loop

% Tell ode45 what event function to use and set max step size to make sure
% we don't miss a zero crossing
options = odeset('Events', @(t,x)uslip_guardFunctions(t,x,r_s,mode,a,b,c,d,x_t,r_0,td,delr,alpha),'MaxStep',0.01);

% Initialize output arrays

tout = [];
xout = [];
teout = [];
xeout = [];
ieout = [];
% Main simulation loop
while tstart < tfinal
    options = odeset('Events', @(t,x)uslip_guardFunctions(t,x,r_s,mode,a,b,c,d,x_t,r_0,td,delr,alpha),'MaxStep',0.01);

    % Initialize simulation time vector
    tspan = [tstart:dt:tfinal];
    
    % Simulate with ode45
    [t,x,te,xe,ie] = ode45(@(t,x)uslip(t,x,r_s,mode,a,b,c,d,x_t,r_0,td,delr), tspan, x0, options);
    
    % Sometimes the events function will record a nonterminal event if the
    % initial condition is a zero. We want to ignore this, so we will only
    % use the last row in the terminal state, time, and index.
    if ~isempty(ie)
        te = te(end,:);
        xe = xe(end,:);
        ie = ie(end,:);
    end
    
    % Log output
    nt = length(t);
    tout = [tout; t(2:nt)];
    xout = [xout; x(2:nt,:)];
    teout = [teout; te];
    xeout = [xeout; xe];
    ieout = [ieout; ie];
    
    % Quit if simulation completes
    if isempty(ie) 
        disp('Final time reached');
        break; % abort if simulation has completed
    end
    
    % If flag was caused by a_i < 0 (i not in contact mode), compute the
    % proper contact mode via IV complemetarity
    
    l = sqrt((xe(1)-x_t)^2 + xe(3)^2);
    a1 = xe(3) - sin(alpha);
    a2 = l - 1 - delr;

    %a2 = xe(1) + xe(2) + 1;
    if a1 <= 0 && mode == 1
        mode = 2;
        td = te;
        x_t = xe(1) - cos(alpha);
        x0 = xe';
        a2 = -1;
    end
    
    % Check to see if there should be liftoff (positive lambda), if so
    % compute the proper contact mode via FA complementarity
    if a2 >= 0 && mode == 2
        mode = 1;
        x0 = xe';
    end
    
    if xe(3) < 0
        break
    end
    
    % Update initial conditions for next iteration
    
    tstart = t(end);
    
end

% This function shows animation for the simulation, don't modify it
%animateHW10(xout, dt);

yyaxis left
plot(tout,xout(:,1))
yyaxis right
plot(tout,xout(:,3))
ylim([-0.5 1.5])
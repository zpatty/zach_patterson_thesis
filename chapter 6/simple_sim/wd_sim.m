clear
close all

syms M l theta(t) p D h C tau
Mmat = [0.01; 0.02; 0.0475; 0.06; 0.08; 0.1; 0.12];
%Mmat = linspace(0.01, 0.9, 20);
mmat = 0.13 - Mmat;
l = 0.1;
p = 1000;
D = 0.05;
h = 0.035;
C = 1.15;
tau = 0.05;
mu = 0.8;
g = 9.81;
options = odeset('Events', @(t,x)guardFunctions(t,x),'MaxStep',0.01);
mode = 1;




% Log output
% nt = length(t);
% tout = [tout; t(2:nt)];
% xout = [xout; x(2:nt,:)];
% teout = [teout; te];
% xeout = [xeout; xe];
% ieout = [ieout; ie];
for i=1:length(Mmat)
    mode = 1;
    x0 = [0;0];
    tspan = [0 1000];
    M = Mmat(i);
%     m = mmat(i);
    eqn = M*l^2*diff(theta, 2) + (0.5*C*D*h*l^3*p+mu*M*g)*diff(theta)^2 == tau;
    cond1 = theta(0) == pi/180*(90-72);

    % ysol(t) = dsolve(eqn,cond1);

    [V] = odeToVectorField(eqn);

    Mf = matlabFunction(V,'vars', {'t','Y'});

    sol = ode45(Mf,[0 1],[0 0]);

%     fplot(@(x)deval(sol,x,1), [0, 1]);
%     hold on
    l_mat(i) = (l*sin(sol.y(1,end)-sol.y(1,1)));
% COT(i) = tau^2/0.13/(l*sin(sol.y(1,end)-sol.y(1,1)));

    tau1 = 0.05;
    [t,x,te,xe,ie] = ode45(@(t,x)weight_dist1_ode(t, x, M, tau1, mode), tspan, x0, options);

    if ~isempty(ie)
        te1 = te(end,:);
        xe = xe(end,:);
        ie = ie(end,:);
    end

    a1 = x(end,1) - pi/2;
    mode = 2; 
    tau2 = 0.05/1000000;
    tspan = [te 1000];
    x0 = xe';

    [t,x,te,xe,ie] = ode45(@(t,x)weight_dist1_ode(t, x, M, tau2, mode), tspan, x0, options);
    
    if ~isempty(ie)
        te2 = te(end,:);
        xe = xe(end,:);
        ie = ie(end,:);
    end
    
    a2 = x(end,1) + 0.001;
    te_mat(i,1) = te1;
    te_mat(i,2) = te2;
    COT(i) = (tau1^2*te1 + tau2^2*(te2 - te1))/0.13;
    
    
    
end
% legend('0.01', '0.02', '0.0475', '0.06', '0.08', '0.1', '0.13')

figure
plot(Mmat,COT)
COT
te_mat
l_mat
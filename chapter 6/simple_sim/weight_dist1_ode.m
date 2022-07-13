function dtdt = weight_dist1_ode(t, y, M, tau, mode)

l = 0.1;
p = 1000;
D = 0.05;
h = 0.035;
C = 1.15;
mu = 0.4;
g = 9.81;
m = 0.13 - M;

M = M + m*3/5;
m = m*2/5;
if mode ==1
    dtdt = [y(2); tau/(M*l^2) - (0.5*C*D*h*l^3*p*y(2)^2+mu*M*g*y(2)^2)/(M*l^2)];
else
    dtdt = [y(2); - tau/(m*l^2) + (1/6*C*0.015*l^4*p)*y(2)^2/(m*l^2)];
end
end
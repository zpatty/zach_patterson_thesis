%% U-SLIP Guard
function [constraintFcns,isterminal,direction] = slip_to_swim(t,q,u,params)

L = q(1);
Ldot = q(2);
theta = q(3);
omega(4);

x = L*cos(theta);
y = L*sin(theta);

k = params(1);
b = params(2);
kappa = params(3);
beta = params(4);
g = params(5);
p = params(6);
V_b = params(7);
M = params(8);
m_L = params(9);
C_drag_body = params(10);
A_b = params(11);
C_drag_leg = params(12);
W_leg = params(13);
C_lift = params(14);

a1 = y - sin(alpha);


constraintFcns = [a1, a2];

isterminal = [true; true];

direction = [-1; 1];

end
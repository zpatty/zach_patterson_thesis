function qdot = uswim(t,q)

x = q(1);
vx = q(2);
y = q(3);
vy = q(4);
theta = q(5);
omega = q(6);

k = params(1);
b = params(2);
kappa = params(3);
beta = params(4);
g = params(5);
p = params(6);
V_b = params(7);
M = params(8);
m_L = params(9);
C_db = params(10);
A_b = params(11);
C_drag_leg = params(12);
W_leg = params(13);
C_lift = params(14);

qdot(1) = q(2);
qdot(3) = q(4);
qdot(5) = q(6);

L = sqrt(x^2 + y^2);
theta = atan(y/x);

F_L = k(L - u_L) +b(x(2) - u_Ldot);
tau_R = kappa*(theta - u_theta) + beta*(x(4) - u_thetadot);

F_fld = sum(g*[p*V_b; -M; -mL]);
tau_fld = L*sum([p*V_b; -M; -0.5*mL])*cos(theta);

v_drag_L = -sin(theta)*vx + cos(theta)*vy;
v_lift_L = cos(theta)*vx +sin(theta)*vy;

sign_v = sign(1/2*L*(2*v_drag_L + L*omega));
F_dbX = p/2*C_db*A_b*abs(vx)*vx;
F_dbY = p/2*C_db*A_b*abs(vy)*vy;

F_dL = p/2*C_drag_leg*W_L*sign_v*(v_drag_L^2*L + omega*v_drag_L*L^2 + (omega^2*L^3)/3);
F_lL = -C_lift/2*p*L*W_L*v_lift_L*abs(v_lift_L);

F_gL = mL*g;

qdot(2) = (-(F_lL +F_dL)*sin(theta) + F_dbX)/(M +mL);
qdot(4) = (F_fld + (F_lL +F_dL)*cos(theta) +F_dbY)/(M +mL);
qdot(6) = (1/2*L*F_gL*cos(theta) + F_dL*L_cpd + F_lL*L_cpl + tau_R)/(1/3*m*L^2);



end
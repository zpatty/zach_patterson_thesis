function xdot = uslip(t,x,u,params)

xdot(1) = x(2);
L = x(1);
xdot(3) = x(4);
theta = x(3);
omega = x(5);
L_dot = x(6);

xdot = L_dot*cos(theta) - L*omega*sin(theta);
ydot = L_dot*sin(theta)+L*omega*cos(theta);

u_L = u(1);
u_Ldot = u(2);
u_theta = u(3);
u_thetadot = u(4);

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

F_L = k(L - u_L) +b(x(2) - u_Ldot);
tau_R = kappa*(theta - u_theta) +beta*(x(4) - u_thetadot);

F_fld = sum(g*[p*V_b; -M; -m_L]);
tau_fld = L*sum([p*V_b; -M; -0.5*m_L])*cos(theta);

v_drag_L = -sin(theta)*xdot + cos(theta)*ydot;
v_lift_L = cos(theta)*xdot +sin(theta)*ydot;

sign_v = sign(1/2*L*(2*v_drag_L + L*omega));
F_drag_body_tangential = p/2*C_drag_body*A_b*abs(L*omega)*L*omega;
F_drag_body_radial = p/2*C_drag_body*A_b*abs(L_dot)*L_dot;

F_drag_leg = p/2*C_drag_leg*W_leg*sign_v*(v_drag_L^2*L + omega*v_drag_L*L^2 + (omega^2*L^3)/3);
F_lift_L = -C_lift/2*p*L*W_leg*v_lift_L*abs(v_lift_L);

L_cpd = (1/4*L^3*omega^2 + 2/3*L^2*omega*v_drag_L + 1/2*L*v_drag_L^2)/(1/3*L^2*omega^2 + L*omega*v_drag_L + v_drag_L^2);
L_cpl = 1/2*L;

xdot(2) = (-F_drag_body_radial - F_fld*sin(theta)- F_L)/(M+m_L);
xdot(4) = (F_drag_body_tangential*L + F_drag_leg*L_cpd - tau_fld - tau_R)/((M+1/3*m_L)*L^2);
    
xdot = xdot';
end
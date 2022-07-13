clear
close all

x1 = 2/3;
y1 = 2;
z1 = 0;
u1 = 1/norm([x1 y1 z1]) * [x1 y1 z1];

syms alpha_1 alpha_2 theta L
% assume(alpha > 0 & alpha < 2*pi)
% assume(beta > 0 & beta < 2*pi)
% assume(theta > 0 & theta < 2*pi)
% assume(phi > 0 & phi < 2*pi)
% 
% mag = 1/norm([2/3 2 0]);
% u1 = [mag*2/3, mag*2, 0];
% R_1 = get_new_rotations(u1, alpha);
% 
% u2 = [mag*2/3, -mag*2, 0];
% R_2 = get_new_rotations(u2, beta);
% 
% 
% R_x = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
% R_y = [cos(phi) 0 sin(phi); 0 1 0; -sin(phi) 0 cos(phi)];
% 
% eqns = R_1*R_2 == R_x*R_y;
% 
% eqns = reshape(eqns,1,[]).';
% s = solve(eqns, [alpha, beta],'ReturnConditions',true, 'Real', true)

% phi_1 = atan(1/3);
% phi_2 = atan(-1/3);
% 
% x = L/alpha_1*cos(phi_1)*cos(alpha_1 - 1) + L/alpha_2*cos(phi_2)*cos(alpha_2 - 1);
% y = L/alpha_1*sin(phi_1)*cos(alpha_1 - 1) + L/alpha_2*sin(phi_2)*cos(alpha_2 - 1);
% z = L/alpha_1*sin(alpha_1) + L/alpha_2*sin(alpha_2);

syms s e_i

L = 0.09355;
E = 0.19e6;
b = 0.0055;
a = 0.011;
Ix = a*b^3/12;
Iy = a^3*b/4;
phi = atan(1/3);
kp = 3.6;
kI = 0.2;
kD = 0.9;

G = L/2/E*[cos(phi)/Iy, cos(phi)/Iy; sin(phi)/Ix, -sin(phi)/Ix]
[U, S, V] = svd(G)

syms kps kDs kIs
K = V*((kps*s + kDs*s^2 + kIs)/s)*inv(S)*U'

K_tf = V*tf({[kp kI], 0; 0, [kp kI]}, {[1 0],[1 0];[1 0],[1 0]})*inv(S)*U';

nums = {0.0039*[kD kp kI], 0.0039*[kD kp kI]; 9.7951e-04*[kD kp kI], -9.7951e-04*[kD kp kI]};

dens = {[1 0],[1 0];[1 0],[1 0]};
systf = tf(nums,dens)
syss = ss(systf)
Hanus = syss.B*inv(syss.D)

hanus_mat = syss.B*inv(syss.D)

new_tf = tf({G(1), G(2); G(3), G(4)},{1, 1; 1, 1});
[fact, M1, N1] = lncf(new_tf);


%-[K_tf; eye(2)]*tf(inv(eye(2) + new_tf*K_tf)*inv(M1))

%M = -[K_tf; eye(2)]*tf(inv(eye(2) + new_tf*K_tf)*inv(M1))






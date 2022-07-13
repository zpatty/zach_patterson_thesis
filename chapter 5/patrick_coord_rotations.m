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
kI = 0.83333;

G = L/E*[cos(phi)/Iy, cos(phi)/Iy; sin(phi)/Ix, -sin(phi)/Ix]
[U, S, V] = svd(G)

syms kps kis
K = V*((kps*s + kis)/s)*inv(S)*U'

K_tf = V*tf({[kp kI], 0; 0, [kp kI]}, {[1 0],[1 0];[1 0.0],[1 0.0]})*inv(S)*U';

nums = {0.0039*[kp kI], 0.0039*[kp kI]; 9.7951e-04*[kp kI], -9.7951e-04*[kp kI]};

dens = {[1 0.1],[1 0.1];[1 0.1],[1 0.1]};
systf = tf(nums,dens);
K_tf = minreal(K_tf);
systf = K_tf;
syss = ss(K_tf)
Hanus = syss.B*inv(syss.D)

hanus_mat = syss.B*inv(syss.D)

new_tf = tf({G(1), G(2); G(3), G(4)},{1, 1; 1, 1});
[fact, M1, N1] = lncf(new_tf);

%%
%-[K_tf; eye(2)]*tf(inv(eye(2) + new_tf*K_tf)*inv(M1))
tau = 1/100;
r0 = 0.2;
rinf = 2;
w = tf([tau, r0],[tau/rinf 1]);
%G = G*(eye(2) + w);
%M = -[K_tf; eye(2)]*tf(inv(eye(2) + new_tf*K_tf)*inv(M1))
M = inv(eye(2) + systf*(G + inv(syss.D)))*(eye(2) -systf*(G - inv(syss.D)));
R = systf*inv(syss.D) - eye(2);
%M = inv(2*eye(2) + R + systf*G)*(R - systf*G);
setlmis([]) 

M_ss = ss(M);
A = M_ss.A;
B = M_ss.B;
C = M_ss.C;
D = M_ss.D;
setlmis([]) 
X = lmivar(2,[length(A) length(A)]); 
S = lmivar(1,[2,0]);
W = lmivar(2,[2 2]);

% 1st LMI 
lmiterm([1 1 1 X],1,A,'s');
%lmiterm([1 1 1 S],C',C); 
lmiterm([1 1 2 X],1,B); 
lmiterm([1 1 2 W],-C',1); 
lmiterm([1 2 2 S],1,1);
lmiterm([1 2 2 W],-2,1);
lmiterm([1 2 2 W],-1,D);
lmiterm([1 2 2 W],-D',1);


% 2nd LMI 
lmiterm([-2 1 1 X],1,1);

% 3rd LMI
lmiterm([-3 1 1 S],1,1); 


LMISYS = getlmis;
[tmin,xfeas] = feasp(LMISYS)
T = dec2mat(LMISYS,xfeas,S)
[ninf,fpeak] = norm(T*M*inv(T),inf)
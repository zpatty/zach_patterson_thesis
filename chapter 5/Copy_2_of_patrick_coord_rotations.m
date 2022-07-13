clear
close all
%%
x0 = [3.6,0.83];
%x = fminsearch(@get_mu,x0)

%%
syms s e_i

L = 0.09355;
L = 0.05;
E = 1.9e6;
b = 0.0055;
a = 0.011;
r = 0.008;
Ix = a*b^3/12;
Iy = a^3*b/4;
Ix = pi/4*r^4;
Iy = Ix;
phi = atan(1/3);
phi = pi/4;
kp = 0.2;

kI = 0.05;

%kI = 4.32;
kD = 0;
%kD = 0.0;
dx = 3.981;
dy = 3.981;
d = 0.001;
sma = 0.001;
J = 0.03*(L/2)^2;

G = L/E*[cos(phi)*dx/Iy, cos(phi)*dx/Iy; sin(phi)*dy/Ix, -sin(phi)*dy/Ix]
G_tf = tf({[sma cos(phi)], [sma cos(phi)]; [sma sin(phi)], [sma -sin(phi)]},{[J d E*Iy/L/dx], [J d E*Iy/L/dx]; [J d E*Ix/L/dy], [J d E*Ix/L/dy]})
%G_tf = G;
[U, S, V] = svd(G)

% syms kps kis kds
% K = V*(kps*(1+1/s/kis + s*kds/(1+s*kds/10)))*inv(S)*U'

%K_s = kp*(1+tf(1,[kI 0.1])+ tf([kD 0],[kD/10 1]))
%K_s = kp*(1+tf(1,[kI 0])+ tf([kD 0],[kD/10 1]));
K_s = kp + tf(kI,[1 0.0]);
K_tf = V*[K_s, 0; 0, K_s]*inv(S)*U';
%K_tf = V*tf({[kD kp kI], 0; 0, [kD kp kI]}, {[1 1],[1 1];[1 1],[1 1]})*inv(S)*U';

% nums = {0.0039*[kp kI], 0.0039*[kp kI]; 9.7951e-04*[kp kI], -9.7951e-04*[kp kI]};
% 
% dens = {[1 0],[1 0];[1 0],[1 0]};
% systf = tf(nums,dens)
K_tf = minreal(K_tf)
syss = ss(K_tf)

hanus_mat = syss.B*inv(syss.D)

M = inv(eye(2) + K_tf*(G_tf + inv(syss.D)))*(eye(2) -K_tf*(G_tf - inv(syss.D)));
M = minreal(M)
R = K_tf*inv(syss.D) - eye(2);
%M = inv(2*eye(2) + R + K_tf*G_tf)*(R - K_tf*G_tf);
%eig(M)

%%
setlmis([]) 

M_ss = ss(M11);
A = M_ss.A;
B = M_ss.B;
C = M_ss.C;
D = M_ss.D;
setlmis([]) 
X = lmivar(1,[length(A) 1]); 
S = lmivar(1,[size(B,2),0]);
[X1,n,sX1] = lmivar(2,[2 2]); 
%[X2,n,sX2] = lmivar(1,[4 0]); 
[X3,n,sX3] = lmivar(1,[2 0]); 
%W = lmivar(2, [8 8]);
%[W,n,sW] = lmivar(3,[sX1,zeros(2,6);zeros(4,2),sX2,zeros(4,2);zeros(2,6), sX3]);
[W,n,sW] = lmivar(3,[sX1,zeros(2,2);zeros(2,2), sX3]);
W = lmivar(2, [2 2]);

% 1st LMI 
lmiterm([1 1 1 X],1,A,'s')
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
[tmin,xfeas] = feasp(LMISYS);
T = dec2mat(LMISYS,xfeas,W);
[ninf,fpeak] = norm(T*M_ss*inv(T),inf)

    
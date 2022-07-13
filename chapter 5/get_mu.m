function ninf = get_mu(x)

L = 0.09355;
E = 0.19e6;
b = 0.0055;
a = 0.011;
Ix = a*b^3/12;
Iy = a^3*b/4;
phi = atan(1/3);
kp = x(1);
kI = x(2);
%kI = 4.32;
kD = 0.1;
%kD = 0.0;
dx = 6;
dy = 2;

G = L/E*[cos(phi)/Iy, cos(phi)/Iy; sin(phi)/Ix, -sin(phi)/Ix];
G_tf = G;
[U, S, V] = svd(G);
K_s = kp + tf(kI,[1 0.000001]);
K_tf = V*[K_s, 0; 0, K_s]*inv(S)*U';

K_tf = minreal(K_tf);
syss = ss(K_tf);

hanus_mat = syss.B*inv(syss.D);

M = inv(eye(2) + K_tf*(G_tf + inv(syss.D)))*(eye(2) -K_tf*(G_tf - inv(syss.D)));
R = K_tf*inv(syss.D) - eye(2);

%%
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
[tmin,xfeas] = feasp(LMISYS);
T = dec2mat(LMISYS,xfeas,S);
x
[ninf,fpeak] = norm(T*M*inv(T),inf)

end
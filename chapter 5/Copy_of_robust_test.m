L = 0.09355;
E = 1.9e6;
Eu = ureal('Eu',1.9e6,'Percentage',30);
d = 0.0001; %ureal('d',0.1,'Percentage',30);
b = 0.0055;
a = 0.011;
Ix = a*b^3/12;
Iy = a^3*b/4;
phi = atan(1/3);
kp = 1.0;
kI = 0.1;
%kI = 4.32;
kD = 0.0;
%kD = 0.0;
dx = 0.006;
dy = 0.002;

G = L/E*[cos(phi)*dx/Iy, cos(phi)*dx/Iy; sin(phi)*dy/Ix, -sin(phi)*dy/Ix];
[U, S, V] = svd(G);

%G_tf = tf({cos(phi), cos(phi); sin(phi), -sin(phi)},{[d Eu*Iy/L/dx], [1 Eu*Iy/L/dx]; [1 Eu*Ix/L/dy], [1 Eu*Ix/L/dy]})
G1 = tf(cos(phi), [d Eu*Iy/L/dx]);
G2 = tf(cos(phi), [d Eu*Iy/L/dx]);
G3 = tf(sin(phi), [d Eu*Ix/L/dy]);
G4 = tf(-sin(phi), [d Eu*Ix/L/dy]);
G_tf = [G1, G2; G3, G4];

%G_tf = G;

delta = ultidyn('delta',[1 1]);
Wu = makeweight(0.1,20,1.5);
G = G_tf * (1+Wu*delta);

K_s = kp*(1+tf(1,[kI 0.01])+ tf([kD 0],[kD/10 1]));
K_tf = V*[K_s, 0; 0, K_s]*inv(S)*U';
K_tf = minreal(K_tf);
K_ss = ss(K_tf);
K = K_ss; 
hanus_mat = K.B*inv(K.D);

W = [1 0; 0 1];
Delta = ultidyn('Delta',[2 2],'Bound',0.5);
Delta = W*Delta;

R = K*inv(K_ss.D) - eye(2);

G.u = 'ua';  G.y = 'y';
K.u = 'e';  K.y = 'u';
R.u = 'usum'; R.y = 'v';
Delta.u = 'u'; Delta.y = 'ua';
S1 = sumblk('e = v + r - y',2);
S2 = sumblk('usum = ua - u',2);
ClosedLoop = connect(G,K,R,S1,S2,Delta,'r','y',{'e','u','ua'});
[DMo,MMo] = diskmargin(ClosedLoop)
opt = robOptions('Display','on');
stabmarg = robstab(ClosedLoop,opt)
bodemag(ClosedLoop)
M = getIOTransfer(ClosedLoop,{'ua','r'},{'u','e'});
[DMo,MMo] = diskmargin(M);
%bodemag(M);
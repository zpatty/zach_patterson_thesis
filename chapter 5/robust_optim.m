function marg = robust_optim(x)



L = 0.09355;
E = 0.19e6;
Eu = E;% ureal('Eu',E,'Percentage',30);
d = 0.0001; %ureal('d',0.0001,'Percentage',100);
b = 0.0055;
a = 0.011;
Ix = a*b^3/12;
Iy = a^3*b/4;
phi = atan(1/3);
kp = x(1);
kI = x(2);
%kI = 4.32;
%kD = x(3);
kD = 0.0;
dx = 6;
dy = 2;


k = 1;
G = k*L/E*[cos(phi)*dx/Iy, cos(phi)*dx/Iy; sin(phi)*dy/Ix, -sin(phi)*dy/Ix];
[U, S, V] = svd(G);

%G_tf = tf({cos(phi), cos(phi); sin(phi), -sin(phi)},{[d Eu*Iy/L/dx], [1 Eu*Iy/L/dx]; [1 Eu*Ix/L/dy], [1 Eu*Ix/L/dy]})
G1 = tf(cos(phi), [d Eu*Iy/k/L/dx]);
G2 = tf(cos(phi), [d Eu*Iy/k/L/dx]);
G3 = tf(sin(phi), [d Eu*Ix/k/L/dy]);
G4 = tf(-sin(phi), [d Eu*Ix/k/L/dy]);
G_tf = [G1, G2; G3, G4];

%G_tf = G;

delta = ultidyn('delta',[2 2]);
Wu = makeweight(0.1,20,1.5);

G = G_tf * (1+blkdiag(Wu,Wu)*delta);

K_s = (kp+tf(1,[kI 0.0]));%+ tf([kD 0],[kD/10 1]));

K_tf = V*[K_s, 0; 0, K_s]/10*inv(S)*U';
K_tf = minreal(K_tf);
K_ss = ss(K_tf);
K = K_ss;

A = tf(K.A - K.B*inv(K.D)*K.C);
D = tf(K.D);
Int = tf([1],[1 0])*eye(length(A));
C = tf(K.C);
H = tf(K.B*inv(K.D));
B = K.B - H*K.D;

W = [1 0; 0 1];
Delta = ultidyn('Delta',[2 2],'Bound',0.5);
Delta = W*Delta;

R = K*inv(K_ss.D) - eye(2);

G.u = 'ua';  G.y = 'y';
%K.u = 'e';  K.y = 'u';
%R.u = 'usum'; R.y = 'v';
Delta.u = 'u'; Delta.y = 'ua';
H.u = 'ua'; H.y = 'hout';
A.u = 'v'; A.y = 'Aout';
D.u = 'e'; D.y = 'Dout';
B.u = 'e'; B.y = 'Bout';
Int.u = 'vdot'; Int.y = 'v';
C.u = 'v'; C.y = 'Cout';
S4 = sumblk('u = Cout + Dout',2);
S3 = sumblk('vdot = Aout + hout + Bout',length(A));
S1 = sumblk('e = r - y',2);
ClosedLoop = connect(G,H,A,D,B,Int,C,S3,S4,S1,Delta,'r','y',{'e','ua'});
[DMo,MMo] = diskmargin(ClosedLoop);
%opt = robOptions('Display','on');
%stabmarg = robstab(ClosedLoop,opt);

opt = robOptions('Display','on');
[perfmarg,wcu] = robgain(ClosedLoop,1,opt);
x
marg = -perfmarg.LowerBound
end
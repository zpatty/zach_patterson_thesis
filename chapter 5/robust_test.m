clear
close all
kp = 3.0;
kI = 0.8333;
%kI = 4.32;
kD = 0.1;
x0 = [kp, kI];
lb = [3.0 0.1];
up = [20 5.0];
nvars = 2;
rng default
%x = fmincon(@robust_optim, x0, [-1 0 0; 0 -1 0; 0 0 -1], [0 0 0])
options = optimoptions('ga', 'FunctionTolerance', 1e-3);
%[x,fval] = ga(@robust_optim,nvars,[-1 1],0,[],[],lb,up, @stability_constraint,options)
%%
L = 0.09355;
E_tube = 0.0981*(56 + 7.62336*35)/(0.137505*(254 - 2.54*35));
E = (0.19 + E_tube)*10^6/2;
Eu = (0.19 + E_tube)*10^6/2;%ureal('Eu',E,'Percentage',30);
d = 0.000; %ureal('d',0.0001,'Percentage',100);
h = 0.008;
b = 0.018;
Ix = h^3*b/12;
Iy = h*b^3/12;
% b = 0.0055;
% a = 0.011;
% Ix = a*b^3/12;
% Iy = a^3*b/4;
phi = atan(1/3);
kp1 = 10.0;
kI1 = 5.0;
kp2 = 10.0;
kI2 = 5.0;
%kI = 4.32;
kD = 0.1;
%kD = 0.0;
dx = 6;
dy = 4;
J = 1/3*(0.03)*L^2;
sma = 0.001;
d = 0.1;

L = 0.05;
E = 1.9e6;
% b = 0.0055;
% a = 0.011;
% Ix = a*b^3/12;
% Iy = a^3*b/4;
r = 0.008;
Ix = pi/4*r^4;
Iy=Ix;
% phi = atan(1/3);
phi = pi/4;
kp = 2.0;

kI = 0.83333;

%kI = 4.32;
kD = 0;
%kD = 0.0;
dx = 3.981;
dy = 3.981;
d = 0.001;
sma = 0.001;
J = 0.03*(L/2)^2;

kp = 1;
kI = 0.8333;
kD = 0.0;

k = 1;
G = k*L/E*[cos(phi)*dx/Iy, cos(phi)*dx/Iy; sin(phi)*dy/Ix, -sin(phi)*dy/Ix];
%G = tf({[sma cos(phi)], [sma cos(phi)]; [sma sin(phi)], [sma -sin(phi)]},{[Im d E*Iy/L/dx], [Im d E*Iy/L/dx]; [Im d E*Ix/L/dy], [Im d E*Ix/L/dy]})

[U, S, V] = svd(G);

%G_tf = tf({cos(phi), cos(phi); sin(phi), -sin(phi)},{[d Eu*Iy/L/dx], [1 Eu*Iy/L/dx]; [1 Eu*Ix/L/dy], [1 Eu*Ix/L/dy]})
G1 = tf([sma dx*cos(phi)], [J d Eu*Iy/k/L]);
G2 = tf([sma dx*cos(phi)], [J d Eu*Iy/k/L]);
G3 = tf([sma dy*sin(phi)], [J d Eu*Ix/k/L]);
G4 = tf([sma -dy*sin(phi)], [J d Eu*Ix/k/L]);
G_tf = [G1, G2; G3, G4];

%G_tf = G;

delta = ultidyn('delta',[2 2]);
Wu = makeweight(0.1,20,1.5);
w = tf([0.1 .1],[0.1/1.5 1]);

G = G_tf %* (1+blkdiag(w,w)*delta);

K_s = (kp+tf(kI,[1 0.0])+ tf([kD 0],[kD/10 1]));
%K_s = (kp+ tf([kD 0],[kD/10 1]));

K_tf = V*[K_s, 0; 0, K_s]*inv(S)*U';
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
[DMo,MMo] = diskmargin(ClosedLoop)
opt = robOptions('Display','on');
stabmarg = robstab(ClosedLoop,opt);
bodemag(ClosedLoop)
[M,Del,BlkStruct] = lftdata(ClosedLoop);
%[DMo,MMo] = diskmargin(M);

opt = robOptions('Display','on');
[perfmarg,wcu] = robgain(ClosedLoop,1,opt);

szDelta = size(Del);
M11 = M(1:szDelta(2),1:szDelta(1));

omega = logspace(-1,2,50);
M11_g = frd(M11,omega);

mubnds = mussv(M11,BlkStruct,'s');
[pkl,wPeakLow] = getPeakGain(mubnds(1,2));
[pku] = getPeakGain(mubnds(1,1))


LinMagopt = bodeoptions;
LinMagopt.PhaseVisible = 'off'; LinMagopt.XLim = [1e-1 1e2]; LinMagopt.MagUnits = 'abs';
bodeplot(mubnds(1,1),mubnds(1,2),LinMagopt);
xlabel('Frequency (rad/sec)');
ylabel('Mu upper/lower bounds');
title('Mu plot of robust stability margins (inverted scale)');

% Rtrack = TuningGoal.Tracking('r','y',10,0.01);
% [CL,fSoft] = systune(ClosedLoop,Rtrack);
%bodemag(M);

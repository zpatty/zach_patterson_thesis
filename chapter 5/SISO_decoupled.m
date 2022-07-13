clear
close all

L = 0.09355;
E = 0.19e6;
b = 0.0055;
a = 0.011;
Ix = a*b^3/12;
Iy = a^3*b/4;
phi = atan(1/3);
kp = 3.6;
kI = 0.83333;

G = L/2/E*[cos(phi)/Iy, cos(phi)/Iy; sin(phi)/Ix, -sin(phi)/Ix]
[U, S, V] = svd(G)

syms kps kis s
K = V*((kps*s + kis)/s)*inv(S)*U'

K_tf = V*tf({[kp kI], 0; 0, [kp kI]}, {[1 0],[1 0];[1 0],[1 0]})*inv(S)*U';

nums = {0.0039*[kp kI], 0.0039*[kp kI]; 9.7951e-04*[kp kI], -9.7951e-04*[kp kI]};

dens = {[1 0],[1 0];[1 0],[1 0]};
systf = tf(nums,dens)
syss = ss(systf)
Hanus = syss.B*inv(syss.D)

hanus_mat = syss.B*inv(syss.D)

new_tf = tf({G(1), G(2); G(3), G(4)},{1, 1; 1, 1});
[fact, M1, N1] = lncf(new_tf);


%-[K_tf; eye(2)]*tf(inv(eye(2) + new_tf*K_tf)*inv(M1))

%M = -[K_tf; eye(2)]*tf(inv(eye(2) + new_tf*K_tf)*inv(M1))

s = tf('s','TimeUnit','seconds');
G = tf(L/2/E*[cos(phi)/Iy, cos(phi)/Iy; sin(phi)/Ix, -sin(phi)/Ix])
G.InputName = {'qL','qV'};
G.OutputName = 'y';

D = tunableGain('Decoupler',eye(2));
D.InputName = 'e';
D.OutputName = {'pL','pV'};

PI_L = tunablePID('PI_L','pi');
PI_L.InputName = 'pL';
PI_L.OutputName = 'qL';
  
PI_V = tunablePID('PI_V','pi'); 
PI_V.InputName = 'pV';
PI_V.OutputName = 'qV'; 

sum1 = sumblk('e = r - y',2);

C0 = connect(PI_L,PI_V,D,sum1,{'r','y'},{'qL','qV'});

wc = [0.1,1];
[G,C,gam,Info] = looptune(G,C0,wc);
showTunable(C)

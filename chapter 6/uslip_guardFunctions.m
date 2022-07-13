%% U-SLIP Guard
function [constraintFcns,isterminal,direction] = uslip_guardFunctions(t,q,r_s,mode,a,b,c,d,x_t,r_0,te,delr,alpha)

x = q(1);
y = q(3);
l = sqrt((x-x_t)^2 + y^2);
a1 = y - sin(alpha);
a2 = l - 1 - delr;


constraintFcns = [a1; a2];

isterminal = [true; true];

direction = [-1; 1];

end
function xdot = uslip(t,x,r_s,mode,a,b,c,d,x_t,r_0,te,delr)

xdot(1) = x(2);
xdot(3) = x(4);
l = sqrt((x(1)-x_t)^2 + x(3)^2);
r = r_s*(t - te);
if mode == 2
    xdot(2) = -a*abs(x(2))*x(2) + d*(x(1) - x_t/r_0)*((1+r)/l - 1);
    xdot(4) = -b*abs(x(4))*x(4) -c + d*x(3)*((1+r)/l - 1);
else
    xdot(2) = -a*abs(x(2))*x(2);
    xdot(4) = -b*abs(x(4))*x(4) -c;
end
if t > 2.93
    dumm =1;
end
xdot = xdot';
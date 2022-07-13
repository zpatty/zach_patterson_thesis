
ang0 = 180*pi/180;
ang1 = -0.1*pi/180;


phi = atan(ang1/ang0) + 0.5*pi;
if ang0 < 0.0 
    phi = phi + pi;

end
disp(phi*180/pi)
theta = sqrt(ang1*ang1 + ang0*ang0);
l1 = -6.32*theta*cos(phi - atan(2.0/6.0))
l2 = -6.32*theta*cos(phi + pi + atan(2.0/6.0))
l3 = -6.32*theta*cos(phi + pi - atan(2.0/6.0))
l4 = -6.32*theta*cos(phi + atan(2.0/6.0))
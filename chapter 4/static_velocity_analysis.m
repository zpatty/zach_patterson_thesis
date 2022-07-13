theta = linspace(0,72);
d = 0.05*sqrt(2*(1-cosd(theta)));
v = d.*cosd(72-(180-theta)/2);
plot(theta,d)
xlabel("Angular Displacement of Limb")
ylabel("Robot Total Displacement")
figure
%plot(theta,v)
xlabel("Angular Displacement of Limb")
ylabel("Robot Forward Displacement")

plot(theta, v/2.6)
theta = 30;
v_calc = (0.05*sqrt(2*(1-cosd(theta))).*cosd(72-(180-theta)/2))/2.6

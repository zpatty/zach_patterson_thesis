clear
close all
u = 0.1;
g = 2;
l = 0.05;
d_list = linspace(0,1,10);
th_list = linspace(0, pi, 10);
syms theta(t) Y

hold on 
for i=1:length(d_list)
    syms theta(t) Y
    d = 1;
    eqn = (1-2/5*d)*(l^2*diff(theta(t),2) + l*g*cos(theta(t)))*(sin(theta(t)) - u*cos(theta(t))) == 2/5*u*g*l*d + g*cos(theta(t))*l;
    %eqn = (1-2/5*d)*(l^2*diff(theta(t),2) + l*g*theta(t)) == 2/5*u*g*l*d;

    func = matlabFunction(odeToVectorField(eqn), 'Vars',{t,Y});

    [t,y] = ode45(func, [0 0.1], [th_list(i); 0]);

    plot(t,y(:,1))
end

figure
hold on
for i=1:length(d_list)
    d = d_list(i);
    th = linspace(0.2,9/10*pi);

    tau = 2./5.*u.*d./(sin(th) - u*cos(th));

    plot(th,tau)
end
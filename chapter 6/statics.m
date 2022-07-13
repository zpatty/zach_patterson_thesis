clear
close all


F = linspace(0,10);
M = 0.1*F;
l2 = 5;
W = 0.04*9.81;
l1 = 5*l2;
theta = 72/2;

N1 = W*l2/(2*(l2+l1*cosd(theta)));
N2 = W/4;

mu11 = M/l1/N1;
mu21 = M/l1/N2;

plot(F,mu11,F,mu21,'Linewidth',2)
xlabel('Actuator force (N)')
ylabel('Needed Coefficient of Static Friction')
legend('Central', 'Distal')
set(gca,'FontSize',14)

theta=linspace(0,90);
l1 = [2*l2, 5*l2, 10*l2, 15*l2];
f = figure;
hold on
for i=1:length(l1)
    N1 = W.*l2./(2.*(l2+l1(i).*cosd(theta)));
    N2 = W/4.*ones(100,1)';

    mu11 = M/l1(i)./N1;
    mu21 = M/l1(i)./N2;
    plot(theta,mu21./mu11,'Linewidth',2)
end
legend('$\ell_1 = 2\ell_2$','$\ell_1 = 5\ell_2$','$\ell_1 = 10\ell_2$','$\ell_1 = 15\ell_2$','Interpreter','latex')
xlabel('\theta (\circ)')
ylabel('\mu_{tip}/\mu_{center}')
set(gca,'FontSize',14*1.236)
xlim([0 90])

%%
close all
M=linspace(0,10);
l1 = [l2, 2*l2, 5*l2, 10*l2, 15*l2];
f = figure;
hold on
for i=1:length(l1)
    N1 = M./(l1(i)+l2)+W/2;
    N2 = W/4.*ones(100,1)';

    mu11 = M/l1(i)./N1;
    mu21 = M/l1(i)./N2;
    plot(theta,mu21./mu11,'Linewidth',2)
end
legend('$\ell_1 = 2\ell_2$','$\ell_1 = 5\ell_2$','$\ell_1 = 10\ell_2$','$\ell_1 = 15\ell_2$','Interpreter','latex')
xlabel('\theta (\circ)')
ylabel('\mu_{tip}/\mu_{center}')
set(gca,'FontSize',14*1.236)
xlim([0 90])

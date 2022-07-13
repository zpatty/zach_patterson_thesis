clear
close all

newcolors = [0.83 0.14 0.14
             1.00 0.54 0.00
             0.47 0.25 0.80
             0.25 0.80 0.54];
         
filename = 'strain-output-23-09-2021_15:54:06.csv';
A = readmatrix(filename);
time = A(:,1) - A(1:1);
plot(time, A(:,2))
hold on

t = [0 17.1 27.4 36.1 44.2 53.9 61.4 72.7 84.1 99.1 110.4 125.4 136.5 152.9 165.3]; 

traj1 = [0 0; -40 0; -90 0; -120 0; -50 0; -25 0; 0 0; 0 -30; 30 -20; 60 -10; 0 0; 0 10; 0 20; 90 20; 120 20];
stairs(t, traj1(:,1),'LineWidth',2)
xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, A(:,3))
stairs(t, traj1(:,2),'LineWidth',2)
legend('Yaw Measured', 'Yaw Commanded', 'Pitch Measured', 'Pitch Commanded')
set(gcf, 'Position',  [100, 100, 1000, 800])
set(gca,'FontSize',18)

figure
filename = 'strain-output-23-09-2021_16:06:35.csv';
demo_2 = readmatrix(filename);
time = demo_2(:,1) - demo_2(1:1);
plot(time, demo_2(:,2))
hold on
t = [0 18 47.8 59 71.2 81.6 118.3 127.6 140.7 156.6 170.2 185 198.2];
traj2 = [0 0; -30 0; -40 0; -60 0; -90 0; 0 0; 0 -30; 0 -40; 0 -70; 30 -70; 80 -50; 100 -50; 0 -50];
stairs(t, traj2(:,1),'LineWidth',2)


plot(time, demo_2(:,3))
stairs(t, traj2(:,2),'LineWidth',2)
xlabel('Time (s)')
ylabel('Angle (\circ)')
legend('Yaw Measured', 'Yaw Commanded', 'Pitch Measured', 'Pitch Commanded')
set(gcf, 'Position',  [100, 100, 1000, 800])
set(gca,'FontSize',18)
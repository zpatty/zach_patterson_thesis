clear
close all

% newcolors = [0.83 0.14 0.14
%              1.00 0.54 0.00
%              0.47 0.25 0.80
%              0.25 0.80 0.54];

filenames = {'gravity 1','gravity 2', 'disturbance rejection'};

lw_1 = 2;
lw_2 = 2;
data = readmatrix(filenames{1});
time = data(:,1) - data(1:1);
%subplot(3,3,4)
plot(time, data(:,2),'LineWidth',lw_1)
hold on

stairs([0 13.3 33 time(end)], [0 -30 0 0],'--','LineWidth',lw_2)
xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, -data(:,3),'LineWidth',lw_1)
stairs([0 13.3 33 time(end)], [0 60 0 0],'--','LineWidth',lw_2)
set(gca,'FontSize',15)
ylim([-100 100])
legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')
set(gca,'YMinorTick','on')

%%
figure
lw_1 = 2;
lw_2 = 2;
data = readmatrix(filenames{2});
time = data(:,1) - data(1:1);
%subplot(3,3,4)
plot(time, data(:,2),'LineWidth',lw_1)
hold on

stairs([0 10.6 21.6 30.1 38.4 time(end)], [0 -30 0 30 0 0],'--','LineWidth',lw_2)
xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, -data(:,3),'LineWidth',lw_1)
stairs([0 10.6 21.6 30.1 38.4 time(end)], [0 60 0 -60 0 0],'--','LineWidth',lw_2)
set(gca,'FontSize',15)
ylim([-100 100])
legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')
set(gca,'YMinorTick','on')
%%
figure
lw_1 = 2;
lw_2 = 2;
data = readmatrix(filenames{3});
data = data(370:493,:);
time = data(:,1) - data(1:1);
%subplot(3,3,4)
plot(time, data(:,2),'LineWidth',lw_1)
hold on

stairs([0 time(end)], [-30 -30],'--','LineWidth',lw_2)
xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, -data(:,3),'LineWidth',lw_1)
stairs([0 time(end)], [60 60],'--','LineWidth',lw_2)
set(gca,'FontSize',15)
ylim([-100 100])
legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')
set(gca,'YMinorTick','on')

%%
figure
lw_1 = 2;
lw_2 = 2;
data = readmatrix(filenames{3});
data = data(647:end,:);
time = data(:,1) - data(1:1);
%subplot(3,3,4)
plot(time, data(:,2),'LineWidth',lw_1)
hold on

stairs([0 time(end)], [-60 -60],'--','LineWidth',lw_2)
xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, -data(:,3),'LineWidth',lw_1)
stairs([0 time(end)], [30 30],'--','LineWidth',lw_2)
set(gca,'FontSize',15)
ylim([-130 70])
legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')
set(gca,'YMinorTick','on')

set(gcf, 'Position',  [995, 909, 570*2, 420])
%%

yaw_error = mean(data(time > 6.4 & time < 16.78,2)+30)
pitch_error = mean(data(time > 6.4 & time < 16.78,3)+30)
%set(gcf, 'Position',  [100, 100, 500, 600])
%ylim([-110 110])


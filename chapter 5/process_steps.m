clear
close all

% newcolors = [0.83 0.14 0.14
%              1.00 0.54 0.00
%              0.47 0.25 0.80
%              0.25 0.80 0.54];
filenames = {'step_2_1-5','step_05_1-5'};


data = readmatrix(filenames{1});
time = data(:,1) - data(1:1);
%subplot(2,4,i)
plot(time, data(:,2),'LineWidth',2)
hold on

stairs([0 6.18 16.78 time(end)], [0 -30 0 0],'--','LineWidth',2)
xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, -data(:,3),'LineWidth',2)
stairs([0 6.18 16.78 time(end)], [0 30 0 0],'--','LineWidth',2)
set(gca,'FontSize',15)

legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')

yaw_error = mean(data(time > 6.4 & time < 16.78,2)+30)
pitch_error = mean(data(time > 6.4 & time < 16.78,3)+30)
%set(gcf, 'Position',  [100, 100, 500, 600])
%ylim([-110 110])
figure
data = readmatrix(filenames{2});
time = data(:,1) - data(1:1);
%subplot(2,4,i)
plot(time, data(:,2),'LineWidth',2)
hold on

stairs([0 6.28 18.2 time(end)], [0 -30 0 0],'--','LineWidth',2)
xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, -data(:,3),'LineWidth',2)
stairs([0 6.28 18.2 time(end)], [0 30 0 0],'--','LineWidth',2)
set(gca,'FontSize',15)

legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')

yaw_error = mean(data(time > 6.5 & time < 18.2,2)+30)
pitch_error = mean(data(time > 6.5 & time < 18.2,3)+30)
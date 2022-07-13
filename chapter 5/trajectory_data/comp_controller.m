clear
close all

% newcolors = [0.83 0.14 0.14
%              1.00 0.54 0.00
%              0.47 0.25 0.80
%              0.25 0.80 0.54];

filenames = {'strain-output-10-12-2021_10:56:53','../step_2_1-5'};

lw_1 = 2;
lw_2 = 2;
data = readmatrix(filenames{1});
data2 = readmatrix(filenames{2});


data = data(1:144,:);

data2 = data2(1:171,:);
time = data(:,1) - data(1:1);
time2 = data2(:,1) - data2(1:1) + 2.5;
yaw_error = mean(data(time > 8.6 & time < 27.8,2)-30)
pitch_error = mean(data(time > 8.6 & time < 27.8,3)-30)
%subplot(3,3,4)
plot(time, -data(:,2),'LineWidth',lw_1)
hold on
plot(time2, data2(:,2),':','LineWidth',lw_1)
stairs([0 8.6 time2(end)], [0 -30 -30],'--','LineWidth',lw_2)
xlabel('Time (s)')
%ylabel('Angle (\circ)')

plot(time, data(:,3),'LineWidth',lw_1)
plot(time2, -data2(:,3),':','LineWidth',lw_1)
stairs([0 8.6 time2(end)], [0 30 30],'--','LineWidth',lw_2)
set(gca,'FontSize',15)
ylim([-100 100])
%legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')
set(gca,'YMinorTick','on')



filenames = {'../step_2_1-5','../step_05_1-5'};

lw_1 = 1;
lw_2 = 2;

legend('Yaw [17]', 'Yaw MIMO*', 'Yaw Ref', 'Pitch [17]', 'Pitch MIMO*', 'Pitch Ref')
set(gca,'YMinorTick','on')

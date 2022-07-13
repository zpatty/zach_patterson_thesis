clear
close all

% newcolors = [0.83 0.14 0.14
%              1.00 0.54 0.00
%              0.47 0.25 0.80
%              0.25 0.80 0.54];

filenames = {'../step_2_1-5','../step_05_1-5'};

lw_1 = 1;
lw_2 = 2;
data = readmatrix(filenames{1});
time = data(:,1) - data(1:1);
subplot(3,3,4)
plot(time, data(:,2),'LineWidth',lw_1)
hold on

stairs([0 6.18 16.78 time(end)], [0 -30 0 0],'--','LineWidth',lw_2)
xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, -data(:,3),'LineWidth',lw_1)
stairs([0 6.18 16.78 time(end)], [0 30 0 0],'--','LineWidth',lw_2)
set(gca,'FontSize',15)
ylim([-100 100])
legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')
set(gca,'YMinorTick','on')

yaw_error = mean(data(time > 6.4 & time < 16.78,2)+30)
pitch_error = mean(data(time > 6.4 & time < 16.78,3)+30)
%set(gcf, 'Position',  [100, 100, 500, 600])
%ylim([-110 110])

data = readmatrix(filenames{2});
time = data(:,1) - data(1:1);
subplot(3,3,1)
plot(time, data(:,2),'LineWidth',lw_1)
hold on

stairs([0 6.28 18.2 time(end)], [0 -30 0 0],'--','LineWidth',lw_2)
% xlabel('Time (s)')
ylabel('Angle (\circ)')

plot(time, -data(:,3),'LineWidth',lw_1)
stairs([0 6.28 18.2 time(end)], [0 30 0 0],'--','LineWidth',lw_2)
set(gca,'FontSize',15)
ylim([-100 100])
set(gca,'YMinorTick','on')
%legend('Yaw Actual', 'Yaw Ref', 'Pitch Actual', 'Pitch Ref')

yaw_error = mean(data(time > 6.5 & time < 18.2,2)+30)
pitch_error = mean(data(time > 6.5 & time < 18.2,3)+30)


placement = [2 3 5 6 8 9];
filenames = {'trajectory-test-output-05_1-5_slow_08-10-2021_13:46:24','trajectory-test-output-05_1-5_fast_08-10-2021_13:50:23','trajectory-test-output-2_1-5_slow_08-10-2021_13:57:25','trajectory-test-output-2_1-5_fast_08-10-2021_13:56:05','trajectory-test-output-2_1-5_vfast_08-10-2021_14:00:12','trajectory-test-output-2_1-5_vvfast_08-10-2021_14:01:27'};
command_files = {'patrick_traj_4','patrick_traj-8-3','patrick_traj_4','patrick_traj-8-3', 'patrick_traj_30sec','patrick_traj_15sec'};
titles = {'K_P = 0.5', 'K_P = 0.5', 'K_P = 2.0', 'K_P = 2.0', 'K_P = 2.0', 'K_P = 2.0'};
for i=1:6
    data = readmatrix(filenames{i});
    time = data(:,1) - data(1:1);
    subplot(3,3,placement(i))
    plot(time, data(:,2),'LineWidth',lw_1)
    commands = readmatrix(command_files{i});
    hold on
    t_commanded = commands(:,1);
    traj1 = commands(:,2);
    traj2 = commands(:,3);
    stairs(t_commanded, traj1,'--','LineWidth',lw_2)
    if placement(i) == 8 
        xlabel('Time (s)')
        ylabel('Angle (\circ)')
    elseif placement(i) == 9
        xlabel('Time (s)')
    end
    if i < 6
        %title('SMA in tubing')
    else
        %title('SMA embedded')
    end

    plot(time, data(:,3),'LineWidth',lw_1)
    stairs(t_commanded, traj2,'--','LineWidth',lw_2)
    set(gca,'FontSize',15)
    set(gca,'YMinorTick','on')
    %title(titles(i))
    xlim([0 120])
    ylim([-100 100])
    error = zeros(length(time),2);
    for j=1:length(time)
        index = find(t_commanded < time(j));
        if isempty(index)
            command_yaw = 0;
            command_pitch = 0;
        else
            command_yaw = traj1(index(end));
            command_pitch = traj2(index(end));
        end
        error(j,1) = abs(data(j,2) - command_yaw);
        error(j,2) = abs(data(j,3) - command_pitch);
    end
    mean_error(i,:) = mean(error);
    
end
%legend('Yaw Meas', 'Yaw Ref', 'Pitch Meas', 'Pitch Ref')
set(gcf, 'Position',  [0, 0, 1920, 1200])
mean_error

%%
close all
commands = readmatrix(command_files{2});
t_commanded = commands(:,1);
traj1 = commands(:,2);
traj2 = commands(:,3);
times = [0.2 12 23 31 43];

for i=1:length(times)
    index = find(t_commanded == times(i));
    figure
    traj1(index)
    traj2(index)
    plot_curve([traj1(index)*pi/180,-traj2(index)*pi/180,0], 0.09355,times,i)
    
    
end
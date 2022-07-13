clear
close all

% newcolors = [0.83 0.14 0.14
%              1.00 0.54 0.00
%              0.47 0.25 0.80
%              0.25 0.80 0.54];
filenames = {'trajectory-test-output-29-09-2021_15:12:28', 'trajectory-test-output-29-09-2021_15:29:14','trajectory-test-output-3-29-09-2021_17:05:27','trajectory-test-output-4-29-09-2021_17:09:37', 'trajectory-test-output-5-30-09-2021_11:52:45','trajectory-test-output-embed-1-30-09-2021_12:24:55','trajectory-test-output-embed-2-30-09-2021_12:28:20','trajectory-test-output-embed-30-09-2021_12:24:55','trajectory-test-output-05-10-2021_15:39:04','trajectory-test-output-high-gain-05-10-2021_17:26:25','trajectory-test-output-higherint-05-10-2021_17:29:05','trajectory-test-output-higherboth-05-10-2021_17:41:07','trajectory-test-output-slow-15-10-06-10-2021_09:48:57','trajectory-test-output-fast-15-10-06-10-2021_09:46:07','trajectory-test-output-slow-newcomp-06-10-2021_12:13:08','trajectory-test-output-fast-newcomp-06-10-2021_12:15:21'};
command_files = {'patrick_traj_1', 'patrick_traj_2', 'patrick_traj_3', 'patrick_traj_4', 'patrick_traj_4', 'patrick_traj_4', 'patrick_traj_5','patrick_traj_4','patrick_traj-8-3','patrick_traj-8-3','patrick_traj-8-3','patrick_traj-8-3', 'patrick_traj_4','patrick_traj-8-3', 'patrick_traj_4','patrick_traj-8-3'};

for i=1:9
    data = readmatrix(filenames{i});
    time = data(:,1) - data(1:1);
    subplot(2,4,i)
    plot(time, data(:,2))
    commands = readmatrix(command_files{i});
    hold on
    t_commanded = commands(:,1);
    traj1 = commands(:,2);
    traj2 = commands(:,3);
    stairs(t_commanded, traj1,'LineWidth',2)
    xlabel('Time (s)')
    ylabel('Angle (\circ)')
    if i < 6
        %title('SMA in tubing')
    else
        %title('SMA embedded')
    end

    plot(time, data(:,3))
    stairs(t_commanded, traj2,'LineWidth',2)
    set(gca,'FontSize',15)
end
legend('Yaw Measured', 'Yaw Commanded', 'Pitch Measured', 'Pitch Commanded')
set(gcf, 'Position',  [100, 100, 500, 600])
ylim([-110 110])

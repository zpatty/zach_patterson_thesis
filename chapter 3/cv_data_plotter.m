% cv_data_plotter.m
% Copyright 2020 Soft Machines Lab.
% Parses the simple TwoDStateWithGoal data from brittlestar_ros and plots a
% single test.

% prep the workspace
clear all;
close all;
clc;
disp("Starting cv_data_plotter...");
distfig = figure;
hold on;
% Some constants for which test to parse.
% Assume the .csv files are in the following directory:
csv_dir = '.';
% the date-time string for the test we want to use , "2020-7-17_154327_stable_state2"
datetime = ["2020-2-28_141452","2020-7-17_151641_goal_seeking_1","2020-7-17_151641_goal_seeking_1"];
start_sample_array = [30, 225, 355];
end_sample_array = [205, 340, 545];
% so the full path to the file is
for j = 1:length(start_sample_array)
file_path = strcat(csv_dir, '/cv_datalogger_', ...
        datetime(j), '.csv');

% start at the following sample number for analyzing the data.
% This is a little hack to set the "time 0" point.
% ***NOTE that this is from the start of the test, not from the row of the
% CSV file.
start_sample = start_sample_array(j);
% Also end because there's some junk at the end.
end_sample = end_sample_array(j);

% Read in the data. The cv_datalogger data starts at the 3rd row,
% and has six columns.
start_row = start_sample + 2;
end_row = end_sample + 2;
% MATLAB INDEXES FROM 0 HERE!!!
% Read the whole thing
%data_cv = csvread(file_path, start_row, 0);
% or just the desired samples
data_cv = csvread(file_path, start_row, 0, [start_row 0 end_row 5]);
% The timestamps are the first column
timestamps = data_cv(:,1);
% The CoM is columns 2 and 3
com_cv = data_cv(:,2:3);
% rotations are column 4
theta_cv = data_cv(:,4);
% goal states are 5-6.
com_goal = data_cv(:,5:6);

% Data to plot is:
% || (goal) - (current)||_2

% So, first, the difference in both x and y:
dist_xy = com_cv - com_goal;
% preallocate the 2-norm
normed_dist = zeros(size(dist_xy,1), 1);
% ugly, we shouldn't need a loop here, but MATLAB's norm is being annoying
for i = 1:size(dist_xy,1)
    normed_dist(i,:) = norm(dist_xy(i,:));
end



% Sanitize the timestamps.
% Subtract away the start of the test:
timestamps = timestamps - timestamps(1);
% we'll plot in seconds.
timestamps = timestamps/1000;

% if j == 2
%     idx = find(timestamps==36.27);
%     timestamps = [timestamps(1:idx-1); timestamps(idx+1:end)];
%     normed_dist = [normed_dist(1:idx-1); normed_dist(idx+1:end)];
% end
timestamps_array{j} = timestamps;
normed_dist_array{j} = normed_dist;
% Make a nice figure.
fontsize = 14;

% Set up the window
set(gca, 'FontSize', fontsize);
set(gca,'TickLabelInterpreter','latex')
set(distfig,'Position',[1448,1280,945,550]);
%set(distfig,'PaperPosition',[1,1,5.8,3.5]);
% Plot the data itself
plot(timestamps_array{j}, normed_dist_array{j}, 'LineWidth', 2);
end
% Annotate the plot
%title('Closed-Loop Locomotion Results');
ylabel('Distance to Goal (cm)');
xlabel('Time (sec)');
legend('Stationary Goal', 'Floating Goal 1', 'Floating Goal 2')
ylim([0 55]);
% the x limit should just be the end of the data
xlim([0 ceil(timestamps(end))]);















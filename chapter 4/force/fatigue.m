clear 
close all
filename = "Specimen_RawData_2.csv";

M = readmatrix(filename);


time = M(:,1);
force = M(:,3);

[TF_min,P_min] = islocalmin(force);

count = 1;


thresh = 0.41*max(P_min);
valleys = P_min > thresh;

vllys = force(valleys);

% plot(time/10, force, time(valleys)/10, vllys, 'or')
% xlabel('Cycles', 'FontSize', 16);
% ylabel('Force (N)', 'FontSize', 16);
% set(gca,'FontSize',14)

figure
% plot(time(valleys)/10, -vllys, 'or')
% ylim([0.02 0.054])

hold on
alpha_plot = plot(time/10, -force, 'color', [.8 .8 .8]);
alpha_plot.Color(4)=1;
plot(time(valleys)/10, smooth(-vllys,0.07,'rloess'), 'LineWidth', 3)
xlabel('Cycles', 'FontSize', 16);
ylabel('Force (N)', 'FontSize', 16);
set(gca,'FontSize',14)
box on



clear all
%% txts
N = 4;
lens = zeros(N,1);
files = ["goal_seeking_1.txt", "planner_test.txt", "planner_test_3.txt", "stable_state_1.txt"];
for i = 1:N
data = table2array(read_planner_txt(files(i)));   
lens(i) = size(data,1);
primitive_results = zeros(lens(i)-1,4);
txt_data{i} = data;
for j = 1:lens(i)-1
    disp_vec = [data(j+1,1)-data(j,1), data(j+1,2)-data(j,2)];
    disp_mag = norm(disp_vec);
    rotation = abs(angdiff((data(j+1,3)*pi/180),(data(j,3)*pi/180)))*180/pi;
    disp_ang = wrapTo360(angdiff(atan2(disp_vec(2),disp_vec(1)),data(j,3))*180/pi);
    primitive = data(j,end);
    primitive_results(j,:) = [primitive,disp_mag,disp_ang,rotation];
end
primitives_data{i} = primitive_results;
end
primitives_array = vertcat(primitives_data{:});
%% csvs
csv_data = table2array(read_planner_csv("symmetric_1_goal_1.csv"));
csv_len = size(csv_data,1);
for j = 1:csv_len-1
    disp_vec = [csv_data(j+1,2)-csv_data(j,2), csv_data(j+1,3)-csv_data(j,3)];
    disp_mag = norm(disp_vec);
    disp_ang = wrapTo360(angdiff(atan2(disp_vec(2),disp_vec(1)),csv_data(j,4))*180/pi);
    rotation = abs(angdiff((csv_data(j+1,4)*pi/180),(csv_data(j,4)*pi/180)))*180/pi;
    primitive = csv_data(j,end);
    time = csv_data(j+1,1) - csv_data(j,1);
    csv_dists(j,:) = [primitive,disp_mag,disp_ang,rotation,time];
end
%%
primitives_array = cat(1,csv_dists(:,1:4),primitives_array);
avg_distance_per_primitive = mean(primitives_array(:,2))
avg_time_per_primitive = mean(csv_dists(:,4))
n_data = csv_len+sum(lens);
collated = zeros(n_data,6);
collated(1:csv_len,:) = csv_data(:,2:end);
collated(csv_len+1:end,:) = vertcat(txt_data{:});
%% separate data by primitives
primitives = unique(primitives_array(:,1));
for i = 1:size(primitives,1)
    primitives_separated{i} = primitives_array(abs(primitives_array(:,1)-primitives(i))<0.1, :);
end

%%
stats = [];

for i = 1:size(primitives,1)
    primitive_data = primitives_separated{i};
    rs = primitive_data(:,2);
    phis = primitive_data(:,3);
    thetas = primitive_data(:,4);
    stats = cat(1,stats,[i-1,median(rs), std(rs),...
        median(thetas), std(thetas)]);
    
end

labels = {'Primitive','median r (cm)',...
     'r StD(cm)',...
    'median theta (deg)', 'theta StD (deg)'}
stat_table = array2table(stats,'VariableNames',labels)

stat_struct = struct;
stat_struct.data = stat_table;
stat_struct.makeCompleteLatexDocument = 1;
stat_struct.dataFormat = {'%.3f'}
latex_output = latexTable(stat_struct)

%% boxplots
%close all
figure
set(gcf,'Position',[1448,1280,945,600]);
a0 = primitives_separated{1}(:,2);
a1 = primitives_separated{2}(:,2);
a2 = primitives_separated{3}(:,2);
a3 = primitives_separated{4}(:,2);
a4 = primitives_separated{5}(:,2);
boxplot_sizes = [ 0*ones(size(a0)); 1 * ones(size(a1)); 2 * ones(size(a2)); 3*ones(size(a3)); 4*ones(size(a4))];



boxplot([a0;a1;a2;a3;a4],boxplot_sizes)
set(gca, 'FontSize', 14);


set(findobj(gca,'type','line'),'linew',2)
set(gca,'TickLabelInterpreter','latex')
set(gca,'XTickLabel',{ '$a^0$','$a^1$','$a^2$','$a^3$','$a^4$'},'fontsize',14)
xlabel('Motion Primitive','interpreter','latex')
ylabel('Distance moved r (cm)')
ylim([0 6.99]);

xh = get(gca,'ylabel'); % handle to the label object
p = get(xh,'position'); % get the current position property
p(1) = 0.7*p(1) ;        % double the distance, 
                       % negative values put the label below the axis
set(xh,'position',p);   % set the new position


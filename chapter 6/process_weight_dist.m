%% Process data on weight distribution for brittle star robot

clear
close all
files = dir('*.mat');
files = natsortfiles(files);
load('times.mat')
load('labels.mat')
avg_velocity = [];
avg_velocity_2 = [];
weight_e = [];
com = [];
cob = [];
COT = [];
I = [];
density = [];
net_ww = [];
dist_strings = {};
names = {};

act_time = 0.25;
P_act = 8^2/1;
J_act = P_act*act_time;
J_cycle = J_act*4;


%% main loop
for i=1:length(files)-2
    
    load(files(i).name)
    tag_size = 2.54;
    pixels = 913-858;
    conversion = tag_size/pixels;
    data = squeeze(data*conversion);
    time = 0:1/20:(length(data)-1)/20;
    s_time = times(i,1);
    e_time = times(i,2);
%     s_time = time(1);
%     e_time = time(end);
    [~,s] = (min(abs(s_time - time)));
    [~,e] = (min(abs(e_time - time)));
    [~,s_2] = (min(abs(7 - time)));
    [~,e_2] = (min(abs(29 - time)));
    %plot(time(s:e),data(s:e,1),time(s:e),data(s:e,2))
    position_norm = vecnorm(data,2,2);
    distance = norm(data(e,:)-data(s,:));
%     figure
%     plot(time,position_norm)
%     title(files(i).name)
    %velocity = diff(position_norm);
%     figure 
%     plot(time(s:e),velocity(s:e))
    avg_velocity(end+1) = distance/(time(e)-time(s));
   
    cycles = round((e_time-s_time)/5);
    energy = J_cycle*cycles;

    %avg_velocity_2(end+1) = (position_norm(e_2) - position_norm(s_2))/(time(e_2)-time(s_2));
    m_l = 0.0342;
    m_b = 0.0475;
    m_bat = 0.101;
    limb_W = m_l*9.81;
    limb_ww = 0.02;
    limb_V = (75-68)/1000*.116*.19/5;
    limb_B = limb_V*9.81;
    limb_net = limb_W - limb_B;
    
    body_W = m_b*9.81;
    body_V = 1.5/1000*.116*.19;
    body_B = body_V*9.81;
    body_net = body_W - body_B;
    
    robot_ww = 0.18;
    
    m_ring = 0.00284;
    ring_W = m_ring*9.81;
    
    ring_ww = 0.09/5;
    
    m_circle = 0.016;
    circle_W = 0.016*9.81;
    
    circle_ww = 0.1;
    
    added = [ones(3,1)*ring_W; circle_W/5];
    added_ww = [ones(3,1)*ring_ww; circle_ww/5];
    foam_B = 4*ring_W;
    foam_ww = -0.08;
    foam_V = foam_B/9.81/1000;
    
    mass = m_l*5+m_b + m_bat + dot(labels(i,1:4),[ones(3,1)*m_ring*5; m_circle]);
    mass_mat(i) = mass;
    volume = 5*limb_V + body_V + labels(i,5)*foam_V + dot(labels(i,1:4),[ones(3,1)*m_ring*5; m_circle])/6700;
    net_ww(end+1) = robot_ww + dot(labels(i,1:4),[ones(3,1)*ring_ww*5; circle_ww]) + foam_ww*labels(i,5);
    density(end+1) = mass/(mass/1000 - net_ww(i)/1000/9.81);%(mass-m_bat)/(volume);
    weight_e(end+1) = body_net/5 + limb_net + dot(labels(i,1:4),added) - labels(i,5)*foam_B/5;
    %cob(end+1) = 1/weight_e(i)*(dot(labels(i,1:4)'.*added + [ones(3,1)*limb_net/3;body_net/5 - labels(i,5)*foam_B/5],[12.3 6.6 3 0]));
    cob(end+1) = 1/net_ww(i)*(dot(labels(i,1:4)'.*added_ww + [ones(3,1)*limb_ww/3;body_net/5 - labels(i,5)*foam_ww/5],[12.3 6.6 3 0]));
    com(end+1) = 1/mass/5*(dot(labels(i,1:4)'.*[ones(3,1)*m_ring;m_circle/5] + [ones(3,1)*m_l/3;m_b/5+m_bat/5],[12.3 6.6 3 0]));
    COT(end+1) = energy/(mass*9.81*distance/100);
    names{i} = files(i).name;
    I(end+1) = dot(labels(i,1:4)+[1 1 1 1],[3 2 1 0].^2);
    distribution = find(labels(i,1:4)>0)+1;
    if isempty(distribution)
        distribution = 1;
    end
    switch distribution
        case 1
            dist_strings{i} = 'None';
        case 2
            dist_strings{i} = 'Distal';
        case 3
            dist_strings{i} = 'Medial';
        case 4
            dist_strings{i} = 'Proximal';
        case 5
            dist_strings{i} = 'Central';
    end
    %s(i) = scatter(weight_e(i),avg_velocity(i),100,C(distribution),'filled');
    %hold on

end

%% compile results in table
weight_e = weight_e';
avg_velocity = avg_velocity';
dist_strings = dist_strings';
com = com';
names = names';
density = density';
cob = cob';
COT = COT';
mesh = labels(:,6);

results = table(names,weight_e, com, cob, density, avg_velocity, COT, dist_strings,labels(:,1:5),mesh);

[~,maxidx] = maxk(results.avg_velocity,20);
results(maxidx,:)

[~,minidx] = mink(results.avg_velocity,5);
results(minidx,:)

%% Regressions

X = [rescale(weight_e),rescale(cob)];

lm2 = fitlm(X(end-9:end,:),avg_velocity(end-9:end))
lm1 = fitlm(X(1:end-10,:),avg_velocity(1:end-10))%,'RobustOpts','on')
R0 = corrcoef(X(1:end-10,:)) % correlation matrix
V=diag(inv(R0))'

%% Plotting 
C = linspecer(5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%         Center of mass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
C_reordered = [C(5,:);C(3,:);C(1,:);C(4,:)];
h = gscatter(com(end-9:end),avg_velocity(end-9:end), dist_strings(end-9:end),C_reordered,'o',6);
for i=1:length(h)
    h(i).LineWidth = 2.5;
end

hold on
h2 = gscatter(com(1:end-10),avg_velocity(1:end-10), dist_strings(1:end-10),C,[],20);
plot(lm1)
xlabel('Radial Center of Mass (cm)')
ylabel('Average Velocity (cm/s)')
[hleg,att] = legend('show');
title(hleg,['Added Mass'])
%set(gcf, 'Position',  [0, 0, 1920/2, 1200])
set(gcf,'Position', [1448 1280 945 550])
set(gca,'FontSize',14)
legend([h2; h(1)])
hleg.String{6} = ['Denotes trial ' newline 'on mesh'];
hleg.FontSize = 10;

% figure
% gscatter(com(1:end-10),COT(1:end-10), dist_strings(1:end-10),C,[],40)
% xlabel('"Radial Center of Mass" (cm)')
% ylabel('COT')
% [hleg,att] = legend('show');
% title(hleg,'Added Mass Location')
% set(gcf, 'Position',  [0, 0, 1920, 1200])
% set(gca,'FontSize',15)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%         Center of buoyancy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
C_reordered = [C(5,:);C(3,:);C(1,:);C(4,:)];
h = gscatter(cob(end-9:end),avg_velocity(end-9:end), dist_strings(end-9:end),C_reordered,'o',6);
for i=1:length(h)
    h(i).LineWidth = 2.5;
end

hold on
h2 = gscatter(cob(1:end-10),avg_velocity(1:end-10), dist_strings(1:end-10),C,[],20);
xlabel('Radial Center of Buoyancy (cm)')
ylabel('Average Velocity (cm/s)')
[hleg,att] = legend('show');
title(hleg,'Added Mass')
%set(gcf, 'Position',  [0, 0, 1920, 1200])
set(gcf,'Position', [1448 1280 945 550])
set(gca,'FontSize',14)
legend([h2; h(1)])
hleg.String{6} = ['Denotes trial ' newline 'on mesh'];
hleg.FontSize = 10;

% figure
% gscatter(CONF(1:end-10),COT(1:end-10), dist_strings(1:end-10),C,[],40)
% xlabel('"Radial Center of Buoyancy" (cm)')
% ylabel('COT')
% [hleg,att] = legend('show');
% title(hleg,'Added Mass Location')
% set(gcf, 'Position',  [0, 0, 1920, 1200])
% set(gca,'FontSize',15)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% r
%            Net Weight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% gscatter(weight_e(1:end-10),COT(1:end-10), dist_strings(1:end-10),C,[],40)
% xlabel('Net Weight')
% ylabel('COT')
% [hleg,att] = legend('show');
% title(hleg,'Added Mass Location')
% set(gcf, 'Position',  [0, 0, 1920, 1200])
% set(gca,'FontSize',15)

figure 
h = gscatter(net_ww(end-9:end),avg_velocity(end-9:end), dist_strings(end-9:end),C_reordered,'o',6);
for i=1:length(h)
    h(i).LineWidth = 2.5;
end

hold on
h2 = gscatter(net_ww(1:end-10),avg_velocity(1:end-10), dist_strings(1:end-10),C,[],20);
xlabel('Net Weight (N)')
ylabel('Average Velocity (cm/s)')
[hleg,att] = legend('show');
title(hleg,'Added Mass')
%set(gcf, 'Position',  [0, 0, 1920/2, 1200])
set(gcf,'Position', [1448 1280 945 550])
set(gca,'FontSize',14)
legend([h2; h(1)])
hleg.String{6} = ['Denotes trial ' newline 'on mesh'];
hleg.FontSize = 10;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%           Total Density
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
C_reordered = [C(5,:);C(3,:);C(1,:);C(4,:)];
h = gscatter(density(end-9:end),avg_velocity(end-9:end), dist_strings(end-9:end),C_reordered,'o',6);
for i=1:length(h)
    h(i).LineWidth = 2.5;
end

hold on
h2 = gscatter(density(1:end-10),avg_velocity(1:end-10), dist_strings(1:end-10),C,[],20);
xlabel('Total Density (g/cm^3)')
ylabel('Average Velocity (cm/s)')
[hleg,att] = legend('show');
title(hleg,'Added Mass')
%set(gcf, 'Position',  [0, 0, 1920, 1200])
set(gcf,'Position', [1448 1280 945 550])
set(gca,'FontSize',14)
legend([h2; h(1)])
hleg.String{6} = ['Denotes trial ' newline 'on mesh'];
hleg.FontSize = 10;

% figure
% gscatter3(com(1:end-10),weight_e(1:end-10),avg_velocity(1:end-10),dist_strings(1:end-10),C,[],40)
% [hleg,att] = legend('show');
% title(hleg,'Added Mass Location')



%legend(s([1, 2, 3, 14]),{'Distal','Middle', 'Proximal', 'Central', 'Even'}) 
%legend('1','2','3','4')
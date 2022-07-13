clear
close all
% files = dir('*.mat');
% filename = files(1).name;
% raw = load(filename);
% data = squeeze(raw.centroids)*1.2/(131.2);
% 
% data = data - data(1,:);
% position = vecnorm(data,2,2);
% 
% l = 5;
% theta = atand(position./l);
% 
% rate = 60;
% t = 0:1/rate:(length(data)-1)*1/rate;
% 
% plot(t,theta,'Linewidth',2)
% xlabel('Time (s)')
% ylabel('Angular Displacement (\circ)')
labels = [2000 300; 2000 500; 2000 300; 2000 300; 2000 500; 2000 500];
means = [];
amps = {};
stds = [];
frequency = [];
activation = [];
dist_strings = {};
means_300 = [];
means_200 = [];
stds_200 = [];
%load('labels.mat')
filelist = dir('*.csv');
for i = 1:length(filelist)
    filename = filelist(i).name;
    %filename = 'deformation-test-output_21-05-2021_16:45:45.csv';
    M = readmatrix(filename);
    X1 = M(:,1)*100;
    X2 = M(:,3)*100;
    Y1 = M(:,2)*100;
    Y2 = M(:,4)*100;
    rounded = 2;
    fixed_inds = find(abs(mode(round(X1,rounded)) - round(X1,rounded)) < 3 & abs(mode(round(Y1,rounded)) - round(Y1,rounded)) < 3); 
    Xbuffer = X1(fixed_inds);
    Ybuffer = Y1(fixed_inds);
    X1(fixed_inds) = X2(fixed_inds);
    Y1(fixed_inds) = Y2(fixed_inds);
    X2(fixed_inds) = Xbuffer;
    Y2(fixed_inds) = Ybuffer;
    
    t = M(:,5);
    t = t - t(1);

    theta = atand((Y1 - Y2)./(X1 - X2));
    singularities = find((X1 - X2)<0);
    theta(singularities) = 180 + theta(singularities);
    if i ==15
        for k=1:length(Y1)
            ydiff = (Y1(k) - Y2(k));
        end
    end
    [TF_min,P_min] = islocalmin(theta);
    [TF_max,P_max] = islocalmax(theta);
    
    count = 1;
    
    
    thresh = 0.15*max(P_min);
    valleys = P_min > thresh;
    peaks = P_max > thresh;
    
    vllys = theta(valleys);
    pks = theta(peaks);
    t_v = t(valleys);
    t_p = t(peaks);
    if length(vllys) > length(pks)
        vllys = vllys(1:end-1);
        t_v = t_v(1:end-1);
    elseif length(vllys) < length(pks)
        pks = pks(1:end-1);
        t_p = t_p(1:end-1);
    end
    
%     figure
%     plot(t,theta,t_v, vllys,'r*', t_p, pks, 'or')
     figure
     plot(X1,Y1,X2,Y2)
    amp = abs(pks - vllys);
    amps{end+1} = amp;
    means(end+1) = mean(amp);
    stds(end+1) = std(amp);
    frequency(end+1) = 1000/(labels(i,1)+labels(i,2));
    activation(end+1) = labels(i,2);
    
%     if labels(i,3) == 1
%         dist_strings{i} = 'Antagonistic Actuation';
%     else
%         dist_strings{i} = 'Single-sided Actuation';
%     end
    
    IS_EVEN = ~mod(i,2);
    hold on
    if labels(i,2) == 500
        means_200 = [means_200; amp];
        %stds_200(end+1) = std(theta);
        %plot(X1,Y1,'.-b')
        %scatter(X2,Y2,'b')
        %figure
        
    else
        means_300 = [means_300; amp];
        %stds_100(end+1) = std(theta);
        
        %plot(X1,Y1,'r')
        %scatter(X2,Y2,'r')
        
    end
    
end
frequency = frequency';
means = means';
dist_strings = dist_strings';
gscatter(frequency,means,dist_strings)
figure
gscatter(activation,means,dist_strings)
figure
errorbar([1 2 3],means(labels(:,2) == 300), stds(labels(:,2) == 300),'o', 'MarkerEdgeColor','red','MarkerFaceColor','red', 'Color', 'red')
hold on
errorbar([1 2 3],means(labels(:,2) == 500), stds(labels(:,2) == 500),'o', 'MarkerEdgeColor','blue','MarkerFaceColor','blue', 'Color', 'blue')
%set(gcf, 'Position',  [100, 100, 500, 400])
set(gca,'FontSize',14)
%xlim([1 349])
xlabel('Sample No', 'FontSize', 16);
ylabel('Angular Displacement', 'FontSize', 16);
legend('100 ms', '200 ms');

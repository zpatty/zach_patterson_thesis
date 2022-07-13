clear
close all
files = dir('*.mat');
files = natsortfiles(files);
temperatures = num2cell([6 6 6 12 12 12 18 18 18 22 22 22 30 30 30]);
activations = num2cell(repmat([200; 400; 600],5,1));
[files.activation] = activations{:};
[files.temperature] = temperatures{:};

l = 5;
means_200 = [];
means_400 = [];
means_600 = [];
std_200 = [];
std_400 = [];
std_600 = [];
amplitude = {};
for i=1:length(files)
    filename = files(i).name;
    raw = load(filename);
    data = squeeze(raw.data)*1.2/(350);
    t = 0:1/20:(length(data)-1)*1/20;
    data = data - data(1,:);
    position = vecnorm(data,2,2);
    
    theta = atand(position./l)*2;
    
    %plot(t, theta)
    
    [TF_min,P_min] = islocalmin(theta);
    [TF_max,P_max] = islocalmax(theta);

    thresh = 0.15*max(P_min);
    valleys = P_min > thresh;
    peaks = P_max > thresh;
    
    t_v = t(find(peaks) - 20);
    vllys = theta(find(peaks) - 20);
    %vllys = dist(valleys);
    pks = theta(peaks);
    %figure
    %plot(t,theta,t_v, vllys,'r*',t(peaks), theta(peaks), 'or')
    amplitude(i) = {pks - vllys};
    
    
    if files(i).activation == 200
        means_200(end+1) = mean(amplitude{i});
        std_200(end+1) = std(amplitude{i});
        color = 'red';
    elseif files(i).activation == 400
        means_400(end+1) = mean(amplitude{i});
        std_400(end+1) = std(amplitude{i});
        color = 'blue';
    elseif files(i).activation == 600
        means_600(end+1) = mean(amplitude{i});
        std_600(end+1) = std(amplitude{i});
        color = 'green';
    end
    
    hold on
    errorbar(files(i).temperature,mean(pks - vllys), std(pks - vllys),'o', 'MarkerEdgeColor',color,'MarkerFaceColor',color, 'Color', color)
    xlabel('Temperature (C)')
    ylabel('Tip Angle (\circ)')
    set(gca,'FontSize',15)
end

[hleg,att] = legend('show');
title(hleg,'Activation Time')
legend('200ms', '400ms', '600ms')

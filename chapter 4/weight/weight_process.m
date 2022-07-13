clear
close all
files = dir('*.mat');
files = natsortfiles(files);
temperatures = num2cell([22 22 22 22]);
activations = num2cell([600;600;600;600]);
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
for i=1:2
    filename = files(i).name;
    raw = load(filename);
    data = squeeze(raw.data)*1.2/(350);
    if i ==1
        rate = 20;
        last = rate*6;
        t = 0:1/rate:(length(data)-1)*1/rate;
        start = 1;
        shift = 0;
    else
        rate = 60;
        last = rate*10;
        t = 0:1/rate:(length(data)-1)*1/rate;
        start = find(abs(t - (5.0667 - 1)) < 0.02);
        shift = (5.0667 - 1);
    end
    
    data = data - data(1,:);
    position = vecnorm(data,2,2);
    
    theta = atand(position./l)*2;
    
    plot(t(start:last) - shift, theta(start:last),'Linewidth',2)
    
    [TF_min,P_min] = islocalmin(theta);
    [TF_max,P_max] = islocalmax(theta);

    thresh = 0.15*max(P_min);
    valleys = P_min > thresh;
    peaks = P_max > thresh;
    
    t_v = t(find(peaks) - 20);
    vllys = theta(find(peaks) - 20);
    %vllys = dist(valleys);
    pks = theta(peaks);
    hold on
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
    
    %hold on
    %errorbar(files(i).temperature,mean(pks - vllys), std(pks - vllys),'o', 'MarkerEdgeColor',color,'MarkerFaceColor',color, 'Color', color)
    xlabel('Time (s)')
    ylabel('Tip Angle (\circ)')
    set(gca,'FontSize',15)
end

%[hleg,att] = legend('show');
%title(hleg,'Activation Time')
legend('No Load','5g Load')

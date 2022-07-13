clear
close all

data1 = readmatrix('sample4_rock.csv');
data2 = readmatrix('sample4_vero.csv');

XY1 = vecnorm(data1(:,1:2),2,2);
XY2 = vecnorm(data2(:,1:2),2,2);
% 
% plot(XY1)
% figure
% plot(XY2)

net_forces_rock = {};
net_forces_alt_rock = {};
files = dir('*rock.csv');
for i=1:3
    
    data = readmatrix(files(i).name);
    F_T = vecnorm(data(:,1:2),2,2);
    F_N = data(:,3);
    
    t = 0:1/100:1/100*(length(F_T)-1);
    figure
    plot(t,F_T,t,F_N,'Linewidth',1)
    xlabel('Time (s)')
    ylabel('Force (N)')
    set(gca,'FontSize',14)
    legend('Tangential Force', 'Normal Force')

    
    [TF_min,P_min] = islocalmin(F_T);
    [TF_max,P_max] = islocalmax(F_T);
    
    count = 1;
    
    
    thresh = 0.6*max(P_min);
    %valleys = P_min > thresh;
    peaks = P_max > thresh;
    
    %vllys = F_T(valleys);
    pks = F_T(peaks);
    t_p = t(peaks);
    num_cycles = round((t(end)-t_p(1))/5.58);
    pks = [pks(1); zeros(num_cycles,1)];
    %t_v = t(valleys);
    
    t_p = [t_p(1); zeros(num_cycles,1)];
    window = 0.4;
    for j= 2:round((t(end)-t_p(1))/5.58)+1
        
        [pks(j),ind] = max(F_T(abs(t - (t_p(1)+5.58*(j-1))) < window));
        tmax = t(abs(t - (t_p(1)+5.58*(j-1))) < window);
        t_p(j) = tmax(ind);
    end
    
    peak_inds = find(peaks);
%     figure
%     plot(t,F_T,t_p,pks, 'or')
    
%     bad = find(diff(t_p) < 2.7);
%     for j=1:length(bad)
%         [val, biggest] = max(pks(bad(j):bad(j)+1));
%         if biggest == bad(j)
%             pks = pks([1:bad(j)-1,bad(j)+1:end]);
%             t_p = t_p([1:bad(j)-1,bad(j)+1:end]);
%             peak_inds = peak_inds([1:bad(j)-1,bad(j)+1:end]);
%         else
%             pks = pks([1:bad(j),bad(j)+2:end]);
%             t_p = t_p([1:bad(j),bad(j)+2:end]);
%             peak_inds = peak_inds([1:bad(j),bad(j)+2:end]);
%         end
%     end
    
    vllys = zeros(length(pks),1);
    vllys(1) = mean(F_T(1:peak_inds(1)));
    window = [150 75];
    figure
    for j = 2:length(pks)
        vllys(j) = mean(F_T(peak_inds(j)-window(1):peak_inds(j)-window(2)));
        
        plot(t(peak_inds(j)-window(1):peak_inds(j)-window(2)),F_T(peak_inds(j)-window(1):peak_inds(j)-window(2)),'-r', 'Linewidth', 3)
        hold on
        
        if i==3 && j==3
            vllys(j) = vllys(j-1);
        end
        
        if i==1 && j==3
            vllys(j) = F_T(round(t,2)==6.94);
        end
        
    end
    
    net_forces_rock(i) = {pks - vllys};
    net_forces_alt_rock(i) = {pks - mean(F_T(1:10))};
    
%     if length(vllys) > length(pks)
%         vllys = vllys(1:end-1);
%         t_v = t_v(1:end-1);
%     elseif length(vllys) < length(pks)
%         pks = pks(1:end-1);
%         t_p = t_p(1:end-1);
%     end
    
    
    plot(t,F_T, '.b',t_p, pks, 'or')
    
end

%%
close all
net_forces_vero = {};
net_forces_alt_vero = {};
files = dir('*vero.csv');
for i=1:3
    
    data = readmatrix(files(i).name);
    F_T = vecnorm(data(:,1:2),2,2);
    F_N = data(:,3);
    
    t = 0:1/100:1/100*(length(F_T)-1);
    %plot(t, data(:,2))
    [TF_min,P_min] = islocalmin(F_T);
    [TF_max,P_max] = islocalmax(F_T);
    
    count = 1;
    
    
    thresh = 0.4*max(P_max(1:1000));
    %valleys = P_min > thresh;
    peaks = P_max > thresh;
    
    %vllys = F_T(valleys);
    pks = F_T(peaks);
    t_p = t(peaks);
    
    window = 0.4;
    num_cycles = floor((t(end)-t_p(1))/5.58);
    pks = [pks(1); zeros(num_cycles,1)];
    %t_v = t(valleys);
    
    t_p = [t_p(1); zeros(num_cycles,1)];
    
    for j= 1:floor((t(end)-t_p(1))/5.58)+1
        
        [pks(j),ind] = max(F_T(abs(t - (t_p(1)+5.58*(j-1))) < window));
        tmax = t(abs(t - (t_p(1)+5.58*(j-1))) < window);
        t_p(j) = tmax(ind);
    end
    
    peak_inds = find(peaks);
    
    vllys = zeros(length(pks),1);
    vllys(1) = mean(F_T(1:peak_inds(1)));
    window = [150 75];
    figure
    for j = 2:length(pks)
        vllys(j) = mean(F_T(peak_inds(j)-window(1):peak_inds(j)-window(2)));
        
        plot(t(peak_inds(j)-window(1):peak_inds(j)-window(2)),F_T(peak_inds(j)-window(1):peak_inds(j)-window(2)),'-r', 'Linewidth', 3)
        hold on
        
        if i==3 && j==3
            vllys(j) = vllys(j-1);
        end
        
        if i==1 && j==3
            vllys(j) = F_T(round(t,2)==6.94);
        end
        
    end
    
    net_forces_vero(i) = {pks - vllys};
    net_forces_alt_vero(i) = {pks - mean(F_T(1:10))};
    
    plot(t,F_T, '.b',t_p, pks, 'or')
    
end

means_rock = [];
std_rock = [];
means_vero = [];
std_vero = [];
for i=1:3
    means_rock(end+1) = mean(net_forces_alt_rock{i});
    std_rock(end+1) = std(net_forces_alt_rock{i});
    means_vero(end+1) = mean(net_forces_alt_vero{i});
    std_vero(end+1) = std(net_forces_alt_vero{i});
end
close all
figure
errorbar([1 2 3],means_rock, std_rock,'o', 'MarkerEdgeColor','red','MarkerFaceColor','red', 'Color', 'red')
hold on
errorbar([1 2 3],means_vero, std_vero,'o', 'MarkerEdgeColor','blue','MarkerFaceColor','blue', 'Color', 'blue')
xlim([0 4])
xticks(1:1:3)
xlabel('Sample No')
ylabel('Tangential Force (N)')

legend('Rock-like surface', 'Verowhite plastic')
set(gca,'FontSize',15)
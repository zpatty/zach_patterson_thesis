clear all
close all
means_100 = [];
stds_100 = [];
means_200 = [];
stds_200 = [];
filelist = dir('*.csv');
for i = 1:length(filelist)
    filename = filelist(i).name;
    %filename = 'deformation-test-output_21-05-2021_16:45:45.csv';
    M = readmatrix(filename);
    X1 = M(:,1);
    X2 = M(:,3);
    Y1 = M(:,2);
    Y2 = M(:,4);
    fixed_inds = find(abs(mode(round(X1,2)) - round(X1,2)) < 5 & abs(mode(round(Y1,2)) - round(Y1,2)) < 5); 
    Xbuffer = X1(fixed_inds);
    Ybuffer = Y1(fixed_inds);
    X1(fixed_inds) = X2(fixed_inds);
    Y1(fixed_inds) = Y2(fixed_inds);
    X2(fixed_inds) = Xbuffer;
    Y2(fixed_inds) = Ybuffer;
    
    t = M(:,5);
    t = t - t(1);
    theta = atand((Y1 - Y2)./(X1 - X2))*2;
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
    

    %figure
%     plot(t,theta,t_v, vllys,'r*', t_p, pks, 'or')
    %plot(X1,Y1,'.-b')
    hold on
    scatter(X2,Y2,'b')

    IS_EVEN = ~mod(i,2);
    hold on
    if IS_EVEN
        means_200(end+1) = mean(amp);
        stds_200(end+1) = std(amp);
        %plot(X1,Y1,'.-b')
        %scatter(X2,Y2,'b')
        %figure
        
    else
        means_100(end+1) = mean(amp);
        stds_100(end+1) = std(amp);
        
        %plot(X1,Y1,'r')
        %scatter(X2,Y2,'r')
        
    end
    
end
figure
errorbar([1 2 3 4],means_100, stds_100,'o', 'MarkerEdgeColor','red','MarkerFaceColor','red', 'Color', 'red')
hold on
errorbar([1 2 3 4],means_200, stds_200,'o', 'MarkerEdgeColor','blue','MarkerFaceColor','blue', 'Color', 'blue')
%set(gcf, 'Position',  [100, 100, 500, 400])
ylim([0 180])
%xlim([1 349])
xlabel('Sample No');
ylabel('Tip Angle (\circ)');
legend('100 ms', '200 ms');
set(gca,'FontSize',15)

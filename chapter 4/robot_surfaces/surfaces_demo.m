clear
close all

rock = load('rock.mat');
plastic = load('plastic.mat');

rdata = squeeze(rock.data)*1.2/(60.5);
pdata = squeeze(plastic.data)*1.2/(61.8);

tr = 0:1/60:(length(rdata)-1)*1/60;
tp = 0:1/60:(length(pdata)-1)*1/60;

rdata = rdata - rdata(1,:);
pdata = pdata - pdata(1,:);

plot(tr, vecnorm(rdata,2,2),'Linewidth',2)
hold on
plot(tp, vecnorm(pdata,2,2),'Linewidth',2)

xlabel('Time (s)')
ylabel('Distance (cm)')
set(gca,'FontSize',14)
legend('Rock-like surface','Plastic surface')
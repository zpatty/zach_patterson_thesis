clear
close all
filename = 'test-output_14-04-2021_12:31:56.csv';
T = readtable(filename);
time = T.Var6;
time = time - time(1);
xloc = T.Var1;
yloc = T.Var2;
xgoal = T.Var4;
ygoal = T.Var5;
dist = sqrt((xloc - xgoal).^2 + (yloc - ygoal).^2)*0.14;
dist = sqrt((xloc - xgoal).^2 + (yloc - ygoal).^2)*0.14;
figure('position', [100,100,148.695/76.202*600,600])
plot(time(13:126), dist(13:126)-6, 'b', 'LineWidth', 2)
hold on
plot(time(127:264), dist(127:264)-6, 'r', 'LineWidth', 2)


%set(distfig,'Position',[100,100,1920/1080*350,350]);
%set(distfig,'PaperPosition',[1,1,5.8,3.5]);
ylabel('Distance to Goal (cm)');
xlabel('Time (sec)');
set(gca, 'FontSize', 15);
legend('Moving to Goal #1', 'Moving to Goal #2')


figure
plot(time(13:127), dist(13:127)-6, 'b', 'LineWidth', 2)
set(gca, 'FontSize', 14);
ylabel('Distance to Goal (cm)');
xlabel('Time (sec)');


for i=0:length(time(13:36))
    velocity1(i+1) = sqrt((xloc(13+i+1) - xloc(13+i))^2+(yloc(13+i+1) - yloc(13+i))^2)*0.14;
end

for i=0:length(time(127:143))
    velocity2(i+1) = sqrt((xloc(127+i+1) - xloc(127+i))^2+(yloc(127+i+1) - yloc(127+i))^2)*0.14;
end


filename = 'test-output_14-04-2021_13:59:19.csv';
T = readtable(filename);
time = T.Var6;
time = time - time(1);
xloc = T.Var1;
yloc = T.Var2;
xgoal = T.Var4;
ygoal = T.Var5;
dist = sqrt((xloc - xgoal).^2 + (yloc - ygoal).^2)*0.14;
figure
plot(time(1:21), dist(1:21)-6, 'b', 'LineWidth', 2)
set(gca, 'FontSize', 14);
ylabel('Distance to Goal (cm)');
xlabel('Time (sec)');

for i=0:length(time(1:21))
    velocity3(i+1) = sqrt((xloc(1+i+1) - xloc(1+i))^2+(yloc(1+i+1) - yloc(1+i))^2)*0.14;
end

mean([velocity1 velocity2 velocity3])
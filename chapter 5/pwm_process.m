clear
close all

% newcolors = [0.83 0.14 0.14
%              1.00 0.54 0.00
%              0.47 0.25 0.80
%              0.25 0.80 0.54];
% data = [];
% inputs = [];
for i=1:2
    
    filename = strcat('system_data/pwm-babble-output-', num2str(i+7), '.csv');
    data{i} = readmatrix(filename);


    filename = strcat('system_data/pwm_babble', num2str(i+7), '.csv');
    inputs{i} = readmatrix(filename);
    
    input_time = inputs{i}(:,1);
    for j = 1:length(data{i})
        time = data{i}(j,1);
        
        index = find(input_time < time);
        
        if isempty(index)
            resampled_input{i}(j,:) = [0,0];
        else
            index = index(end);
            resampled_input{i}(j,:) = inputs{i}(index,2:3);
        end
    end

end

data = [data{1};data{2}];
data = [data(1:266,:); data(1132:2195,:)];
inputs = [resampled_input{1};resampled_input{2}];
inputs = [inputs(1:266,:); inputs(1132:2195,:)];

sys_data = iddata([data(:,2),data(:,3)], [inputs(:, 1), inputs(:,2)], 0.09);
sys_data.InputName  = {'PWM1';'PWM2'};
sys_data.OutputName = {'Yaw';'Pitch'};

mi = impulseest(sys_data,50);
clf, step(mi)
showConfidence(impulseplot(mi),3)
mp = ssest(sys_data)
h = stepplot(mi,'b',mp,'r',2); % Blue for direct estimate, red for mp
showConfidence(h)
compare(sys_data(500:end),mp)

msp = spa(sys_data);
clf, bode(msp,'b',mp,'r')

TR = TuningGoal.Tracking({'BOOST REF';'EGRMF REF'},{'BOOST';'EGRMF'},5,0.05);
TR.Name = 'Setpoint tracking';
TR.InputScaling = [10 3];

ss_est = ss(mp);
[K1,CL,gamma] = hinfsyn(ss_est,2,2);

% figure
% plot(time{i}, pwms{i}(:,2))
% hold on
% traj1 = commands(:,2);
% traj2 = commands(:,3);
% stairs(t_commanded, traj1,'LineWidth',2)
% xlabel('Time (s)')
% ylabel('Angle (\circ)')
% 
% plot(time, A(:,3))
% stairs(t_commanded, traj2,'LineWidth',2)
% legend('Yaw Measured', 'Yaw Commanded', 'Pitch Measured', 'Pitch Commanded')
% set(gcf, 'Position',  [100, 100, 1000, 800])
% set(gca,'FontSize',18)
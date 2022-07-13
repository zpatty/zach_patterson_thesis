clear
close all

num_pts = 20;


for i=1:25
    pwms(:,num_pts*(i-1)+1:num_pts/2*(i)+num_pts/2*(i-1)) = 0.3*randn(2,num_pts/2);
    pwms(:,num_pts/2*(i)+num_pts/2*(i-1)+1:num_pts*(i)) = zeros(2,num_pts/2);

    timestamps(num_pts*(i-1)+1:num_pts*(i)) = (100+(400 - 100)*rand(1, num_pts))/1000;
    timestamps(num_pts*(i)/2+(i-1)*num_pts/2:end) = 1;
end
pwms(pwms > 1) = 1;
pwms(pwms < -1) = -1;
timestamps = cumsum(timestamps);
plot(timestamps, pwms)
hold all
xlabel('t')
ylabel('Positions')
legend('pwm1','pwm2')
hold off

trajectory = [timestamps',pwms'];
csvwrite("pwm_babble.csv",trajectory);
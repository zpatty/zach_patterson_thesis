clear
close all
wpts = [0 -50 -90 0 90 90 0; 0 0 -90 -90 0 0 0];
end_time = 60;
tpts = linspace(0, end_time, length(wpts));

tvec = 0:0.2:end_time;

[q, qd, qdd, pp] = cubicpolytraj(wpts, tpts, tvec);

plot(tvec, q, 'LineWidth', 2)
hold all
plot(tpts, wpts, 'x')
xlabel('t')
ylabel('Positions')

hold on

trajectory = [tvec',q'];
csvwrite("patrick_traj.csv",trajectory);




% p = plot(tvec(1),q(:,1),'o','MarkerFaceColor','red');
% legend('Yaw-positions','Pitch-positions','Location', 'northwest')
% myVideo = VideoWriter('myVideoFile','Uncompressed AVI'); %open video file
% myVideo.FrameRate = 120;  %can adjust this, 5 - 10 works well for me
% open(myVideo)
% hold off
% axis manual
% for k = 2:length(tvec)
%     p(1).XData = tvec(k);
%     p(1).YData = q(1,k);
%     p(2).XData = tvec(k);
%     p(2).YData = q(2,k);
%     drawnow
%     pause(0.01) %Pause and grab frame
%     frame = getframe(gcf); %get frame
%     writeVideo(myVideo, frame);
% end
% close(myVideo)

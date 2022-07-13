function plot_curve(eul,l, times,i)
%eul = [30*pi/180 60*pi/180 0];
%l = 0.1;
rotmZYX = eul2rotm(eul);
axang = rotm2axang(rotmZYX);
plane_pts = rotmZYX*[0 0 -1]';
phi = atan(plane_pts(2)/plane_pts(1));
if isnan(phi)
    phi = 0;
end
if phi < 0
    phi = -phi + pi/2;
end
phi = pi/2 - phi;
phid = 180/pi*phi;
theta = axang(end);
k = theta/l;

s = 0:0.001:l;

[T,p] = FK(s,k(1),phi(1),eye(4));
ind = (length(s) - 1)*4 + 1;
T1_end = T(ind:ind+3,:);

plot3(p(:,1),p(:,2),-p(:,3),'--r', 'Linewidth', 8)

    
view([181 1]);
axis equal

axis equal
set(gcf, 'Position',  [0, 0, 560*4, 420*4])
xlabel('x')
ylabel('y')
zlabel('z')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
set(gca,'ztick',[])
set(gca,'zticklabel',[])
set(gca,'XColor','none')
set(gca,'YColor','none')
set(gca,'ZColor','none')
set(gca, 'color', 'none');
xlabel([])
ylabel([])
zlabel([])
if i == 2 || i == 5
    view([90 0])
elseif i == 3
    view([0 0])
else
    view([180 0])
end
save_path = strcat('/media/Shared/SML/sea star/Control/traj_snaps/', num2str(times(i)));
export_fig(save_path, '-pdf');
end
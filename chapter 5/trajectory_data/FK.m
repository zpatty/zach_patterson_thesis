function [T,p] = FK(s,k,phi,T_end)
%Calculates homog. transforms for a section of a continuum manipulator.
%T_end is the tranform for the endpoint of the previous section
theta = zeros(length(s),1);
T = zeros(length(s)*4,4);
start_ind = zeros(length(s),1);
for i = 1:length(s)
    start_ind(i) = i + 3*(i-1);
    theta(i) = k*s(i);
    M1 = [cos(phi)  -sin(phi)   0   0; 
          sin(phi)  cos(phi)    0   0; 
          0         0           1   0; 
          0         0           0   1];
    M2 = [cos(theta(i))     0   sin(theta(i))   (1 - cos(theta(i)))/k; 
          0                 1   0               0; 
          -sin(theta(i))    0   cos(theta(i))   sin(theta(i))/k; 
          0                 0   0               1];
    T(start_ind(i):start_ind(i)+3,:) = T_end*M1*M2;
end

%extract position vectors
p = zeros(length(s),3);
for i = 1:length(s)
    p(i,1) = T(start_ind(i),4);
    p(i,2) = T(start_ind(i)+1,4);
    p(i,3) = T(start_ind(i)+2,4);
end

end


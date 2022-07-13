function [constraintFcns,isterminal,direction] = guardFunctions(t,x)

a1 = -x(1) + pi/2;

a2 = x(1) + 0.001;

constraintFcns = [a1; a2];

isterminal = [true; true];

direction = [-1; -1];

end
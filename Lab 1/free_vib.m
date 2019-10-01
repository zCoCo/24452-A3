% Simulates and plots the vibrations of a 1-DOF 2nd order system subject to 
% initial conditions q0 = [x0,v0], given its three coefficient dynamic 
% properties (m,k,c) or their rotational equivalents (J,k,b):
function [xplot, vplot, ts] = free_vib(m,k,c, q0)
% Rectilinear test values:
% 2.138 kg & 760.2383 N/m & 1.9221 kg/s
% 2.378 kg & 760.2383 N/m & 1.1027 kg/s

    wn = sqrt(k/m);
    z = c / m / 2 / wn;
    ts = 4.6 / z / wn; % 1% Settling Time for Underdamped system
    tspan = 0:0.001:ts;
    [t,y] = ode45(@(t,q) secondorder(t,q, m,c,k),tspan,q0);
    
    xplot = figure();
    plot(t,y(:,1),'LineWidth',2)
    grid on;
    % axis labelling gets handled in calling function which knows the units
    % of everything.
    
    vplot = figure();
    plot(t,y(:,2),'LineWidth',2)
    grid on;
end

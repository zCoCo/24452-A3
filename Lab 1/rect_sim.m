function [xplot, vplot] = rect_sim(m,k,c)
    
    tspan = 0:0.001:10; 
    x0 = [0.02 0]; %initial conditions [x0;v0] in meters and meters/sec
    [t,y] = ode45(@(t,q) secondorder(t,q, m,c,k),tspan,x0);
    
    xplot = figure();
    plot(t,y(:,1),'LineWidth',2)
    
    grid on;
    xlabel('Time [s]');
    ylabel('Displacement [m]');
    grid on;
    vplot = figure();
    plot(t,y(:,2),'LineWidth',2)
    xlabel('Time [s]');
    ylabel('Velocity Amplitude [m]');
    grid on;
    

end
% 2.138 kg & 760.2383 N/m & 1.9221 kg/s
% 2.378 kg & 760.2383 N/m & 1.1027 kg/s \\ \hline

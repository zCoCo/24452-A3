% Write a Matlab program that can simulate the vibrations of a 1-DOF system given
% three dynamic properties (mass, spring rate, and the damping coefficient) and initial conditions
% (no forcing). For the Car 2 experiments in Experiment 2, simulate the system with Matlab and
% compare your simulation to the experimental data in time domain. Side-by-side plots resembling
% one another is sufficient. However, it would be better to present the two data sets in the same
% graph after making them in-phase at the initial time. Discuss your comparison.

function rect_sim(m,k,c)
    %transfer function?
%     t = 10; %s

    
    sysp = struct(); % System parameters
    sysp.m = m; % Unknown cart mass
    sysp.k = k;
    sysp.c = c; % Unknown system parameters
    
    % Run with and without added mass:
    sys = tf(1, [sysp.m sysp.c sysp.k]);
  
    % Create Synthetic Data:
    [~,t] = step(sys);
    tmax = max(t);
    
    t = linspace(0,tmax, 1000)'; % Roughly 1/8th number of points as in collected data
    % Resimulate with over the same time vector for comparability:
    
    Y = step(sys, t);
%     Y = Y + sin(1000*t) .* (Y-Y(end))/6; % add a bit of noise
 
    % Shove the raw data into an ETable as if we had collected it:
    tab = cell2table(cellstr(sprintfc('%d',[t,Y])));
    tab.Properties.VariableDescriptions = {'Time [s]', 'Output [m]'};
    T = ETable(tab, ["t", "y"]); % Loads in, conditions, and formats data
    T.unitsList = ["s", "m"];
    
    % Plot Output to Verify ETable Conversion:
    figure();
    T.multiplot('-', 't', 'y');
    
    % Also plot the equilibrium positions:
    ETable.hline(T.y(end), '', 'left', 'bottom');
%     ETable.hline(T.y2(end), '', 'left', 'bottom');
    

end

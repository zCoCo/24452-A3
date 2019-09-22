function cart_dataRecovery_test()
    %% Pseudo-experiment:
    
    % Setup Dummy System:
    m1 = 0; % Known mass added to cart in experiment1
    m2 = 20; % Known mass added to cart in experiment2
    
    sysp = struct(); % System parameters
    sysp.M = 80; % Unknown cart mass
    sysp.k = 0.134; sysp.c = 0.5; % Unknown system parameters
    
    % Run with and without added mass:
    sys1 = tf(1, [sysp.M+m1 sysp.c sysp.k]);
    sys2 = tf(1, [sysp.M+m2 sysp.c sysp.k]);
    % Create Synthetic Data:
    [~,t1] = step(sys1);
    [~,t2] = step(sys2);
    tmax = max(max(t1),max(t2));
    t = linspace(0,tmax, 1000)'; % Roughly 1/8th number of points as in collected data
    % Resimulate with over the same time vector for comparability:
    Y1 = step(sys1,t);
    Y2 = step(sys2,t);
    Y1 = Y1 + sin(1000*t) .* (Y1-Y1(end))/6; % add a bit of noise
    Y2 = Y2 + sin(1000*t) .* (Y2-Y2(end))/6; % add a bit of noise

    % Shove the raw data into an ETable as if we had collected it:
    tab = cell2table(cellstr(sprintfc('%d',[t,Y1,Y2])));
    tab.Properties.VariableDescriptions = {'Time [s]', 'Output 1 [m]','Output 2 [m]'};
    T = ETable(tab, ["t", "y1", "y2"]);
    T.unitsList = ["s", "m", "m"];
    
    % Plot Output to Verify ETable Conversion:
    figure();
    T.multiplot('-', 't', 'y1','y2');
    
    % Also plot the equilibrium positions:
    ETable.hline(T.y1(end), '', 'left', 'bottom');
    ETable.hline(T.y2(end), '', 'left', 'bottom');
    
    
    %% Data Recovery:
    
    % Attempt Logarithmic Decrement:
    [z1, wn1, peaks1]  = T.logdec('t','y1');
    [z2, wn2, peaks2]  = T.logdec('t','y2');
    
    % Highlight peaks used on the plot:
    hold on
        scatter(peaks1.X, peaks1.Y);
        scatter(peaks2.X, peaks2.Y);
    hold off
    
    % Reconstruct System Parameters to Verify Accuracy:
    % (assuming mass has already been experimentally verified).
    exp = struct(); % Experimental Parameters
    exp.M = (m2*wn2^2 - m1*wn1^2) / (wn1^2 - wn2^2);
    exp.k = (exp.M + m1)*wn1^2;
    exp.c = 2*z1*wn1*(exp.M+m1);
    
    % Display Results for Comparison:
    disp("Actual Parameters:");
    disp(sysp);
    disp("Parameters Recovered from Noisy Data:");
    disp(exp);
end
function logdec_test()
    % Setup Dummy System:
    m = 100; c = 0.5; k = 0.134;
    sys = tf(1, [m c k]);

    % Create Synthetic Data:
    [Y,t] = step(sys);
    Y = Y + sin(1000*t) .* (Y-Y(end))/2; % add some noise

    % Shove the raw data into an ETable as if we had collected it:
    tab = cell2table(cellstr(sprintfc('%d',[t,Y])));
    tab.Properties.VariableDescriptions = {'Time [s]', 'Output [m]'};
    T = ETable(tab, ["t", "y"]);
    T.unitsList = ["s", "m"];
    
    % Plot Output to Verify ETable Conversion:
    figure();
    T.plot('t','y', T.t==T.t, '-');
    
    % Attempt Logarithmic Decrement:
    [z, wn, peaks]  = T.logdec('t','y');
    
    % Highlight peaks used on the plot:
    hold on
        scatter(peaks.X, peaks.Y);
    hold off
    
    % Reconstruct System Parameters to Verify Accuracy:
    % (assuming mass has already been experimentally verified).
    ce = 2*z*wn*m
    ke = m*wn^2
end
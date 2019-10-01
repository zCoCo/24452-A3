% Loads the data from the given experiments, and runs a logarithmic 
% decrement on each experiement given to recover all key data. 
% Plots the results for manual sanity checks after re-zeroing the 
% experiment so that t=0 of the plot is where the highest peak is in the 
% X dataset (doesn't actually change the data).
% - Root is the path to the root directory of where the raw test data is
% stored.
% Each experiment needs the following 3 arguments:
% - testID and is human readable name / reference ID for the trial X (eg.
% 2.1.1.)
% - testName and is the name of the xlsx file containing the raw data for 
% trial X (no extensions).
% - testMasses is the a list of the masses known to be on the cart or
% 'none' (for labelling the legend only).
% 
% Returns a vectors of the natural frequencies, wn, damping ratios, z, of 
% each experiment, a cell array of all the ETables used, Ts, and a vector 
% of the indentified start times of free vibration for each experiment,
% t_start.
function [wn, z, Ts, t_start] = multi_logdec(root, varargin)
    addpath('..');
    
    if mod(numel(varargin),3) ~= 0
        error('#multi_logdec requires a root and then 3 arguments for each experiment. See documentation.');
    end
    
    testID = varargin(1:3:end);
    testName = varargin(2:3:end);
    testMasses = varargin(3:3:end);
    
    %% LOAD AND FORMAT DATA:
    Ts = {}; % Cell Array of ETables for Each Data Collection
    for i = 1:numel(testName)
        test = testName{i};
        try
            % Load cached file if there is one
            load(char(root+test+".mat"), 'T');
            Ts{i} = T;
        catch
            % Otherwise, create ETable from xlsx of raw data and then
            % cache it.
            T = ETable(char(root+test+".xlsx"), ["t","F", "x1","x2","x3", "E", "v1","v2","v3", "a1","a2","a3", "note"]); % Long-form names used in plotting are automatically imported from column headers
            save(char(root+test+".mat"), 'T');
            Ts{i} = T;
        end
    end
    
    % Figure out the Displacement Units:
    if contains(root, "Rect")
        xunits = "m";
    else
        xunits = "rad";
    end
        
    
    % Assign (latex formatted) Units to Each Column:
    for i=1:numel(Ts)
        Ts{i}.unitsList = ["s","N", xunits,xunits,xunits, "", "$\tfrac{"+xunits+"}{s}$","$\tfrac{"+xunits+"}{s}$","$\tfrac{"+xunits+"}{s}$", "$\tfrac{"+xunits+"}{s^2}$","$\tfrac{"+xunits+"}{s^2}$","$\tfrac{"+xunits+"}{s^2}$", ""];
  
        % Rename Poorly Named Columns:
        Ts{i}.rename('t', 'Time [s]');
        Ts{i}.rename('F', 'Force [N]');
        
        % Find the Displacement with the Highest Peak and Assume that's
        % where the data is and treat that as 'x1' (the data of interest):
        dataPeaks = [max(Ts{i}.x1), max(Ts{i}.x2), max(Ts{i}.x3)];
        [~, activeDataColumn] = max(dataPeaks);
        Ts{i}.edit('x1', Ts{i}.get(char("x"+activeDataColumn)));
        Ts{i}.edit('v1', Ts{i}.get(char("v"+activeDataColumn)));
        Ts{i}.edit('a1', Ts{i}.get(char("a"+activeDataColumn)));
        
        % Update to SI Base Units:
        Ts{i}.edit('x1', Ts{i}.x1 * 1e-3);
        Ts{i}.rename('x1', char("Displacement 1 ["+xunits+"]"));
        Ts{i}.edit('v1', Ts{i}.v1 * 1e-3);
        Ts{i}.rename('v1', char("Velocity 1 [$^{"+xunits+"}/_s$]"));
        Ts{i}.edit('a1', Ts{i}.a1 * 1e-3);
        Ts{i}.rename('a1', char("Acceleration 1 [$^{"+xunits+"}/_{s^2}$]"));
    end
    
    %% ANALYZE DATA:
    % Find Start Time of Free Vibration, t0 (visually vertified that this
    % also is the highest peak):
    for i = 1:numel(Ts)
        [~,maxIdx] = max(Ts{i}.x1);
        t_start(i) = Ts{i}.t(maxIdx(1));
    end
    
    % Attempt Logarithmic Decrement:
    n = numel(Ts);
    z = zeros(n,1);
    wn = zeros(n,1);
    peaks = {};
    yinf = zeros(n,1);
    for i = 1:n
        [z(i), wn(i), peaks{i}, yinf(i)]  = Ts{i}.logdec('t','x1', Ts{i}.t > t_start(i));
    end
    
    %% VISUALIZE DATA TO VERIFY LOG DECREMENT PEAK SELECTION:
    % Plot Output to Verify ETable Conversion:
    massesList = cell(numel(testMasses),1);
    leg = cell(4*numel(testMasses),1);
    figure();
    for i = 1:numel(Ts)
        % Plot the system response
        Ts{i}.plot('t', 'x1', Ts{i}.t >= t_start(i), '-', -t_start(i));
        % Also plot the equilibrium positions:
        ETable.hline(Ts{i}.x1(end), '', 'left', 'bottom');
        
        % Create the Legend:
        if isnumeric(testMasses{i})
            massesList{i} = sprintf('%.0f, ' , testMasses{i});
            massesList{i} = massesList{i}(1:end-2);
        else
            massesList{i} = testMasses{i};
        end
        leg{2*(i-1) + 1} = char(testID{i}+": Cart with Known Masses: "+massesList{i});
        leg{2*(i-1) + 2} = char("Equilibrium Position of test "+testID{i});
    end
    for i = 1:numel(Ts)
        hold on
        % Highlight peaks used on the plot:
        scatter(peaks{i}.X-t_start(i), peaks{i}.Y);
        % Plot Envelopes to Verify Collected z,wn:
        envDecay = @(t) (peaks{i}.Y(1)-yinf(i))*exp(-z(i).*wn(i).*(t-peaks{i}.X(1)+t_start(i)))./sqrt(1-z(i)^2);
        fplot(@(t)yinf(i) + envDecay(t), [0, Ts{i}.t(end)], ':');
        fplot(@(t)yinf(i) - envDecay(t), [0, Ts{i}.t(end)], ':');
        hold off
        
        % Create the Legend:
        leg{2*n + (i-1)*3 + 1} = char("Peaks used in Logarithmic Decrement for "+testID{i});
        leg{2*n + (i-1)*3 + 2} = char("Upper Envelope of test "+testID{i}+" built using calculated $\omega_n$, $\zeta$");
        leg{2*n + (i-1)*3 + 3} = char("Lower Envelope of test "+testID{i}+" built using calculated $\omega_n$, $\zeta$");
    end
    legend(leg, 'Interpreter', 'latex');
end
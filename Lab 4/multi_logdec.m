% Loads the data from the given experiments, and runs a logarithmic 
% decrement on each experiement given to recover all key data. 
% Plots the results for manual sanity checks after re-zeroing the 
% experiment so that t=0 of the plot is where the highest peak is in the 
% X dataset (doesn't actually change the data).
% - xunits is the displacement units used by the experiment (SI base units
% so "m" or "rad")
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
% ** An additional final argument can be added to varargin indicating the
% name of the column to be used for logdec (by default, it's 'x1').
% 
% Returns a vectors of the natural frequencies, wn, damping ratios, z, of 
% each experiment, a cell array of all the ETables used, Ts, a vector 
% of the indentified start times of free vibration for each experiment,
% t_start, and a vector, t_end, of when the response is suitably over 
% (plotting should be stopped).
function [wn, z, Ts, t_start, t_end] = multi_logdec(xunits, root, varargin)
    addpath('..');
    
    if mod(numel(varargin),3) == 1
        column = varargin{end};
        varargin = varargin(1:end-1);
    else
        column = 'x1';
    end
    if mod(numel(varargin),3) > 1
        error('#multi_logdec requires a root and then 3 arguments for each experiment. See documentation.');
    end
    
    testID = varargin(1:3:end);
    testName = varargin(2:3:end);
    testMasses = varargin(3:3:end);
    
    %% LOAD AND FORMAT DATA:
    Ts = {}; % Cell Array of ETables for Each Data Collection
    for i = 1:numel(testName)
        test = testName{i};
        Ts{i} = load_data(fullfile(root,test+".txt"), xunits);
    end
    
    % Determine string to be used to refer to carrier:
    if xunits == "m" % Rectilinear:
        carrier = "Cart";
        massTerm = "Mass";
    else % Torsional:
        carrier = "Disk";
        massTerm = "Inertia";
    end

    
    %% ANALYZE DATA:
    % Find Start Time of Free Vibration, t0 (visually vertified that this
    % also is the highest peak):
    for i = 1:numel(Ts)
        [~,maxIdx] = max(Ts{i}.get(column));
        t_start(i) = Ts{i}.t(maxIdx(1));
    end
    
    % Attempt Logarithmic Decrement:
    n = numel(Ts);
    z = zeros(n,1);
    wn = zeros(n,1);
    peaks = {};
    yinf = zeros(n,1);
    for i = 1:n
        [z(i), wn(i), peaks{i}, yinf(i)]  = Ts{i}.logdec('t',column, Ts{i}.t > t_start(i));
    end
    
    %% VISUALIZE DATA TO VERIFY LOG DECREMENT PEAK SELECTION:
    % Plot Output to Verify ETable Conversion:
    massesList = cell(numel(testMasses),1);
    leg = cell(4*numel(testMasses),1);
    figure();
    for i = 1:numel(Ts)
        % Plot the system response
        Ts{i}.plot('t', column, Ts{i}.t >= t_start(i), '-', -t_start(i));
        % Also plot the equilibrium positions:
        col = Ts{i}.get(column);
        ETable.hline(col(end), '', 'left', 'bottom');
        
        % Create the Legend:
        if isnumeric(testMasses{i})
            massesList{i} = sprintf('%.2f, ' , testMasses{i});
            massesList{i} = massesList{i}(1:end-2);
        else
            massesList{i} = join(string(testMasses{i}), ', ');
        end
        leg{2*(i-1) + 1} = char("Test "+testID{i}+": "+carrier+" with Known Added "+massTerm+": "+massesList{i});
        leg{2*(i-1) + 2} = char("Equilibrium Position of Test "+testID{i});
    end
    for i = 1:numel(Ts)
        hold on
        % Highlight peaks used on the plot:
        scatter(peaks{i}.X-t_start(i), peaks{i}.Y);
        % Plot Envelopes to Verify Collected z,wn:
        envDecay = @(t) (peaks{i}.Y(1)-yinf(i))*exp(-z(i).*wn(i).*(t-peaks{i}.X(1)+t_start(i)))./sqrt(1-z(i)^2);
        fplot(@(t)yinf(i) + envDecay(t), [0, Ts{i}.t(end) - t_start(i)], ':');
        fplot(@(t)yinf(i) - envDecay(t), [0, Ts{i}.t(end) - t_start(i)], ':');
        hold off
        
        % Create the Legend:
        leg{2*n + (i-1)*3 + 1} = char("Peaks used in Logarithmic Decrement for Test "+testID{i});
        leg{2*n + (i-1)*3 + 2} = char("Upper Envelope of Test "+testID{i}+" built using calculated $\omega_n$, $\zeta$");
        leg{2*n + (i-1)*3 + 3} = char("Lower Envelope of Test "+testID{i}+" built using calculated $\omega_n$, $\zeta$");
    end
    legend(leg, 'Interpreter', 'latex');
    
    for i = 1:n
        t_end(i) = min([Ts{i}.t(end) - t_start(i), (peaks{i}.X(end) - t_start(i)) * 1.5]);
    end
end
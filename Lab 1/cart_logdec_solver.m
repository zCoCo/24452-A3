% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it.
% - Root is the path to the root directory of where the raw test data is
% stored.
% - testXID and is human readable name / reference ID for the trial X (eg.
% 2.1.1.)
% - testXName and is the name of the xlsx file containing the raw data for 
% trial X (no extensions).
% - testXMasses is the a list of the IDs of the masses added to the cart in
% trial X (eg. [1 2 6]). Can be an empty list if no masses attached.
function cart_logdec_solver(root, test1ID, test1Name, test1Masses, test2ID, test2Name, test2Masses)
    addpath('..');
    %% PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb(1) = 490.5e-3; 
    mb(2) = 485.5e-3;
    mb(3) = 240.5e-3;
    mb(6) = 490.5e-3;
    
    % Total Masses Added to Carts [kg]:
    m1 = sum(mb(test1Masses));
    m2 = sum(mb(test2Masses));
    
    %% LOAD AND FORMAT DATA:
    Ts = {}; % Cell Array of ETables for Each Data Collection
    i = 1;
    for test = [test1Name, test2Name]
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
        i = i+1;
    end
    
    % Assign (latex formatted) Units to Each Column:
    for i=1:2
        Ts{i}.unitsList = ["s","N", "m","m","m", "", "$\tfrac{m}{s}$","$\tfrac{m}{s}$","$\tfrac{m}{s}$", "$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$", ""];
  
        % Rename Poorly Named Columns:
        Ts{i}.rename('t', 'Time [s]');
        Ts{i}.rename('F', 'Force [N]');
        % Update to SI Base Units:
        Ts{i}.edit('x1', Ts{i}.x1 * 1e-3);
        Ts{i}.rename('x1', 'Displacement 1 [m]');
    end
    
    %% ANALYZE DATA:
    % Find Start Time of Free Vibration, t0 (visually vertified that this
    % also is the highest peak):
    for i = 1:2
        [~,maxIdx] = max(Ts{i}.x1);
        t_start(i) = Ts{i}.t(maxIdx(1));
    end
    
    % Attempt Logarithmic Decrement:
    [z1, wn1, peaks1]  = Ts{1}.logdec('t','x1', Ts{1}.t > t_start(1));
    [z2, wn2, peaks2]  = Ts{2}.logdec('t','x1', Ts{2}.t > t_start(2));
    
    % Reconstruct System Parameters to Verify Accuracy:
    % (assuming mass has already been experimentally verified).
    exp = struct(); % Experimentally Recovered Parameters
    exp.z1 = z1;
    exp.z2 = z2;
    exp.M = (m2*wn2^2 - m1*wn1^2) / (wn1^2 - wn2^2);
    exp.k1 = (exp.M + m1)*wn1^2;
    exp.k2 = (exp.M + m2)*wn2^2;
    exp.c1 = 2*z1*wn1*(exp.M+m1);
    exp.c2 = 2*z2*wn2*(exp.M+m2);
    
    % Display Results for Evaluation:
    disp("Parameters Recovered from Data (in SI Base Units):");
    disp(exp);
    disp("Damping Ratio Percent Difference:");
    disp( 100 * abs(diff([z1 z2])) / mean([z1 z2]) );
    disp("Damping Coefficient Percent Difference:");
    disp( 100 * abs(diff([exp.c1 exp.c2])) / mean([exp.c1 exp.c2]) );
    
    
    %% VISUALIZE DATA TO VERIFY LOG DECREMENT PEAK SELECTION:
    % Plot Output to Verify ETable Conversion:
    figure();
    for i = 1:2
        % Plot the system response
        Ts{i}.plot('t', 'x1', Ts{i}.t >= t_start(i), '-', -t_start(i));
        % Also plot the equilibrium positions:
        ETable.hline(Ts{i}.x1(end), '', 'left', 'bottom');
    end
    % Highlight peaks used on the plot:
    hold on
        scatter(peaks1.X-t_start(1), peaks1.Y);
        scatter(peaks2.X-t_start(2), peaks2.Y);
    hold off
    massesList1 = sprintf('%.0f,' , test1Masses);
    massesList2 = sprintf('%.0f,' , test2Masses);
    legend({...
        char(test1ID+"2.1.1: Cart with Masses "+massesList1(1:end-1)), ...
        char("Equilibrium Position of "+test1ID), ...
        char(test2ID+"2.1.1: Cart with Masses "+massesList2(1:end-1)), ...
        char("Equilibrium Position of "+test2ID), ...
        char("Peaks used in LogDec for "+test1ID), ...
        char("Peaks used in LogDec for "+test2ID), ...
        }, 'Interpreter', 'latex');
end
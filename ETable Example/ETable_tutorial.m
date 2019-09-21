function ETable_tutorial()
addpath('..');
%% SETUP EXAMPLE:


    % Create Table from Excel, Specifying a shortName for Each Non-empty
    % column which will be used to reference it later:
    T = ETable('A4_HT14C_A.xlsx', ["N","t", "T9","T10", "V","I", "Ua"]); % !! Make sure to file>save-as *.xlsx first
    
    % Print Top of Table to Command Line:
    head(T);
    
    
    
%% MANIPULATING COLUMNS EXAMPLES:


    % Add a New Calculated Column (make sure to use .* not * etc.)
    T.add('Electrical Power [W]', 'Qe', T.V .* T.I); % Qe = V*I
    
    % Edit an Existing Column (increase all Sample Numbers by 100):
    T.edit('T9', T.T9 + 273.15); % Convert to Kelvin
    T.edit('t', T.t .* 1440); % Convert from Days to Minutes
    
    % Change the Full Display Name Associated with the Given Short Name:
    % Note, the name shown in the command-line table is stylized to remove
    % spaces and special characters. These will still show up on plot
    % labels.
    T.rename('T9', 'Temperature of Duct [K]');
    T.rename('t', 'Time Elapsed [min]');
    T.rename('T10', 'Temperature of Heater [$$^{\circ}$$C]'); % You can also use latex too

    % See Effect of Above Changes:
    T.head();
    
    
%% DISPLAYING DATA EXAMPLES:
    

    % Show a Summary Table, Containing the Average Values of All Variables
    % in Each of the Given Ranges (ex. Voltage, within 0.05 = 5% of given
    % values):
    T.summary(...
        within(T.V, 0.05, 4.5),...
        within(T.V, 0.05, 7.0),...
        within(T.V, 0.05, 9.0),...
        within(T.V, 0.05, 13.5),...
        within(T.V, 0.05, 18.0) ...
    );
    
    % Note: These members are just vectors; so, std. functions still apply:
    % Ex. Find average electrical power when voltage is (within 5% of) 9V:
    avgEPowerAt9V = mean( T.Qe(within(T.V, 0.05, 9)) )
    
    
%% DATA PLOTTING EXAMPLES:


    % Plot The Given Variables (x,y):
    figure();
    p = T.plot('t', 'T10');
    p.set('MarkerEdgeColor', 'red'); % Plot handles are returned and can still be styled like usual
    
    % Plot The Given Variables (x,y) over a cell range:
    figure();
    T.plot('T10', 'Qe', 176:340);
    title('Electrical Power vs Heater Temperature over an Arbitrary Sample Range');
  
    
%% ADVANCED DATA PLOTTING EXAMPLES:


    % Plot the Given Variables (x,y) based on a conditional expression on
    % the voltage V, if V is within 5% of specified voltages:
    figure();
    hold on
        T.plot('t', 'Qe', within(T.V, 0.05, 4.5));
        T.plot('t', 'Qe', within(T.V, 0.05, 9));
        T.plot('t', 'Qe', within(T.V, 0.05, 18));
    hold off
    title('Electrical Power over Time across Three Different Supply Voltages');
    legend('V=4.5', 'V=9.0', 'V=18.0');
    
    % Create a New Column for Error, and use it to size the error bars in a
    % plot between two variables:
    dI = 0.05; dV = 0.05; % Constant Errors in Current and Voltage Measurements
    T.add('Qe Error [dW]', 'dQe', sqrt(T.V.^2 .* dI.^2 + T.I.^2 .* dV.^2)); % Error in Electrical Power:
    figure();
    % Only show errorbars every 10 data points:
    T.errorplot('t', 'Qe', 'dQe', 10, inrange(T.V, 4.4,13.5)); % All the special features above still apply too!
    title('Electrical Power and Associated Error for Voltages between 4.4V and 13.5V');
    
end

%% NICE-TO-HAVE HELPER FUNCTIONS:
% Don't worry about these; just copy them over into problem file.
% Also stored under ETable.within and ETable.inrange if you don't want to
% copy them into each file.

% Returns whether the given value is within the given fractional range of
% the given target:
function w = within(val, range, target)
    w = val < (target + range.*target) & val > (target - range.*target);
end
% Returns whether the given value is within the given range
function w = inrange(val, lb,ub)
    w = val <= ub & val >= lb;
end
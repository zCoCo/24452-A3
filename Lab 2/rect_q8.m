function rect_q8()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 490.5e-3;
    mb2 = 485.5e-3;
    mb3 = 240.5e-3;
    mb6 = 490.5e-3;
    Mc = mean([0.768, 0.672, 0.553]); % Mean of Cart Masses Determined in Lab 1
    % Common Mass Configurations:
    M4 = Mc + mb1 + mb2 + mb3 + mb6; % All four masses
    M1 = Mc + mb1; % One big mass
    M0 = Mc; % No Masses
    
    % From Question 5:
    kphys = 375.7; % physical spring rate
    cphys = 2.916; % % physical damping coefficient
    
    root = "RectData/exp2/"; % Root directory of all tests:
    xunits = "m"; % Displacement units

%% STEP RESPONSE TESTS:
    F0 = 2; % [N] Impulse amplitude
    w0 = 2*pi*2; % [rad/s] Impulse Freq.
    t0 = 0.2; % Start time
    u = @(t) F0 * sin(w0*(t-t0)) * (t>t0); % [N] Step Input
    q0 = [0 0]; % [m, m/s] Initial Conditions (x0, v0)
    ms = [M4 M4 M4 M1 M1 M1];
    ks = [375 750 375 125 375 375] + kphys; % Stiffnesses [N/m] (simulated parallel to physical)
    cs = [1.25 1.25 62.5 1.25 1.25 62.5] + cphys; % Damping Ratios [kg/s] (simulated in series with physical)
    % Compare Each Test to Simulation:
    step_data = {'Test #','Parameter','Simulated','Experimental','%Difference'}; % output data (for easy copying to table in report).
    for i = 1:6
        % Get Experimental Data:
        T = load_data(fullfile(root,"3.4","test"+i+".txt"), xunits);
        
        % Perform Simulation:
        [xs, ~, ts] = free_vib(ms(i),ks(i),cs(i), u, q0, T.t(end));
        
        % Plot Both Responses:
        figure();
        plot(ts, xs);
        T.plot('t', 'x1', T.allrows, '-');
        leg = {'ODE45 Simulation', 'Experimental Results'}; % Legend
        
        legend(leg, 'Interpreter', 'latex');
        saveas(gcf, char("rect_q8-"+i+".png"), 'png');
        title({'Effect of Harmonic Input on Second Order System', char("Experiment "+i)}, 'Interpreter', 'latex');
       
        % Compare Results:
        sim_info = stepinfo(xs,ts, xs(end)); % Matlab function to grab characteristics about step response.
        exp_info = stepinfo(T.x1, T.t, T.x1(end));
        parameters = ["Overshoot", "SettlingTime", "RiseTime"]; % Parameters to compare.
        for param = parameters
            % Add row for each comparison:
            results.(param) = [sim_info.(param), exp_info.(param), PDiff(sim_info.(param), exp_info.(param))];
            % Append Results to Step Data Table:
            step_data(end+1,:) = {i, string(param), double(vpa(sim_info.(param),2)), double(vpa(exp_info.(param),2)), double(vpa(PDiff(sim_info.(param), exp_info.(param)),2))};
        end
        results.SSdisp = [xs(end), T.x1(end), PDiff(xs(end),T.x1(end))]; % Percent Error
        step_data(end+1,:) = {i, "SS Displacement", double(vpa(1000*xs(end),2)), double(vpa(1000*T.x1(end),2)), double(vpa(PDiff(xs(end),T.x1(end)),2))};
        
        % Print Results:
        disp("Impulse Experiment "+i+": "+sprintf("m=%.3fkg, c=%.3fkg/s, k=%.0fN/m", ms(i),cs(i),ks(i)));
        disp(results);
    end
    
    % Compute Better Estimate for k:
    ksim = ks - kphys; % Simulated values of k
    kest = mean(4 ./ ([step_data{5:4:end,4}]/1000) - ksim)
    
    % Compute Better Estimate for c:
    wns = sqrt(ks./ms); % Natural Frequencies of configs.
    zs = cs ./ ms ./ 2 ./ wns; % Damping ratios of configs.
    csim = cs - cphys; % Simulated values of k
    cest = (8*ms ./ ([step_data{3:4:end,4}]) - csim) .* (zs < 1); % only applies to underdamped case
    cest = mean(cest(cest>0)) % ignore non-physical estimates
    
    % Export Data for Easy Copying to Report:
    step_data = cell2table(step_data); % Convert to table
    step_data.Properties.VariableNames = {'TestNumber','Parameter','Simulated','Experimental','PercentDifference'}; % Label Table
    writetable(step_data, 'rect_q8_stepData.xlsx');
    % Create headers table for easy copying to report:
    step_headers(:,1) = num2cell(1:numel(ms));
    step_headers(:,2) = num2cell(double(vpa(ms,3)));
    step_headers(:,3) = num2cell(double(vpa(cs,3)));
    step_headers(:,4) = num2cell(double(vpa(ks,3)));
    step_headers(:,5) = num2cell(double(vpa(wns,3)));
    step_headers(:,6) = num2cell(double(vpa(zs,3)));
    step_headers = cell2table(step_headers); % Convert to table
    step_headers.Properties.VariableNames = {'TestNumber','m','c','k','wn','z'}; % Label Table
    writetable(step_headers, 'rect_q8_stepDataHeaders.xlsx');
end

% Returns the Percent Difference between 'a' and 'b'.
function pd = PDiff(a,b)
    pd = 100*abs(a-b) / mean([a,b]);
end
function rect_q6()
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
    
    root = "RectData/exp2/"; % Root directory of all tests:
    xunits = "m"; % Displacement units

%% STEP RESPONSE TESTS:
    u = @(t) 4 * (t>1); % [N] Step Input (4N delayed by 1s)
    q0 = [0 0]; % [m, m/s] Initial Conditions (x0, v0)
    ms = [M4 M4 M4 M1 M1 M1 M0 M0 M0];
    ks = [300 500 300 300 300 300 100 800 800] + 375.7; % Stiffnesses [N/m] (simulated parallel to physical)
    cs = [5 5 80 1 5 30 30 1 5] + 2.916; % Damping Ratios [kg/s] (simulated in series with physical)
    % Compare Each Test to Simulation:
    step_data = {'Test #','Parameter','Simulated','Experimental','%Difference'}; % output data (for easy copying to table in report).
    for i = 1:9
        % Get Experimental Data:
        T = load_data(fullfile(root,"3.2","test"+i+".txt"), xunits);
        
        % Perform Simulation:
        [xs, ~, ts] = free_vib(ms(i),ks(i),cs(i), u, q0, T.t(end));
        
        % Create Analytical Underdamped Response Function:
        wn = sqrt(ks(i)/ms(i));
        z = cs(i) / ms(i) / 2 / wn;
        wd = wn * sqrt(1-z^2);
        x_anal = @(t) exp(-z*wn*t) .* ( q0(1).*cos(wd*t) + (z*wn*q0(1)+q0(2)).*sin(wd*t)./wd);
        
        % Plot Both Responses:
        figure();
        plot(ts, xs);
        T.plot('t', 'x1', T.allrows, '-');
        leg = {'ODE45 Simulation', 'Experimental Results'}; % Legend
        
        if(z < 1) % Plot underdamped case
        hold on
            fplot(x_anal, [0,T.t(end)]);
            leg{end+1} = char("Analytical Underdamped Response for $\zeta="+sprintf("%0.3f",z)+"$, $\omega_{n}="+sprintf("%0.2f",wn)+"^{rad}/_{s}$");
        hold off
        end
        title({'Effect Step Input on Second Order System', char("Experiment "+i)}, 'Interpreter', 'latex');
        legend(leg, 'Interpreter', 'latex');
       
        
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
        disp("Step Experiment "+i+": "+sprintf("m=%.3fkg, c=%.3fkg/s, k=%.0fN/m", ms(i),cs(i),ks(i)));
        disp(results);
    end
        
    % Export Data for Easy Copying to Report:
    step_data = cell2table(step_data); % Convert to table
    step_data.Properties.VariableNames = {'TestNumber','Parameter','Simulated','Experimental','PercentDifference'}; % Label Table
    writetable(step_data, 'rect_q6_stepData.xlsx');
    % Create headers table for easy copying to report:
    step_headers(:,1) = num2cell(1:numel(ms));
    step_headers(:,2) = num2cell(double(vpa(ms,3)));
    step_headers(:,3) = num2cell(double(vpa(cs,3)));
    step_headers(:,4) = num2cell(double(vpa(ks,3)));
    step_headers = cell2table(step_headers); % Convert to table
    step_headers.Properties.VariableNames = {'TestNumber','m','c','k'}; % Label Table
    writetable(step_headers, 'rect_q6_stepDataHeaders.xlsx');
    
end

% Returns the Percent Difference between 'a' and 'b'.
function pd = PDiff(a,b)
    pd = 100*abs(a-b) / mean([a,b]);
end
function rect_q9()
    % Initial Conditions:
    q0 = [0.02 0]; % x0 in m, v0 in m/s

    % Fetch Experimental Results from Question 6:
    [exp1, exp2] = rect_q6();
    exp(1:2) = {exp1,exp2};
    
    for i = 1:2 % For each car2 experiment
        % Simulate and Plot the system with the parameters recovered in Q6:
        [xplot, vplot, ts] = free_vib(exp{i}.m, exp{i}.k, exp{i}.c, q0);
        
        % Plot the data from Q6 alongside the sim:
        figure(xplot); % Snag rect_sim's position figure
        exp{i}.data.plot('t','x1', exp{i}.data.t >= exp{i}.t0, '-', -exp{i}.t0);
        xlim([0 max(exp{i}.tf,ts)]); % Rescale the x-axis
        title({char("Car 2, Experiment " + i), char("m = " + exp{i}.m + "kg , k = " + exp{i}.k + "$^N/_m$, c = " + exp{i}.c + "$^{kg}/_s$")}, 'Interpreter', 'latex'); 
        legend({'2nd Order System Simulated from experimental $k$,$c$,$m$', 'Experimental Data'}, 'Interpreter', 'latex');
        saveas(gcf, char(mfilename+"_exp"+i+"_pos.png"), 'png');
        
        figure(vplot); % Snag rect_sim's velocity figure
        exp{i}.data.plot('t','v1', exp{i}.data.t >= exp{i}.t0, '-', -exp{i}.t0);
        xlim([0 max(exp{i}.tf,ts)]); % Rescale the x-axis
        title({char("Car 2, Experiment " + i), char("m = " + exp{i}.m + "kg , k = " + exp{i}.k + "$^N/_m$, c = " + exp{i}.c + "$^{kg}/_s$")}, 'Interpreter', 'latex');
        legend({'2nd Order System Simulated from experimental $k$,$c$,$m$', 'Experimental Data'}, 'Interpreter', 'latex');
        saveas(gcf, char(mfilename+"_exp"+i+"_vel.png"), 'png');
    end
end
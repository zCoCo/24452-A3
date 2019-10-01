function rot_q7()
    % Fetch Experimental Results from Question 6:
    [exp1, exp2] = rot_q5();
    exp(1:2) = {exp1,exp2};
    
    for i = 1:2 % For each car2 experiment
        % Simulate and Plot the system with the parameters recovered in Q6:
        [xplot, vplot] = rect_sim(exp{i}.m, exp{i}.k, exp{i}.c);
        
        % Plot the data from Q6 alongside the sim:
        figure(xplot); % Snag rect_sim's position figure
        exp{i}.data.plot('t','x1', exp{i}.data.t >= exp{i}.t0, '-', -exp{i}.t0);
        title({char("Car 2, Experiment " + i), char("m = " + exp{i}.m + "kg , k = " + exp{i}.k + "$^N/_m$, c = " + exp{i}.c + "$^{kg}/_s$")}, 'Interpreter', 'latex'); 
        legend({'2nd Order System Simulated from experimental $k$,$b$,$m$', 'Experimental Data'}, 'Interpreter', 'latex');
        saveas(gcf, char(mfilename+"_exp"+i+"_pos.png"), 'png');
        
        figure(vplot); % Snag rect_sim's velocity figure
        exp{i}.data.plot('t','v1', exp{i}.data.t >= exp{i}.t0, '-', -exp{i}.t0);
        title({char("Car 2, Experiment " + i), char("m = " + exp{i}.m + "kg , k = " + exp{i}.k + "$^N/_m$, c = " + exp{i}.c + "$^{kg}/_s$")}, 'Interpreter', 'latex');
        legend({'2nd Order System Simulated from experimental $k$,$b$,$m$', 'Experimental Data'}, 'Interpreter', 'latex');
        saveas(gcf, char(mfilename+"_exp"+i+"_vel.png"), 'png');
    end
end
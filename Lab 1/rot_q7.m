function rot_q7()
    % Initial Conditions:
    q0 = [15*pi/180 0]; % x0 in rad, v0 in rad/s

    % Fetch Experimental Results from Question 5:
    [exp1, exp2] = rot_q5();
    exp(1:2) = {exp1,exp2};
    
    for i = 1:2 % For each car2 experiment
        % Simulate and Plot the system with the parameters recovered in Q6:
        [xplot, vplot, ts] = free_vib(exp{i}.J, exp{i}.k, exp{i}.b, q0);
        
        % Plot the data from Q6 alongside the sim:
        figure(xplot); % Snag rect_sim's position figure
        exp{i}.data.plot('t','x1', exp{i}.data.t >= exp{i}.t0, '-', -exp{i}.t0);
        xlim([0 max(exp{i}.tf,ts)]); % Rescale the x-axis
        title({char("Disk 2, Experiment " + i), char("J = " + exp{i}.J + "$kgm^2$ , k = " + exp{i}.k + "$^{Nm}/_{rad}$, b = " + exp{i}.b + "$^{Nms}/_{rad}$")}, 'Interpreter', 'latex'); 
        legend({'2nd Order System Simulated from experimental $k$,$b$,$m$', 'Experimental Data'}, 'Interpreter', 'latex');
        saveas(gcf, char(mfilename+"_exp"+i+"_pos.png"), 'png');
        
        figure(vplot); % Snag rect_sim's velocity figure
        exp{i}.data.plot('t','v1', exp{i}.data.t >= exp{i}.t0, '-', -exp{i}.t0);
        xlim([0 max(exp{i}.tf,ts)]); % Rescale the x-axis
        title({char("Disk 2, Experiment " + i), char("J = " + exp{i}.J + "$kgm^2$ , k = " + exp{i}.k + "$^{Nm}/_{rad}$, b = " + exp{i}.b + "$^{Nms}/_{rad}$")}, 'Interpreter', 'latex'); 
        legend({'2nd Order System Simulated from experimental $k$,$b$,$m$', 'Experimental Data'}, 'Interpreter', 'latex');
        saveas(gcf, char(mfilename+"_exp"+i+"_vel.png"), 'png');
    end
end
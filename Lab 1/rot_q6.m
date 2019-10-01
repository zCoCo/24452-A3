% Recover all system properties possible from two subsequent trials of a
% disk in free vibration with different known masses attached to it as
% required by problem Q6 in the rotational section.
function [sys1, sys2] = rot_q6()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 501.5e-3; 
    mb2 = 501.0e-3;
    mb3 = 501.25e-3;
    
    % Known Mass added to Each Disk [kg]:
    J1 = 0; % Known inertia added to disk in experiment 1
    J2 = (mb1 + mb2 + mb3)*(9e-2)^2; % Known inertia added to disk in experiment 2 (point mass assumption)
    
    root = "RotData/exp2_disk3/";
    [wn, z, tables, t_start] = multi_logdec(root, "2.4.1", "test1", "none", "2.4.2", "test2", [1,2,3]); % Returns Experimental Results
    saveas(gcf, char(mfilename+".png"), 'png');
    
    
    % Reconstruct System Parameters:
    res = struct(); % Results
    res.z1 = z(1);
    res.z2 = z(2);
    res.J = (J2*wn(2)^2 - J1*wn(1)^2) / (wn(1)^2 - wn(2)^2); % Remaining Unknown inertia
    res.k1 = (res.J + J1)*wn(1)^2;
    res.k2 = (res.J + J2)*wn(2)^2;
    res.b1 = 2*z(1)*wn(1)*(res.J+J1);
    res.b2 = 2*z(2)*wn(2)*(res.J+J2);
    
    % Display Results for Evaluation:
    disp("Parameters Recovered from Data (in SI Base Units):");
    disp(res);
    % Return Complete 2nd Order System Parameters (for use in rect_q9):
    sys1 = struct(); % For first experiment
    sys1.j = res.J + J1;
    sys1.b = res.b1;
    sys1.k = res.k1;
    sys1.data = tables{1}; % Data table of experiment
    sys1.t0 = t_start(1); % Start time of free-vibration.
    
    sys2 = struct(); % For first experiment
    sys2.j = res.J + J2;
    sys2.b = res.b2;
    sys2.k = res.k2;
    sys2.data = tables{2}; % Data table of experiment
    sys2.t0 = t_start(2); % Start time of free-vibration.
    
end
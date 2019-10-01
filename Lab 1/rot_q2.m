% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it as
% required by problem Q2 in the rotational section.
function rot_q2()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 501.5e-3; 
    mb2 = 501e-3;
    mb3 = 501.25e-3;
    mb4 = 502.25e-3;
    
    % parallel axis theorem: 1/2*m_block*r_block^2 + 1/2
    % Known Mass added to Each Cart [kg]:
    m2j = @(m) (m*9e-2)^2 / 2;
    
    m1 = 0; % Known mass added to disk in experiment 1
    m2 = mb1+ mb2 +mb3+mb4; % Known mass added to disk in experiment 2
    radius_block = 0.0381; % 1.5 inches 
    J1 = m1*(9e-2)^2
    J2 = m2*(9e-2)^2
    
    root = "RotData/exp2_disk1/";
    [wn, z] = multi_logdec(root, "trial1", "exp2_test1", "none", "trial2", "exp2_test2", [1,2,3]); % Returns Experimental Results
    f = gcf;
    f.WindowState = 'maximized';
    saveas(gcf, char(mfilename+".png"), 'png');
    
    % Reconstruct System Parameters:
    res = struct(); % Results
    res.z1 = z(1);
    res.z2 = z(2);
    res.J = (J2*wn(2)^2 - J1*wn(1)^2) / (wn(1)^2 - wn(2)^2); % Remaining Unknown mass
    res.k1 = (res.J + J1)*wn(1)^2;
    res.k2 = (res.J + J2)*wn(2)^2;
    res.c1 = 2*z(1)*wn(1)*(res.J+J1);
    res.c2 = 2*z(2)*wn(2)*(res.J+J2);
    
    % Display Results for Evaluation:
    disp("Parameters Recovered from Data (in SI Base Units):");
    disp(res);
    disp("Damping Ratio Percent Difference:");
    disp( 100 * abs(diff([z(1) z(2)])) / mean([z(1) z(2)]) );
    disp("Damping Coefficient Percent Difference:");
    disp( 100 * abs(diff([res.c1 res.c2])) / mean([res.c1 res.c2]) );
    
end
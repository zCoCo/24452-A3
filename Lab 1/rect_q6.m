% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it as
% required by problem Q2 in the rectilinear section.
function rect_q6()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 490.5e-3; 
    mb2 = 485.5e-3;
    mb3 = 240.5e-3;
    mb6 = 490.5e-3;
    
    % Known Mass added to Each Cart [kg]:
    m1 = mb1 + mb2 + mb6; % Known mass added to cart in experiment 1
    m2 = mb1 + mb2 + mb6 + mb3; % Known mass added to cart in experiment 2
    
    root = "RectData/exp2/car2/";
    [wn, z] = multi_logdec(root, "2.2.1", "test1", [1,2,6], "2.2.2", "test2", [1,2,6,3]); % Returns Experimental Results
    saveas(gcf, char(mfilename+".png"), 'png');
    
    
    % Reconstruct System Parameters:
    res = struct(); % Results
    res.z1 = z(1);
    res.z2 = z(2);
    res.M = (m2*wn(2)^2 - m1*wn(1)^2) / (wn(1)^2 - wn(2)^2); % Remaining Unknown mass
    res.k1 = (res.M + m1)*wn(1)^2;
    res.k2 = (res.M + m2)*wn(2)^2;
    res.c1 = 2*z(1)*wn(1)*(res.M+m1);
    res.c2 = 2*z(2)*wn(2)*(res.M+m2);
    
    % Display Results for Evaluation:
    disp("Parameters Recovered from Data (in SI Base Units):");
    disp(res);
    disp("Damping Ratio Percent Difference:");
    disp( 100 * abs(diff([z(1) z(2)])) / mean([z(1) z(2)]) );
    disp("Damping Coefficient Percent Difference:");
    disp( 100 * abs(diff([res.c1 res.c2])) / mean([res.c1 res.c2]) );
    
end
% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it as
% required by problem Q2 in the rectilinear section.
function rect_q2()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 490.5e-3; 
    mb2 = 485.5e-3;
    mb3 = 240.5e-3;
    mb6 = 490.5e-3;
    
    % Known Mass added to Each Cart [kg]:
    m1 = mb1 + mb2 + mb6; % Known mass added to cart in experiment 1
    m2 = 0; % Known mass added to cart in experiment 2
    
    root = "RectData/exp2/car1/";
    [wn, z] = multi_logdec(root, "2.1.1", "test1", [1,2,6], "2.1.3", "test3", "none"); % Returns Experimental Results
    saveas(gcf, 'rect_q2.png', 'png');
    
    % Reconstruct System Parameters to Verify Accuracy:
    % (assuming mass has already been experimentally verified).
    res = struct(); % Results
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
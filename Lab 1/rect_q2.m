% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it as
% required by problem Q2 in the rectilinear section.
function rect_q2()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    m1 = 490.5e-3; 
    m2 = 485.5e-3;
    m3 = 240.5e-3;
    m6 = 490.5e-3;
    
    root = "RectData/exp2/car1/";
    [wn, z] = multi_logdec(root, "2.1.1", "test1", [1,2,6], "2.1.3", "test3", "none"); % Returns Experimental Results
    saveas(gcf, 'rect_q2.png', 'png');
    
    % Reconstruct System Parameters to Verify Accuracy:
    % (assuming mass has already been experimentally verified).
    expres = struct(); % Experimentally Recovered Parameters
    expres.M = (m2*wn2^2 - m1*wn1^2) / (wn1^2 - wn2^2); % Remaining Unknown mass
    expres.k1 = (expres.M + m1)*wn1^2;
    expres.k2 = (expres.M + m2)*wn2^2;
    expres.c1 = 2*z1*wn1*(expres.M+m1);
    expres.c2 = 2*z2*wn2*(expres.M+m2);
    
    % Display Results for Evaluation:
    disp("Parameters Recovered from Data (in SI Base Units):");
    disp(expres);
    disp("Damping Ratio Percent Difference:");
    disp( 100 * abs(diff([z1 z2])) / mean([z1 z2]) );
    disp("Damping Coefficient Percent Difference:");
    disp( 100 * abs(diff([expres.c1 expres.c2])) / mean([expres.c1 expres.c2]) );
    
end
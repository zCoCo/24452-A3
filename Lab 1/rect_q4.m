% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it as
% required by problem Q2 in the rectilinear section.
function rect_q4()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 490.5e-3; 
    mb2 = 485.5e-3;
    mb3 = 240.5e-3;
    mb6 = 490.5e-3;
    
    Mc = 0.7682; % Empirically determined unloaded cart mass
    
    % Known Total Mass of Each Cart and its Load[kg]:
    m4 = Mc; % Known mass added to cart in experiment 1
    m5 = Mc + mb1 + mb2 + mb6 + mb3; % Known mass added to cart in experiment 2
    
    root = "RectData/exp2/car1/";
    [wn, z] = multi_logdec(root, "2.1.4", "test4", "none", "2.1.5", "test5", [1,2,6,3]); % Returns Experimental Results
    saveas(gcf, char(mfilename+".png"), 'png');
    
    % Reconstruct System Parameters to Verify Accuracy:
    % (assuming mass has already been experimentally verified).
    res = struct(); % Results
    res.kmed = m4 * wn(1)^2;
    res.klow = m5 * wn(2)^2;
    res.z4 = z(1);
    res.z5 = z(2);
    res.c4 = 2*z(1)*wn(1)*m4;
    res.c5 = 2*z(2)*wn(2)*m5;
    
    % Display Results for Evaluation:
    disp("Parameters Recovered from Data (in SI Base Units):");
    disp(res);
    
end
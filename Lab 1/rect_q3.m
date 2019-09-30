% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it as
% required by problem Q2 in the rectilinear section.
function rect_q3()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 490.5e-3; 
    mb2 = 485.5e-3;
    mb6 = 490.5e-3;
    
    Mc = 0.7682; % Empirically determined unloaded cart mass
    
    % Known Base Mass of Each Cart [kg]:
    M = Mc + mb1 + mb2 + mb6;
    
    root = "RectData/exp2/car1/";
    [wn, ~] = multi_logdec(root, "2.1.1", "test1", [1,2,6], "2.1.2", "test2", [1,2,6,3]); % Returns Experimental Results
    saveas(gcf, char(mfilename+".png"), 'png');
    
    % Reconstruct System Parameters:
    res = struct(); % Results
    res.m3 = (M*wn(1)^2 - M*wn(2)^2) / wn(2)^2; % Remaining Unknown mass
    
    % Display Results for Evaluation:
    disp("Mass Estimate for Small Block:");
    disp(res);
end
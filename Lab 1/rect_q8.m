% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it as
% required by problem Q2 in the rectilinear section.
function rect_q8()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 490.5e-3; 
    mb2 = 485.5e-3;
    mb3 = 240.5e-3;
    mb6 = 490.5e-3;
    
    Mc = 0.5527; % Empirically determined unloaded cart mass
    c0 = mean([0.9747,1.1031]); % Empirically determined base system damping
    
    % Known Base Mass of Each Cart [kg]:
    M = Mc + mb1 + mb2;
    
    root = "RectData/exp2/car3/";
    [wn, z] = multi_logdec(root, "3", "test3", [1,2]); % Returns Experimental Results
    saveas(gcf, char(mfilename+".png"), 'png');
    
    
    % Reconstruct System Parameters:
    res = struct(); % Results
    res.z = z;
    res.wn = wn;
    res.c = 2 * z * wn * M;
    res.Dc = res.c - c0;
    
    % Display Results for Evaluation:
    disp("Parameters Recovered from Data (in SI Base Units):");
    disp(res);
    
end
% Recover all system properties possible from two subsequent trials of a
% cart in free vibration with different known masses attached to it as
% required by problem Q3 in the rotational section.
% Jdisk is known from Q2

function rot_q3()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
  
    mb1 = 501.5e-3; 
    mb2 = 501e-3;
    mb3 = 501.25e-3;
    
    
    %Mc = 0.7682; % Empirically determined unloaded cart mass
    
    % Known Base Mass of Each Cart [kg]:
    Jdisk = 0.0031;
    J = Jdisk + (mb1 + mb2 + mb3) * (9e-2)^2;
    
    root = "RotData/exp2_disk1/";
    [wn, ~] = multi_logdec(root, "2", "test2", [1,2,3], "3", "test3", [1,2,3,4]); % Returns Experimental Results
    saveas(gcf, char(mfilename+".png"), 'png');
    
    % Reconstruct System Parameters:
    res = struct(); % Results
    res.J4 = (J*wn(1)^2 - J*wn(2)^2) / wn(2)^2; % Remaining Unknown moment of inertia
    res.m4 = res.J4 / ((9e-2)^2); % Remaining Unknown mass
    
    % Display Results for Evaluation:
    disp("Mass Estimate for Small Block:");
    disp(res);
end
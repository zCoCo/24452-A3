function rect_q1()
    %% PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 490.5e-3;
    mb2 = 485.5e-3;
    mb3 = 490.5e-3;
    mb4 = 490.5e-3;
    
    m4 = mb1 + mb2 + mb3 + mb4;
    m3 = mb1 + mb2 + mb3;
    m2 = mb1 + mb2;
    m1 = mb1;
    
    % CONFIGURATION OF EACH SYSTEM BEING ID'd:
    % "Mass" (/Interias) Added to the Carrier (Cart/Disk) in Each Test:
    sys1.dm(1) = 0; % Added to test1 of system 1
    sys1.dm(2) = m4; % Added to test2 of system 1
    sys1.dm(3) = m4; % Added to test3 of system 1
    sys2.dm(1) = 0; % Added to test1 of system 1
    sys2.dm(2) = m4; % Added to test2 of system 1
    
    %% PERFORM SYSID:
    [sys1.wn, sys1.z] = multi_logdec("m", "RectData", ...
        1, "Exp1_1", sys1.dm(1)+"$\,kg$", ...
        2, "Exp1_2", sys1.dm(2)+"$\,kg$", ...
        3, "Exp1_3", sys1.dm(3)+"$\,kg$" ...
    );
    saveas(gcf, mfilename+"_test123.png", 'png');
    sys1 = sysid_dm(sys1);
    sys1.kl = sys1.k; % Spring of tests 1 and 2 is light spring.
    sys1 = rmfield(sys1, 'k'); % Remove ambiguous spring term
    sys1.km1 = sys1.wn(3)^2 * (sys1.Mc + sys1.dm(3));
    
    disp("SYSTEM 1:");
    disp(sys1);
    
    
    [sys2.wn, sys2.z] = multi_logdec("m", "RectData", ...
        3, "Exp1_4", sys2.dm(1)+"$\,kg$", ...
        4, "Exp1_5", sys2.dm(2)+"$\,kg$", ...
        'x2' ...
    );
    saveas(gcf, mfilename+"_test45.png", 'png');
    sys2 = sysid_dm(sys2);
    sys2.km2 = sys2.k; % Spring of tests 1 and 2 is 2nd medium spring.
    sys2 = rmfield(sys2, 'k'); % Remove ambiguous spring term
    
    disp("SYSTEM 2:");
    disp(sys2);
end

% Performs System ID with Known Mass Change for a 1DOF Second Order System 
% by Comparing Logarithmic Decrement Results on Two Tests on the System, 
% Each with Different Known Additional "Masses" (or inertias).
% Given a struct, sys, with fields:
%   - sys.dm: a two component vector where dm(i) is the amount of mass 
%   (or inertia) added to the system for test i.
%   - sys.wn: a two component vector where wn(i) is the natural frequency
%   determined by logdec for test i.
%   - sys.z: a two component vector where z(i) is the damping ratio
%   determined by logdec for test i.
function sys = sysid_dm(sys)
    % Carrier (cart/disk) Mass:
    sys.Mc = (sys.dm(1)*sys.wn(1)^2 - sys.dm(2)*sys.wn(2)^2)/(sys.wn(2)^2 - sys.wn(1)^2);
    % Spring Rate:
    sys.k = sys.wn(1)^2 * (sys.Mc + sys.dm(1));
    % Inherent Damping Coefficient:
    sys.c = 2 * sys.z(1) * sys.wn(1) * (sys.Mc + sys.dm(1)); % future improvement: take mean across both trials? - or only use the one where envelope(zeta) has best fit to data?
end
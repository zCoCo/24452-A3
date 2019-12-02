function rot_q1()
    %% PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 501.5e-3;
    mb2 = 501e-3;
    mb3 = 501.25e-3;
    mb4 = 502.25e-3;
    
    m4 = mb1 + mb2 + mb3 + mb4;
    m3 = mb1 + mb2 + mb3;
    m2 = mb1 + mb2;
    m1 = mb1;
    % Interias Contributed by Each Combination of Blocks:
    J(1) = m1*(9e-2)^2;
    J(2) = m2*(9e-2)^2;
    J(3) = m3*(9e-2)^2;
    J(4) = m4*(9e-2)^2;
    
    % CONFIGURATION OF EACH SYSTEM BEING ID'd:
    % "Mass" (/Interias) Added to the Carrier (Cart/Disk) in Each Test:
    sys1.dm(1) = J(4); % Added to test1 of system 1
    sys1.dm(2) = 0; % Added to test2 of system 1
    sys2.dm(1) = 0; % Added to test1 of system 1
    sys2.dm(2) = J(4); % Added to test2 of system 1
    
    %% PERFORM SYSID:
    [sys1.wn, sys1.z] = multi_logdec("rad", "RotData/Exp1/", ...
        1, "Exp1_test1", sys1.dm(1)+"$\,kg\,m^2$", ...
        2, "Exp1_test2", sys1.dm(2)+"$\,kg\,m^2$" ...
    );
    saveas(gcf, mfilename+"_test12.png", 'png');
    sys1 = sysid_dm(sys1);
    disp("SYSTEM 1:");
    disp(sys1);
    
    [sys2.wn, sys2.z] = multi_logdec("rad", "RotData/Exp1/", ...
        3, "Exp1_test3", sys2.dm(1)+"$\,kg\,m^2$", ...
        4, "Exp1_test4", sys2.dm(2)+"$\,kg\,m^2$" ...
    );
    saveas(gcf, mfilename+"_test34.png", 'png');
    sys2 = sysid_dm(sys2);
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
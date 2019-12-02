% Plot FRF for all tests in Exp 3 where k was varied while c and m were
% constant.
function rot_q10()
    %% PRIOR KNOWNS:
    xunits = "rad";
    
    Jdisk = 0.0031; % [kgm^2] Mean of Disk Inertia Determined in Lab 1
    k1 = mean([3.69 2.81]); % [Nm/rad] Mean First Spring Stiffness Determined in Lab 1
    c1 = mean([0.0619 0.0477]); % [Nms/rad] Inherent bearing damping determined for Disk 1 in Lab 1
    
    % Masses of Blocks [kg]:
    mb1 = 501.5e-3;
    mb2 = 501e-3;
    mb3 = 501.25e-3;
    mb4 = 502.25e-3;
    
    m4 = mb1 + mb2 + mb3 + mb4;
    m3 = mb1 + mb2 + mb3;
    m2 = mb1 + mb2;
    m1 = mb1;
    J1 = m1*(9e-2)^2;
    J2 = m2*(9e-2)^2;
    J3 = m3*(9e-2)^2;
    J4 = m4*(9e-2)^2;
    
    % Known Inertias
    M0 = Jdisk;
    M1 = Jdisk + J1;
    M2 = Jdisk + J2;
    M3 = Jdisk + J3;
    M4 = Jdisk + J4;
    
    ms = [M0 M0 M0 M0 M0 M0 M0 M2 M4]; % System Mass
    cs = [0.15 0.25 0.5 1 1.5 0.1 0.1 0.1 0.1] + c1; % Added Software Damping
    % Experiment IDs of Each Test where c and m are held constant:
    exps = [6 7];
    ks = [0.75 0];
    
    %% SETUP:
    fmin = 1; % [Hz] Min Frequency
    fmax = 10; % [Hz] Max Frequency
    rows = fmin*40+1:fmax*40+1; % selects the same rows that readfreq does
    
    %% LOAD, FORMAT, AND PLOT DATA:
    figure();
    leg = {}; % Cell Array of Legend Entries
    Ts = {}; % Cell Array of ETables for Each Data Collection
    for i = 1:numel(exps)
        test = exps(i);
        Ts{i} = load_freq(fullfile("RotData","Exp3","test"+test+".txt"), xunits);
        Ts{i}.plot('f', 'FRF_A1', rows, '-');
        leg{i} = "Test "+test+", Added Stiffness: "+ks(i)+"$\,^{Nm}/_{rad}$";
    end
    ylabel('Amplitude [$^{rad}/_{Nm}$]', 'Interpreter','latex');
    legend(leg, 'Location','northeast', 'Interpreter','latex');
    saveas(gcf, mfilename+".png",'png');
end
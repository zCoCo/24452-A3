% Curve Fit Each FRF to Find System Parameters and then Compare Fitted
% Function to Raw Data.
function rot_q7()
    %% PRIOR KNOWNS:
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
    ks = [1.5 1.5 1.5 1.5 1.5 0.75 0 0 0] + k1;
    cs = [0.15 0.25 0.5 1 1.5 0.1 0.1 0.1 0.1] + c1; % Added Software Damping
    
    output_data = [];
    
    %% LOAD, FORMAT, AND PLOT DATA:
    figure();
    for test = 1:9
        exp_params = fit_frf(test);
        
        % Compute Expected Values:
        m = ms(test);
        k = ks(test);
        c = cs(test);
        wn = sqrt(k/m); % natural freq
        z = c/m/2/wn; % damping ratio
        
        % Measured Values from Curve-Fitting:
        me = exp_params.m;
        ke = exp_params.k;
        ce = exp_params.c;
        wne = exp_params.wn;
        ze = exp_params.z;
        
        output_data(end+1,:) = [m,me,perr(me,m), k,ke,perr(ke,k), c,ce,perr(ce,c), wn,wne,perr(wne,wn), z,ze,perr(ze,z)];
    end
    % Output Tabulated Parameters:
    output_data = array2table(output_data);
    output_data.Properties.VariableNames = {'m_theory','m_exp','m_PercentError','k_theory','k_exp','k_PercentError','c_theory','c_exp','c_PercentError','wn_theory','wn_exp','wn_PercentError','z_theory','z_exp','z_PercentError'};
    writetable(output_data, mfilename+"_params.xlsx");
end

% Slightly modified version of code from canvas
function exp_params = fit_frf(test)
    % Setup:
    xunits = "rad";
    fmin = 1; % [Hz] Min Frequency
    fmax = 10; % [Hz] Max Frequency
    rows = fmin*40+1:fmax*40+1; % selects the same rows that readfreq does
    % Grab Data:
    data = load_freq(fullfile("RotData","Exp3","test"+test+".txt"), xunits);
    freq = data.f(rows);
    amp = data.FRF_A1(rows);
    pha = data.FRF_P1(rows);
    
    % Get Plot FRF Amplitude against index:
    figure(1);
    plot(amp, 'r');
    % Select region to fit FRF
    xx = ginput(2);
    % Round input values to nearest integer
    indx = ceil(xx(1,1)):floor(xx(2,1)); 

    % Creating the complex FRF (transfer function)
    Gs = amp(indx).*exp(1i*pha(indx));

    % Express the FRF in rational fraction polynomial form
    [num,den] = invfreqs(Gs,freq(indx)*2*pi,0,2);

    % create regenerated FRF function
    hh=freqs(num,den,freq*2*pi);
    
    % Finding mag. and phase
    mag=abs(hh);
    ang=angle(hh);
    
    % Plot and compare:
    figure(2);
    subplot(2,1,1);
    plot(freq,amp,'r');
    hold on
        plot(freq,mag);
    hold off
    xlabel('Frequency [Hz]', 'Interpreter','latex');
    ylabel('Amplitude [$^{rad}/_{Nm}$]', 'Interpreter','latex');

    subplot(2,1,2);
    plot(freq,pha,'r');
    hold on
        plot(freq,ang);
    hold off
    xlabel('Frequency [Hz]', 'Interpreter','latex');
    ylabel('Phase [rad]', 'Interpreter','latex');
    hold off
    legend({'Experimental','Curve Fit'}, 'Interpreter','latex');
    
    % Tabulate Obtained Dynamic Parameters:
    exp_params.m = 1/num(1);
    exp_params.wn = sqrt(den(3));
    exp_params.z = den(2)/2/exp_params.wn;
    exp_params.k = den(3) * exp_params.m;
    exp_params.c = den(2) * exp_params.m;
    
    % Save Results:
    saveas(gcf, mfilename+"_test"+test+".png",'png');
end

% Percent Error between observed value and calculated value:
function pd = perr(o,c)
    pd = 100 * abs(o-c) / c;
end
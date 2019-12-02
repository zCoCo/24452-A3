% Curve Fit Each FRF to Find System Parameters and then Compare Fitted
% Function to Raw Data.
function rect_q7()
    %% PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    mb1 = 490.5e-3;
    mb2 = 485.5e-3;
    mb3 = 240.5e-3;
    mb6 = 490.5e-3;
    Mc = mean([0.768, 0.672, 0.553]); % Mean of Cart Masses Determined in Lab 1
    k_heavy = mean([714, 760]); % Mean Heavy Spring Stiffness Determined in Lab 1
    c_bearing = mean([1.92, 1.10, 1.92]); % Inherent bearing damping determined for Cart 1 in Lab 1
    
    ms = [0 0 0 0 0 0 0 (mb1+mb2) (mb1+mb2+mb3+mb6)] + Mc; % System Mass
    ks = [200 200 200 200 200 100 0 0 0] + k_heavy;
    cs = [1 2 8 15 35 2 2 2 2] + c_bearing; % Added Software Damping
    
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
    xunits = "mm";
    fmin = 1; % [Hz] Min Frequency
    fmax = 10; % [Hz] Max Frequency
    rows = fmin*40+1:fmax*40+1; % selects the same rows that readfreq does
    % Grab Data:
    data = load_freq(fullfile("RectData","Exp3","frf_"+test+".txt"), xunits);
    freq = data.f(rows);
    amp = data.FRF_A1(rows)/1e3; % [mm/N] -> [m/N]
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
    plot(freq,amp*1e3,'r'); % [mm/N] -> [m/N]
    hold on
        plot(freq,mag*1e3); % [mm/N] -> [m/N]
    hold off
    xlabel('Frequency [Hz]', 'Interpreter','latex');
    ylabel('Amplitude [$^{mm}/_{N}$]', 'Interpreter','latex');

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
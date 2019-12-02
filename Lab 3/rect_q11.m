function rect_q11()
    % Parameters for test 7 of experiment 3:
    m = 0.783; % [kg]
    k = 806; % [N/m]
    c = 4.10; % [Ns/m]
    
    FRF = sine_sweep_sim(m,k,c, 1.2, 1,10, 19);
    
    % Fetch Real Experiment Data:
    xunits = "mm";
    fmin = 1; % [Hz] Min Frequency
    fmax = 10; % [Hz] Max Frequency
    rows = fmin*40+1:fmax*40+1; % selects the same rows that readfreq does
    data = load_freq(fullfile("RectData","Exp3","frf_7.txt"), xunits);
    
    figure();
    subplot(211);
        hold on
            plot(FRF.freq, 1e3*FRF.amp); % [m/N] -> [mm/N]
            plot(data.f(rows), data.FRF_A1(rows));
        hold off
        xlabel('Frequency [Hz]', 'Interpreter','latex');
        ylabel('Amplitude [$^{mm}/_{N}$]', 'Interpreter','latex');
    subplot(212);
        hold on
            plot(FRF.freq, FRF.phase);
            plot(data.f(rows), data.FRF_P1(rows));
        hold off
        xlabel('Frequency [Hz]', 'Interpreter','latex');
        ylabel('Phase [rad]', 'Interpreter','latex');
        legend({'Simulated FRF', 'Test 7 of Experiment 3'}, 'Interpreter','latex');
    saveas(gcf, mfilename+"_sim.png", 'png');
end
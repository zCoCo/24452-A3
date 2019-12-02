function rot_q11()
    % Parameters for test 7 of experiment 3:
    m = 0.01796; % [kgm2]
    k = 2.39; % [Nm/rad]
    c = 0.090; % [Nms/rad]
    
    FRF = sine_sweep_sim(m,k,c, 0.65, 1,10, 19);
    
    % Fetch Real Experiment Data:
    xunits = "rad";
    fmin = 1; % [Hz] Min Frequency
    fmax = 10; % [Hz] Max Frequency
    rows = fmin*40+1:fmax*40+1; % selects the same rows that readfreq does
    data = load_freq(fullfile("RotData","Exp3","test9.txt"), xunits);
    
    figure();
    subplot(211);
        hold on
            plot(FRF.freq, FRF.amp);
            plot(data.f(rows), data.FRF_A1(rows));
        hold off
        xlabel('Frequency [Hz]', 'Interpreter','latex');
        ylabel('Amplitude [$^{rad}/_{Nm}$]', 'Interpreter','latex');
    subplot(212);
        hold on
            plot(FRF.freq, FRF.phase);
            plot(data.f(rows), data.FRF_P1(rows));
        hold off
        xlabel('Frequency [Hz]', 'Interpreter','latex');
        ylabel('Phase [rad]', 'Interpreter','latex');
        legend({'Simulated FRF', 'Test 9 of Experiment 3'}, 'Interpreter','latex');
    saveas(gcf, mfilename+"_sim.png", 'png');
end
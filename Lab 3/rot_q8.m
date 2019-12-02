% Plot FRF for all tests in Exp 3 where c was varied while m and k were
% constant.
function rot_q8()
    %% PRIOR KNOWNS:
    xunits = "rad";
    
    % Experiment IDs of Each Test where m and k are held constant:
    exps = [1 2 3 4 5];
    Dc = [0.15 0.25 0.5 1.0 1.5]; % Added Software Damping
    
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
        leg{i} = "Test "+test+", Added Damping: "+Dc(i)+"$\,^{Nms}/_{rad}$";
    end
    ylabel('Amplitude [$^{rad}/_{Nm}$]', 'Interpreter','latex');
    legend(leg, 'Location','northeast', 'Interpreter','latex');
    saveas(gcf, mfilename+".png",'png');
end
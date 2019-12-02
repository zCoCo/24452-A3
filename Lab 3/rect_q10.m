% Plot FRF for all tests in Exp 3 where k was varied while c and m were
% constant.
function rect_q10()
    %% PRIOR KNOWNS:
    xunits = "mm";
    
    % Experiment IDs of Each Test where c and m are held constant:
    exps = [2 6 7];
    k_heavy = mean([714, 760]); % Mean Heavy Spring Stiffness Determined in Lab 1
    ks = [200 100 0];
    
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
        Ts{i} = load_freq(fullfile("RectData","Exp3","frf_"+test+".txt"), xunits);
        Ts{i}.plot('f', 'FRF_A1', rows, '-');
        leg{i} = "Test "+test+", Added Stiffness: "+ks(i)+"$\,^{N}/_{m}$";
    end
    ylabel('Amplitude [$^{mm}/_{N}$]', 'Interpreter','latex');
    legend(leg, 'Location','northwest', 'Interpreter','latex');
    saveas(gcf, mfilename+".png",'png');
end
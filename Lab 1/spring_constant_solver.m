function spring_constant_solver(root, test)
    addpath('..')
    %% LOAD AND FORMAT DATA
    try
        load(char(root+test+".mat"),'T');
        Ts = T;
    catch
        T = ETable(char(root+test+".xlsx"), ["t","F", "x1","x2","x3", "E", "v1","v2","v3", "a1","a2","a3", "note"]); % Long-form names used in plotting are automatically imported from column headers
        save(char(root+test+".mat"), 'T');
        Ts = T; 
        load(char(root+test+".mat"))
    end
    %RectData/exp1/test1
    
    Ts.unitsList = ["s","N", "m","m","m", "", "$\tfrac{m}{s}$","$\tfrac{m}{s}$","$\tfrac{m}{s}$", "$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$", ""];

    % Rename Poorly Named Columns:
    Ts.rename('t', 'Time [s]');
    Ts.rename('F', 'Force [N]');
    % Update to SI Base Units:
    Ts.edit('x1', Ts.x1 * 1e-3);
    Ts.rename('x1', 'Displacement 1 [m]');
%     
%     [~,maxIdx] = max(Ts.x1);
%     
%     t_star = Ts.t(maxIdx(1)
    
    %% ANALYSE DATA
    
    k = Ts.spring('F','x1');

    %% PLOT DATA
    figure();
    Ts.plot('x1','F', true(size(Ts.x1)),'x')
    hold on;
    y = polyval(k,Ts.x1);
    plot(Ts.x1,y);
    disp(k);
    
    
    
end

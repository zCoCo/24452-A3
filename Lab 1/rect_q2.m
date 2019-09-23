% Recover Cart Mass:
function rect_q2()
    addpath('..');
    % Load Every Column, Giving them Each a Variable Name:
    T = ETable('RectData/exp2/car1/test1.xlsx', ["t","F", "x1","x2","x3", "E", "v1","v2","v3", "a1","a2","a3", "note"]); % Long-form names used in plotting are automatically imported from column headers
    save('RectData/exp2/car1/test1.mat', 'T'); % Cached loaded file
    %load('./RectData/exp2/car1/test1.mat', 'T'); % Load cached file
    % Assign (latex formatted) Units to Each Column:
    
    T1.unitsList = ["s","N", "m","m","m", "", "$\tfrac{m}{s}$","$\tfrac{m}{s}$","$\tfrac{m}{s}$", "$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$", ""];
    T2.unitsList = T1.unitsList;
  
    % Rename Poorly Named Columns:
    T.rename('t', 'Time [s]');
    T.rename('F', 'Force [N]');

end
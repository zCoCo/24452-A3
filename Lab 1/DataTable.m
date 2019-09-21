% Creates an ETable from the Raw Data File
function T = DataTable()
    addpath('..');
    % Load Every Column, Giving them Each a Variable Name:
    %T = ETable('test1.xlsx', ["t","F","x1", "x2","v1", "v2","a1", "a2"]); % Long-form names used in plotting are automatically imported from column headers
    %save('test1.mat', 'T'); % Cached loaded file
    load('test1.mat', 'T'); % Load cached file
    % Assign (latex formatted) Units to Each Column:
    T.unitsList = ["s","N", "m","m", "$\tfrac{m}{s}$","$\tfrac{m}{s}$", "$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$"];
    
    % Rename Poorly Named Columns:
    T.rename('t', 'Time [s]');
    T.rename('F', 'Force [N]');
end
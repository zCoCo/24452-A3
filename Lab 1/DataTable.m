% Creates an ETable from the Raw Data File
function T = DataTable()
    % Load Every Column, Giving them Each a Variable Name:
    T = ETable('test1.xlsx', ["t","F","x1", "x2","v1", "v2","a1", "a2"]); % Long-form names used in plotting are automatically imported from column headers
    % Assign (latex formatted) Units to Each Column:
    T.unitsList = ["s","N", "m","m", "$\tfrac{m}{s}$","$\tfrac{m}{s}$", "$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$"];
    
    % Rename Poorly Named Columns:
    T.rename('t', 'Time [s]');
    T.rename('F', 'Force [N]');
    
    % Basic Exploratory Plots:
    figure();
    hold on
        T.plot('t', 'F');
        T.plot('t' 
end
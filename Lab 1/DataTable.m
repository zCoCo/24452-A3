% Creates an ETable from the Raw Data File
function T = DataTable()
    % Load Every Column, Giving them Each a Variable Name:
    T = ETable('test1.xlsx', ["X","traj","D1", "D2","v1", "v2","a1", "a2"]);
    % Assign (latex formatted) Units to Each Column:
    T.unitsList = ["m","m","m","m", "$\tfrac{m}{s}$","$\tfrac{m}{s}$", "$\tfrac{m}{s^2}$","$\tfrac{m}{s^2}$"];
end
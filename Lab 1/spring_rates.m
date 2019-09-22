function spring_rates()
    T = DataTable();
    
    % Basic Exploratory Plots:
    figure();
    T.multiplot('t', 'F', 'x1','x2'); % Plot F, x1, and x2 vs t
    
    figure();
    subplot 
    T.plot('x1','F');
end
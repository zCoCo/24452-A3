% Recover Cart Mass:
function rect_q3()
    % PRIOR KNOWNS:
    % Masses of Blocks [kg]:
    m1 = 490.5e-3; 
    m2 = 485.5e-3;
    m3 = 240.5e-3;
    m6 = 490.5e-3;
    M = 0.7682; % Empirically Determined Cart Mass
    
    root = "RectData/exp2/car1/";
    % NOT GOING TO WORK THIS WAY:
    exp = cart_logdec_solver(root, "2.1.1", "test1", [m1,m2,m6], "2.1.1", "test2", [m1,m2,m6,m3])
    saveas(gcf, 'rect_q3.png', 'png');
end
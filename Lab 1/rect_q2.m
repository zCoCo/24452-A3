% Recover Cart Mass:
function rect_q2()
    root = "RectData/exp2/car1/";
    cart_logdec_solver(root, "2.1.1", "test1", [1,2,6], "2.1.2", "test2", [1,2,6,3])
    saveas(gcf, 'rect_q2.png', 'png');
end
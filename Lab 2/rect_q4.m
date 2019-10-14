function rect_q4()
    T1 = ETable.CachedLoad('RectData/exp2/3.1/test1.txt', ETOptions("m"));
    
    T1.multiplot('-','t', 'x1','x2','x3');
    
end
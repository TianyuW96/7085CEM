function fitness = simpleton(ucode)
    fitness = zeros(size(ucode,1),1); % 适应度值初始化
    for p=1:size(ucode,1)
        x1 = ucode{p,1}(1);
        x2 = ucode{p,1}(2);
        x3 = ucode{p,1}(3);
        x4 = ucode{p,1}(4);
        x5 = ucode{p,1}(5);
        x6 = ucode{p,1}(6);
        x7 = ucode{p,1}(7);
        x8 = ucode{p,1}(8);
        x9 = ucode{p,1}(9);
        x10 = ucode{p,1}(10);
        fitness(p)=x1*x2*x3*x4*x5/(x6*x7*x8*x9*x10);
    end
end   
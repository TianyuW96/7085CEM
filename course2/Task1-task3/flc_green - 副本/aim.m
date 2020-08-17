function [fitness,T,y] = aim(ucode)
flc=readfis('flcbest.fis');                                       % 加载模糊控制器到工作空间
fitness = zeros(size(ucode,1),1);
for p=1:size(ucode,1)
    for i=1:1:7
        for j=1:1:7
            myrow = (i-1)*7+j;
            flc.rule(1,myrow).antecedent = [i,j];                 %选择第i行，第j列规则
            flc.rule(1,myrow).consequent = ucode{p,1}(i,j);       %赋值
            flc.rule(1,myrow).weight = 1;
            flc.rule(1,myrow).connection=1;
        end
    end
    close_system('FLC');                                          % 关闭正在运行的simulink模型
    options=simset('SrcWorkspace','current');                     % 设置simulink使用当前工作空间
    [T,~,y] = sim('FLC.slx',10,options);                           %调用simulink模型FLC.slx
    [k,~]=size(y);
    itae = T(1,1)*abs(1-y(i))*(T(2,1)-T(1,1)); 
    for i = 2:k
        e = 1-y(i); 
        jian_ge = T(i,1)-T(i-1,1);
        itae = T(i,1)*abs(e)*jian_ge+itae;
    end
    fitness(p) = 1/(1+itae);
end
end
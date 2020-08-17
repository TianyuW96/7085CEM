function fitness_best = myga2(num,ger)   
% 函数功能：实现遗传算法，优化模糊控制
% 输入：
%   num:种群数量
%   ger:进化代数
% 输出：
%   fitness_best:每代最优适应度值
    n = 7;                               % 基因个数
    gnum = 21;                           % 基因长度
    L = n*gnum;                          % 染色体长度
    pc = 0.2;                            % 交叉概率
    code = cell(num,1);                  % 存放个体染色体
    fitness_best = zeros(ger, 1);        % 存放每一代的最优适应度
    % 染色体编码初始化
    code{1,1}=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 1;
               1 1 1 1 1 1 1 1 0 1 0 1 1 0 0 0 1 1 0 1 0;
               1 1 1 1 1 0 1 0 1 1 0 0 0 1 1 0 1 0 0 0 1;
               1 1 0 1 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 0 1;
               1 1 0 1 0 1 1 0 0 0 1 1 0 1 0 0 0 1 0 0 0;
               1 0 1 1 0 0 0 1 1 0 1 0 0 0 1 0 0 0 0 0 0;
               0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;];
    for co=2:1:num
        code{co,1} = round(rand(n,gnum));
    end
    % 种群染色体解码
    decode = mycoder(n,code); 
    [fitness,~,~] = aim(decode); %计算适应度
    %初始化最优染色体，保存最优染色体及其适应度
    gene_best = Findbest(code,fitness);
    fitness_best(1) = gene_best{1,2};      %将当前最优存入矩阵当中
    % 初始化新染色体
    x1{1,1} = zeros(7,21);
    x2{1,1} = zeros(7,21);
    x3 = code;    
    for epoch = 1: ger                                                                          % 开始迭代进化
        pm = 0.7-epoch*(0.7/ger);                                                                % 变异概率随迭代次数增加而减小
       
        kk = 1;
        for i = 1: num 
            if rand < pc
               d = randi(num);                                                                    % 确定另一个交叉的个体d
               m = code{d,1};            
               dr = randi(n);                                                                    % 确定交叉断点
               dc = randi(gnum);
               x1{kk,1} = [[code{i,1}(1:dr,1:dc), m(1:dr,dc+1:gnum)];m(dr+1:n,:)];               % 新个体 1
               x2{kk,1} = [[m(1:dr,1:dc), code{i,1}(1:dr,dc+1:gnum)];code{i,1}(dr+1:n,:)];         % 新个体 2
               kk = kk+1;
            end
        end
        for i = 1: num                                                                           % 变异操作
            if rand < pm
                x3{i,1}(randi(L)) = randi([0, 1]);
            end
        end
        code = [code;x1;x2;x3];                           % 合并新旧染色体
        code = cell_isequal(code);                        % 删除重复个体，防止陷于局部最优
        decode = mycoder(n,code);                         % 种群解码
        [fitness,~,~] = aim(decode);                      %计算适应度
        code(:,2)=num2cell(fitness);
        code = flipud(sortrows(code, 2));
        while size(code, 1) > num                         % 自然选择
            d = randi(size(code, 1));                     % 排名法
            if rand < (d - 1) / size(code, 1)
                code(d,:) = [];
                fitness(d,:) = [];
            end
        end
        code = code(:,1);
        gene_best_temp = Findbest(code,fitness);
        if gene_best_temp{1,2}>gene_best{1,2}
            gene_best = gene_best_temp;
        end
        fitness_best(epoch)=gene_best{1,2};
        disp(epoch);
        disp(gene_best{1,2});
    end
    decode = mycoder(n,gene_best);
    [~,T,y] = aim(decode);
    t = (-1:0.01:10)';
    unitstep2 = t>=0;
    % 绘制阶跃信号输入和系统响应
    figure(2)
    plot(T, y, 'r',t,unitstep2,'b');
    grid on
end
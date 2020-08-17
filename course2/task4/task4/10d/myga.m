function fitness_best = myga(num,ger,xmin,xmax)   
% 函数功能：实现遗传算法，优化模糊控制
% 输入：
%   num:种群数量
%   ger:进化代数
%   xmin:参数下限
%   xmax:参数上限
% 输出：
%   fitness_best:每代最优适应度值
% 模糊控制器中都使用等比等分隶属度函数，所以三个值设置隶属度的宽度
    n = size(xmin,2);                              % 染色体长度
    pc = 0.2;                            % 交叉概率
    code = cell(num,1);                  % 存放个体染色体
    fitness_best = zeros(ger, 1);        % 存放每一代的最优适应度
    % 种群染色体编码初始化，使用实数编码
    for i = 1:num
        x = zeros(1,n);
        for j = 1:n
            x(j) = xmin(j) + (xmax(j) - xmin(j)) * rand;%初始种群的位置
        end
    code{i,1} = x;
    end
    codec = cell2mat(code(:,1));
    for i = 1:n
        codei = codec(:,i);
        codei(codei > xmax(i)-0.5) = xmax(i);
        codei(codei < xmin(i)+0.5) = xmin(i);
        codec(:,i) = codei;
    end
    for i = 1:num
        code{i,1} = codec(i,:);
    end
    fitness = simpleton(code); %计算适应度
    %初始化最优个体，保存最优个体染色体及其适应度
    gene_best = Findbest(code,fitness);
    fitness_best(1) = gene_best{1,2}; %将当前最优存入矩阵当中
    % 初始化新个体
    x1{1,1} = zeros(1,n);
    x2{1,1} = zeros(1,n);
    x3 = code;
    for epoch = 1: ger               % 开始迭代进化
        pm = 0.7-epoch*(0.7/ger);    % 变异概率随迭代次数增加而减小
        % 交叉操作
        kk = 1;%计数
        for i = 1: num 
            if rand < pc
               d = randi(num);         % 确定另一个交叉的个体d
               m = code{d,1};            
               dr = randi(n);          % 确定交叉断点
               x1{kk,1} = [code{i,1}(1:dr),m(dr+1:n)];  % 新个体 1
               x2{kk,1} = [m(1:dr),code{i,1}(dr+1:n)];  % 新个体 2
               kk = kk+1;
            end
        end
        for i = 1: num                           % 变异操作
            if rand < pm
                pmn = randi(n);
                x3{i,1}(pmn) = randi([xmin(pmn),xmax(pmn)]);%xmin(pmn)+(xmax(pmn)-xmin(pmn))*rand;
            end
        end
        code = [code;x1;x2;x3]; % 合并新旧染色体
        code = cell_isequal(code); % 删除重复个体，防止陷于局部最优
        codec = cell2mat(code(:,1));
        for i = 1:n
            codei = codec(:,i);
            codei(codei > xmax(i)-0.5) = xmax(i);
            codei(codei < xmin(i)+0.5) = xmin(i);
            codec(:,i) = codei;
        end
        for i = 1:num
            code{i,1} = codec(i,:);
        end
        fitness = simpleton(code); %计算适应度
        code(:,2)=num2cell(fitness);
        code = flipud(sortrows(code, 2));
        while size(code, 1) > num               % 自然选择
            d = randi(size(code, 1));           % 排名法
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
    end
    %fprintf('遗传算法最大值： %f，最优染色体：%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',[gene_best{1,2},gene_best{1,1}]);
end
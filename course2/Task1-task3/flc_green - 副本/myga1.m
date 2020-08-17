function fitness_best = myga1(num,ger,xmin,xmax)   
% 函数功能：实现遗传算法，优化模糊控制
% 输入：
%   num:种群数量
%   ger:进化代数
%   xmin:参数下限

%   xmax:参数上限
% 输出：
%   fitness_best:每代最优适应度值
% 模糊控制器中都使用等比等分隶属度函数，所以三个值设置隶属度的宽度
    n = 3;                              % 染色体长度
    pc = 0.2;                            % 交叉概率
    code = cell(num,1);                  % 存放个体染色体
    fitness_best = zeros(ger, 1);        % 存放每一代的最优适应度
    % 种群染色体编码初始化，使用实数编码
    for co=1:1:num
        code{co,1} = [xmin(1)+(xmax(1)-xmin(1))*rand xmin(2)+(xmax(2)-xmin(2))*rand xmin(3)+(xmax(3)-xmin(3))*rand];
    end
    [fitness,~,~,~] = setflc(code); %计算适应度
    %初始化最优个体，保存最优个体染色体及其适应度
    gene_best = Findbest(code,fitness);
    fitness_best(1) = gene_best{1,2}; %将当前最优存入矩阵当中
    % 初始化新个体
    x1{1,1} = zeros(1,3);
    x2{1,1} = zeros(1,3);
    x3 = code;
    for epoch = 1: ger                                          % 开始迭代进化
        pm = 0.7-epoch*(0.7/ger);                               % 变异概率随迭代次数增加而减小
                                                                % 交叉操作
        kk = 1;                                                 %计数
        for i = 1: num 
            if rand < pc
               d = randi(num);                                   % 确定另一个交叉的个体d
               m = code{d,1};            
               dr = randi(n);                                     % 确定交叉断点
               x1{kk,1} = [code{i,1}(1:dr),m(dr+1:n)];             % 新个体 1
               x2{kk,1} = [m(1:dr),code{i,1}(dr+1:n)];            % 新个体 2
               kk = kk+1;
            end
        end
        for i = 1: num                                                      % 变异操作
            if rand < pm
                pmn = randi(n);
                x3{i,1}(pmn) = xmin(pmn)+(xmax(pmn)-xmin(pmn))*rand;
            end
        end
        code = [code;x1;x2;x3]; % 合并新旧染色体
        code = cell_isequal(code); % 删除重复个体，防止陷于局部最优
        [fitness,~,~,~] = setflc(code); %计算适应度
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
        disp(epoch);
        disp(gene_best{1,2});
    end
    
    [~,flc,T,y] = setflc(gene_best);
    writefis(flc,'flcbest.fis'); % 保存最优模糊控制器
    flc=readfis('flc.fis'); % 读取初始模糊控制器
    close_system('FLC'); % 关闭正在运行的simulink模型
    options=simset('SrcWorkspace','current'); % 设置simulink使用当前工作空间
    [T1,~,y1] = sim('FLC.slx',10,options);%调用simulink模型FLC.slx
    t = (-1:0.01:10)';
    unitstep2 = t>=0; % 阶跃信号
    % 绘制阶跃信号输入和系统响应
    figure(1)
    plot(T, y, 'k',T1, y1, 'r',t,unitstep2,'b');
    legend('System output after optimization', 'System raw output','System input');
    title('Genetic algorithm to optimize membership function');
    xlabel('time(s)');
    grid on
end
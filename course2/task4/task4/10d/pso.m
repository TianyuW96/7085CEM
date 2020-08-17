function record = pso(num,ger,xmin,xmax)
% 函数功能：实现粒子群算法，寻优
% 输入：
%   num:种群数量
%   ger:迭代次数     
%   xmin:参数下限
%   xmax:参数上限
% 输出：
%   record:每代最优适应度值
d = size(xmin,2);
vlimit = [-1, 1];               % 设置速度限制
w = 0.8;                        % 惯性权重
c1 = 0.5;                       % 自我学习因子
c2 = 0.5;                       % 群体学习因子 
code = cell(num,1);
v = cell(num,1);
for i = 1:num
    x = zeros(1,d);
    for j = 1:d
        x(j) = xmin(j) + (xmax(j) - xmin(j)) * rand;%初始种群的位置
    end
    code{i,1} = x;
    v{i,1} = rand(1, d);                  % 初始种群的速度
end
xm = code;                          % 每个个体的历史最佳位置
ym = zeros(1, d);                % 种群的历史最佳位置
fxm = zeros(num, 1);             % 每个个体的历史最佳适应度
fym = -inf;                      % 种群历史最佳适应度
% 群体更新
iter = 1;
record = zeros(ger, 1);          % 记录器
while iter <= ger
     fx = simpleton(code) ; % 个体当前适应度   
     for i = 1:num      
        if fxm(i) < fx(i)
            fxm(i) = fx(i);     % 更新个体历史最佳适应度
            xm(i,:) = code(i,:);   % 更新个体历史最佳位置
        end 
     end
    if fym < max(fxm)
            [fym, nmax] = max(fxm);   % 更新群体历史最佳适应度
            ym = xm(nmax, :);      % 更新群体历史最佳位置
    end
    ymcell = repmat(ym, num, 1);
    for i = 1:num
        v{i,1} = v{i,1} * w + c1 * rand * (xm{i,1} - code{i,1}) + c2 * rand * (ymcell{i,1} - code{i,1});% 速度更新 
    end
    % 边界速度处理
    vi = cell2mat(v(:,1));
    vi(vi > vlimit(2)) = vlimit(2);
    vi(vi < vlimit(1)) = vlimit(1);
    for i = 1:num
        v{i,1} = vi(i,:);
    end
    for i = 1:num
        code{i,1} = code{i,1} + v{i,1};% 位置更新
    end
    % 边界位置处理
    codec = cell2mat(code(:,1));
    for i = 1:d
        codei = codec(:,i);
        codei(codei > xmax(i)-0.5) = xmax(i);
        codei(codei < xmin(i)+0.5) = xmin(i);
        codec(:,i) = codei;
    end
    for i = 1:num
        code{i,1} = codec(i,:);
    end
    record(iter) = fym;%最大值记录
    iter = iter+1;
end
% fprintf('最大值： %f\n',fym(1));
% fprintf('参数值： %f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',ym{1,1})
clear; % 清除工作区变量
clc; % 清除命令行窗口
warning('off') % 忽略警告
n = 10; % 设定种群数量
ger = 100; % 设定进化代数
xmin = ones(1,10);
xmax = ones(1,10)+9;
mygafit = zeros(1,15);
psofit = zeros(1,15);
for i = 1:15
    fitness_best1 = myga(n,ger,xmin,xmax); % 使用遗传算法优化
    fitness_best2 = pso(n,ger,xmin,xmax); % 使用粒子群算法优化
    mygafit(i) = max(fitness_best1);
    psofit(i) = max(fitness_best2);
end
fprintf('遗传算法运行15次的平均性能为%f\n',std(mygafit));
fprintf('粒子群算法运行15次的平均性能为%f\n',std(psofit));
% 画图
figure(1)
plot(1:ger, fitness_best1, 'b')
axis( [0 ger+1 0 10^5] );
title('遗传算法优化');
xlabel('进化代数');
ylabel('适应度值');
grid on
figure(2)
plot(1:ger, fitness_best2, 'b')
axis( [0 ger+1 0 10^5] );
title('粒子群算法优化');
xlabel('迭代次数');
ylabel('适应度值');
grid on
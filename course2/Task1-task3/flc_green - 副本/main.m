clear; % 清除工作区变量
clc; % 清除命令行窗口
warning('off') % 忽略警告
n = 3; % 设定种群数量
ger = 10; % 设定进化代数
fitness_best = myga1(n,ger,[0.001 0.001 0.001],[0.1 0.1 4/7]); % 使用遗传算法优化隶属度函数，并存储为flcbest.fis
fitness_best2 = myga2(n,ger); % 使用遗传算法优化模糊规则库
% 画图
figure(3)
plot(1:ger, fitness_best, 'b')
axis( [0 ger+1 0 1] );
xlabel('Number of evolutions');
ylabel('Fitness value');
grid on
figure(4)
plot(1:ger, fitness_best2, 'b')
axis( [0 ger+1 0 1] );
xlabel('Number of evolutions');
ylabel('Fitness value');
grid on
clear; % �������������
clc; % ��������д���
warning('off') % ���Ծ���
n = 3; % �趨��Ⱥ����
ger = 10; % �趨��������
fitness_best = myga1(n,ger,[0.001 0.001 0.001],[0.1 0.1 4/7]); % ʹ���Ŵ��㷨�Ż������Ⱥ��������洢Ϊflcbest.fis
fitness_best2 = myga2(n,ger); % ʹ���Ŵ��㷨�Ż�ģ�������
% ��ͼ
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
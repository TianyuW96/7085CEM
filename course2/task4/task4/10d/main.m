clear; % �������������
clc; % ��������д���
warning('off') % ���Ծ���
n = 10; % �趨��Ⱥ����
ger = 100; % �趨��������
xmin = ones(1,10);
xmax = ones(1,10)+9;
mygafit = zeros(1,15);
psofit = zeros(1,15);
for i = 1:15
    fitness_best1 = myga(n,ger,xmin,xmax); % ʹ���Ŵ��㷨�Ż�
    fitness_best2 = pso(n,ger,xmin,xmax); % ʹ������Ⱥ�㷨�Ż�
    mygafit(i) = max(fitness_best1);
    psofit(i) = max(fitness_best2);
end
fprintf('�Ŵ��㷨����15�ε�ƽ������Ϊ%f\n',std(mygafit));
fprintf('����Ⱥ�㷨����15�ε�ƽ������Ϊ%f\n',std(psofit));
% ��ͼ
figure(1)
plot(1:ger, fitness_best1, 'b')
axis( [0 ger+1 0 10^5] );
title('�Ŵ��㷨�Ż�');
xlabel('��������');
ylabel('��Ӧ��ֵ');
grid on
figure(2)
plot(1:ger, fitness_best2, 'b')
axis( [0 ger+1 0 10^5] );
title('����Ⱥ�㷨�Ż�');
xlabel('��������');
ylabel('��Ӧ��ֵ');
grid on
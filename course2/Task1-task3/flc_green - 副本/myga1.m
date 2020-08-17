function fitness_best = myga1(num,ger,xmin,xmax)   
% �������ܣ�ʵ���Ŵ��㷨���Ż�ģ������
% ���룺
%   num:��Ⱥ����
%   ger:��������
%   xmin:��������

%   xmax:��������
% �����
%   fitness_best:ÿ��������Ӧ��ֵ
% ģ���������ж�ʹ�õȱȵȷ������Ⱥ�������������ֵ���������ȵĿ��
    n = 3;                              % Ⱦɫ�峤��
    pc = 0.2;                            % �������
    code = cell(num,1);                  % ��Ÿ���Ⱦɫ��
    fitness_best = zeros(ger, 1);        % ���ÿһ����������Ӧ��
    % ��ȺȾɫ������ʼ����ʹ��ʵ������
    for co=1:1:num
        code{co,1} = [xmin(1)+(xmax(1)-xmin(1))*rand xmin(2)+(xmax(2)-xmin(2))*rand xmin(3)+(xmax(3)-xmin(3))*rand];
    end
    [fitness,~,~,~] = setflc(code); %������Ӧ��
    %��ʼ�����Ÿ��壬�������Ÿ���Ⱦɫ�弰����Ӧ��
    gene_best = Findbest(code,fitness);
    fitness_best(1) = gene_best{1,2}; %����ǰ���Ŵ��������
    % ��ʼ���¸���
    x1{1,1} = zeros(1,3);
    x2{1,1} = zeros(1,3);
    x3 = code;
    for epoch = 1: ger                                          % ��ʼ��������
        pm = 0.7-epoch*(0.7/ger);                               % �������������������Ӷ���С
                                                                % �������
        kk = 1;                                                 %����
        for i = 1: num 
            if rand < pc
               d = randi(num);                                   % ȷ����һ������ĸ���d
               m = code{d,1};            
               dr = randi(n);                                     % ȷ������ϵ�
               x1{kk,1} = [code{i,1}(1:dr),m(dr+1:n)];             % �¸��� 1
               x2{kk,1} = [m(1:dr),code{i,1}(dr+1:n)];            % �¸��� 2
               kk = kk+1;
            end
        end
        for i = 1: num                                                      % �������
            if rand < pm
                pmn = randi(n);
                x3{i,1}(pmn) = xmin(pmn)+(xmax(pmn)-xmin(pmn))*rand;
            end
        end
        code = [code;x1;x2;x3]; % �ϲ��¾�Ⱦɫ��
        code = cell_isequal(code); % ɾ���ظ����壬��ֹ���ھֲ�����
        [fitness,~,~,~] = setflc(code); %������Ӧ��
        code(:,2)=num2cell(fitness);
        code = flipud(sortrows(code, 2));
        while size(code, 1) > num               % ��Ȼѡ��
            d = randi(size(code, 1));           % ������
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
    writefis(flc,'flcbest.fis'); % ��������ģ��������
    flc=readfis('flc.fis'); % ��ȡ��ʼģ��������
    close_system('FLC'); % �ر��������е�simulinkģ��
    options=simset('SrcWorkspace','current'); % ����simulinkʹ�õ�ǰ�����ռ�
    [T1,~,y1] = sim('FLC.slx',10,options);%����simulinkģ��FLC.slx
    t = (-1:0.01:10)';
    unitstep2 = t>=0; % ��Ծ�ź�
    % ���ƽ�Ծ�ź������ϵͳ��Ӧ
    figure(1)
    plot(T, y, 'k',T1, y1, 'r',t,unitstep2,'b');
    legend('System output after optimization', 'System raw output','System input');
    title('Genetic algorithm to optimize membership function');
    xlabel('time(s)');
    grid on
end
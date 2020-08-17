function fitness_best = myga2(num,ger)   
% �������ܣ�ʵ���Ŵ��㷨���Ż�ģ������
% ���룺
%   num:��Ⱥ����
%   ger:��������
% �����
%   fitness_best:ÿ��������Ӧ��ֵ
    n = 7;                               % �������
    gnum = 21;                           % ���򳤶�
    L = n*gnum;                          % Ⱦɫ�峤��
    pc = 0.2;                            % �������
    code = cell(num,1);                  % ��Ÿ���Ⱦɫ��
    fitness_best = zeros(ger, 1);        % ���ÿһ����������Ӧ��
    % Ⱦɫ������ʼ��
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
    % ��ȺȾɫ�����
    decode = mycoder(n,code); 
    [fitness,~,~] = aim(decode); %������Ӧ��
    %��ʼ������Ⱦɫ�壬��������Ⱦɫ�弰����Ӧ��
    gene_best = Findbest(code,fitness);
    fitness_best(1) = gene_best{1,2};      %����ǰ���Ŵ��������
    % ��ʼ����Ⱦɫ��
    x1{1,1} = zeros(7,21);
    x2{1,1} = zeros(7,21);
    x3 = code;    
    for epoch = 1: ger                                                                          % ��ʼ��������
        pm = 0.7-epoch*(0.7/ger);                                                                % �������������������Ӷ���С
       
        kk = 1;
        for i = 1: num 
            if rand < pc
               d = randi(num);                                                                    % ȷ����һ������ĸ���d
               m = code{d,1};            
               dr = randi(n);                                                                    % ȷ������ϵ�
               dc = randi(gnum);
               x1{kk,1} = [[code{i,1}(1:dr,1:dc), m(1:dr,dc+1:gnum)];m(dr+1:n,:)];               % �¸��� 1
               x2{kk,1} = [[m(1:dr,1:dc), code{i,1}(1:dr,dc+1:gnum)];code{i,1}(dr+1:n,:)];         % �¸��� 2
               kk = kk+1;
            end
        end
        for i = 1: num                                                                           % �������
            if rand < pm
                x3{i,1}(randi(L)) = randi([0, 1]);
            end
        end
        code = [code;x1;x2;x3];                           % �ϲ��¾�Ⱦɫ��
        code = cell_isequal(code);                        % ɾ���ظ����壬��ֹ���ھֲ�����
        decode = mycoder(n,code);                         % ��Ⱥ����
        [fitness,~,~] = aim(decode);                      %������Ӧ��
        code(:,2)=num2cell(fitness);
        code = flipud(sortrows(code, 2));
        while size(code, 1) > num                         % ��Ȼѡ��
            d = randi(size(code, 1));                     % ������
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
    % ���ƽ�Ծ�ź������ϵͳ��Ӧ
    figure(2)
    plot(T, y, 'r',t,unitstep2,'b');
    grid on
end
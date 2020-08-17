function fitness_best = myga(num,ger,xmin,xmax)   
% �������ܣ�ʵ���Ŵ��㷨���Ż�ģ������
% ���룺
%   num:��Ⱥ����
%   ger:��������
%   xmin:��������
%   xmax:��������
% �����
%   fitness_best:ÿ��������Ӧ��ֵ
% ģ���������ж�ʹ�õȱȵȷ������Ⱥ�������������ֵ���������ȵĿ��
    n = size(xmin,2);                              % Ⱦɫ�峤��
    pc = 0.2;                            % �������
    code = cell(num,1);                  % ��Ÿ���Ⱦɫ��
    fitness_best = zeros(ger, 1);        % ���ÿһ����������Ӧ��
    % ��ȺȾɫ������ʼ����ʹ��ʵ������
    for i = 1:num
        x = zeros(1,n);
        for j = 1:n
            x(j) = xmin(j) + (xmax(j) - xmin(j)) * rand;%��ʼ��Ⱥ��λ��
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
    fitness = simpleton(code); %������Ӧ��
    %��ʼ�����Ÿ��壬�������Ÿ���Ⱦɫ�弰����Ӧ��
    gene_best = Findbest(code,fitness);
    fitness_best(1) = gene_best{1,2}; %����ǰ���Ŵ��������
    % ��ʼ���¸���
    x1{1,1} = zeros(1,n);
    x2{1,1} = zeros(1,n);
    x3 = code;
    for epoch = 1: ger               % ��ʼ��������
        pm = 0.7-epoch*(0.7/ger);    % �������������������Ӷ���С
        % �������
        kk = 1;%����
        for i = 1: num 
            if rand < pc
               d = randi(num);         % ȷ����һ������ĸ���d
               m = code{d,1};            
               dr = randi(n);          % ȷ������ϵ�
               x1{kk,1} = [code{i,1}(1:dr),m(dr+1:n)];  % �¸��� 1
               x2{kk,1} = [m(1:dr),code{i,1}(dr+1:n)];  % �¸��� 2
               kk = kk+1;
            end
        end
        for i = 1: num                           % �������
            if rand < pm
                pmn = randi(n);
                x3{i,1}(pmn) = randi([xmin(pmn),xmax(pmn)]);%xmin(pmn)+(xmax(pmn)-xmin(pmn))*rand;
            end
        end
        code = [code;x1;x2;x3]; % �ϲ��¾�Ⱦɫ��
        code = cell_isequal(code); % ɾ���ظ����壬��ֹ���ھֲ�����
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
        fitness = simpleton(code); %������Ӧ��
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
    end
    %fprintf('�Ŵ��㷨���ֵ�� %f������Ⱦɫ�壺%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',[gene_best{1,2},gene_best{1,1}]);
end
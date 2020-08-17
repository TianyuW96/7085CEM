function record = pso(num,ger,xmin,xmax)
% �������ܣ�ʵ������Ⱥ�㷨��Ѱ��
% ���룺
%   num:��Ⱥ����
%   ger:��������     
%   xmin:��������
%   xmax:��������
% �����
%   record:ÿ��������Ӧ��ֵ
d = size(xmin,2);
vlimit = [-1, 1];               % �����ٶ�����
w = 0.8;                        % ����Ȩ��
c1 = 0.5;                       % ����ѧϰ����
c2 = 0.5;                       % Ⱥ��ѧϰ���� 
code = cell(num,1);
v = cell(num,1);
for i = 1:num
    x = zeros(1,d);
    for j = 1:d
        x(j) = xmin(j) + (xmax(j) - xmin(j)) * rand;%��ʼ��Ⱥ��λ��
    end
    code{i,1} = x;
    v{i,1} = rand(1, d);                  % ��ʼ��Ⱥ���ٶ�
end
xm = code;                          % ÿ���������ʷ���λ��
ym = zeros(1, d);                % ��Ⱥ����ʷ���λ��
fxm = zeros(num, 1);             % ÿ���������ʷ�����Ӧ��
fym = -inf;                      % ��Ⱥ��ʷ�����Ӧ��
% Ⱥ�����
iter = 1;
record = zeros(ger, 1);          % ��¼��
while iter <= ger
     fx = simpleton(code) ; % ���嵱ǰ��Ӧ��   
     for i = 1:num      
        if fxm(i) < fx(i)
            fxm(i) = fx(i);     % ���¸�����ʷ�����Ӧ��
            xm(i,:) = code(i,:);   % ���¸�����ʷ���λ��
        end 
     end
    if fym < max(fxm)
            [fym, nmax] = max(fxm);   % ����Ⱥ����ʷ�����Ӧ��
            ym = xm(nmax, :);      % ����Ⱥ����ʷ���λ��
    end
    ymcell = repmat(ym, num, 1);
    for i = 1:num
        v{i,1} = v{i,1} * w + c1 * rand * (xm{i,1} - code{i,1}) + c2 * rand * (ymcell{i,1} - code{i,1});% �ٶȸ��� 
    end
    % �߽��ٶȴ���
    vi = cell2mat(v(:,1));
    vi(vi > vlimit(2)) = vlimit(2);
    vi(vi < vlimit(1)) = vlimit(1);
    for i = 1:num
        v{i,1} = vi(i,:);
    end
    for i = 1:num
        code{i,1} = code{i,1} + v{i,1};% λ�ø���
    end
    % �߽�λ�ô���
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
    record(iter) = fym;%���ֵ��¼
    iter = iter+1;
end
% fprintf('���ֵ�� %f\n',fym(1));
% fprintf('����ֵ�� %f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',ym{1,1})
function decode=mycoder(n,code)
% �������ܣ�����ȺȾɫ��������
% ���룺
%   n:��������
%   code:Ⱦɫ�����
% �����
%   decode:Ⱦɫ�����
    for p=1:1:size(code,1)
        for m=1:1:n
            E(m,:) = code{p,1}(m,:);%��p��Ⱦɫ��ĵ�m������
            for i=1:1:7 % �Ե�m������ĵ�i��ģ���Ӽ�����
                for k=i*3 %ÿ����Ϊһ��ģ���Ӽ�����
                    decode{p,1}(m,i) = E(m,k-2)*2^2+E(m,k-1)*2^1+E(m,k)*2^0+1;
                end
            end
        end
    end
end
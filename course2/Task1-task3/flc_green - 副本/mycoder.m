function decode=mycoder(n,code)
% 函数功能：将种群染色体编码解码
% 输入：
%   n:基因数量
%   code:染色体编码
% 输出：
%   decode:染色体解码
    for p=1:1:size(code,1)
        for m=1:1:n
            E(m,:) = code{p,1}(m,:);%第p个染色体的第m个基因
            for i=1:1:7 % 对第m个基因的第i个模糊子集解码
                for k=i*3 %每三个为一个模糊子集编码
                    decode{p,1}(m,i) = E(m,k-2)*2^2+E(m,k-1)*2^1+E(m,k)*2^0+1;
                end
            end
        end
    end
end
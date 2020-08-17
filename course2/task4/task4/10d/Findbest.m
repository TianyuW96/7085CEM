function gene_best = Findbest(code,fitness)
% 函数功能：找到最优适应度值及染色体编码
% 输入：
%   code:种群染色体编码
%   fitness:种群每个个体适应度值  
% 输出：
%   gene_best:最优适应度值及染色体编码
    gene_best = cell(1,2);
    code(:,2)=num2cell(fitness);
    code = flipud(sortrows(code, 2));
    gene_best{1,1} = code{1,1};
    gene_best{1,2} = code{1,2};
end
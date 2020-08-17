function gene_best = Findbest(code,fitness)

    gene_best = cell(1,2);
    code(:,2)=num2cell(fitness);
    code = flipud(sortrows(code, 2));
    gene_best{1,1} = code{1,1};
    gene_best{1,2} = code{1,2};
end
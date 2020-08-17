function code = cell_isequal(code)
% 函数功能：删除cell中的重复行
% 输入：
%   code:cell
% 输出：
%   code:无重复行的cell
    k1=1;
    k2=1;
    while(k1<=size(code,1))
        while(k2<=size(code,1))
            if k1~=k2 && isequal(code{k1,1},code{k2,1})
                code(k2,:) = [];
            end
            k2 =k2+1;
        end
        k1=k1+1;
    end
end
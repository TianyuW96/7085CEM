function [fitness,flc,T,y] = setflc(ucode)
    fitness = zeros(size(ucode,1),1); % 适应度值初始化
    % 模糊规则
    rulelist =[8 8 8 8 8 7 6;
               8 8 7 6 5 4 3;
               8 7 6 5 4 3 2;
               7 6 5 5 4 3 2;
               7 6 5 4 3 2 1;
               6 5 4 3 2 1 1;
               3 2 1 1 1 1 1;];
    for i=1:7
        for j=1:7
            if i==1&&j==1
                rule2 = [i j rulelist(i,j) 1 1];
            else
                rule1 = [i j rulelist(i,j) 1 1];
                rule2 = [rule2;rule1];
            end
        end
    end
    iT = ["NB","NM","NS","ZO","PS","PM","PB"];          % 输入参数模糊集
    out = ["NB","NM","NS","NO","PO","PS","PM","PB"];     % 输出参数模糊集
    % 设置模糊控制器
    for p=1:size(ucode,1)
        flc = newfis('hanshu');
        flc = addvar(flc,'input','T',[-1 1]);
        flc = addvar(flc,'input','TC',[-1 1]);
        flc = addvar(flc,'output','out',[-1 1]);
        for i=1:7
            flc = addmf(flc,'input',1,iT(i),'gaussmf',[ucode{p,1}(1) -1+(i-1)*2/6]);
            flc = addmf(flc,'input',2,iT(i),'gaussmf',[ucode{p,1}(2) -1+(i-1)*2/6]);
            flc = addmf(flc,'output',1,out(i),'trimf',[-1+(i-1)*2/7-ucode{p,1}(3)/2 -1+(i-1)*2/7 -1+(i-1)*2/7+ucode{p,1}(3)/2]); % 三角形隶属度函数的宽度
        end
        flc = addmf(flc,'output',1,"PB",'trimf',[1-ucode{p,1}(3)/2 1 1+ucode{p,1}(3)/2]);
        flc = addrule(flc,rule2);
        close_system('FLC'); 
        options=simset('SrcWorkspace','current'); 
        [T,~,y] = sim('FLC.slx',10,options);
        [k,~]=size(y);
      
        itae = T(1,1)*abs(1-y(i))*(T(2,1)-T(1,1)); 
        for i = 2:k
            e = 1-y(i); 
            jian_ge = T(i,1)-T(i-1,1);
            itae = T(i,1)*abs(e)*jian_ge+itae;
        end
        fitness(p) = 1/(1+itae);
    end
end
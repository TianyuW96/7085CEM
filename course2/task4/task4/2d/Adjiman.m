% Adjiman's Function
% Range of initial points: -5 <= xj <= 5 , j=1,2
% Some references: -1 <= x1 <= 2 , -1 <= x2 <= 1 "different global minima"
% Global minima: (x1,x2)=(5,0)
% f(x1,x2)=-5
% Coded by: Ali R. Alroomi | Last Update: 11 May 2015 | www.al-roomi.org
function fitness = Adjiman(ucode)
    fitness = zeros(size(ucode,1),1); % 适应度值初始化
    for p=1:size(ucode,1)
        x1 = ucode{p,1}(1);
        x2 = ucode{p,1}(2);
        fitness(p)=1/(6+cos(x1)*sin(x2)-x1/(1+x2.^2));
    end
end   
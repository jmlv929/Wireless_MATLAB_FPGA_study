function y = WHT(x_in, n)
% x 输入向量，列向量
% n 即Walsh-Hardma变换的点数，必须是2的幂次方
% alpha 即重叠保留的因子，在我们的方案中alpha = 2
% y 输出向量
% alpha=2;

alpha=2;

% 判断输入参数n
n1 = log2(n);
n2 = mod(n1,1);
if (n2 ~= 0)
    error('wht.m模块的输入参数n必须是2的幂次方');
end 

% 输入向量应该是一个列向量
% 判断输入向量x是行向量还是列向量
[a , b] = size(x_in);
if (a>1)
    x = x_in;
else
    x = x_in.'; % 注意.'是转置，'是共轭转置
end

y = zeros(length(x),1);

%% 构成[n*2n]的Walsh-Hardma变换矩阵
% [n*n]的Walsh-Hardma变换矩阵
W = zeros(n,n);
W(1,1) = 1;
for t = 1 : n1  % t 的标记单位是log2(n)
    for i = 1 : n
        for j = 1 : n
            if (i <= 2^(t-1) && j <= 2^(t-1))
                W(i ,j) = W(i ,j);
            elseif (i <= 2^(t-1) && j > 2^(t-1))
                W(i ,j) = W (i , j-2^(t-1));
            elseif (i > 2^(t-1) && j <= 2^(t-1))
                W(i ,j) = W (i-2^(t-1) , j);
            else
                W(i ,j) = -W (i-2^(t-1) , j-2^(t-1));
            end     
        end
    end   
end
% 构成[n*2n]的Walsh-Hardma变换矩阵
W1 = zeros(n,2*n);
for i1 = 1 : n
    W1(i1,1:n) = W(i1,:);
    W1(i1,n+1:2*n) = W(i1,:);   
end

%% 生成变换向量 x1 
len = n*2;
x1 = zeros(len, 1);

tlen = length(x) / n;

for i = 1:tlen
    if (i == 1)
        for i1 = 1 : n/2
            x1(i1, 1) = 0;
        end
        x1(n/2+1:1.5*n,1) = x((i-1)*n+1:i*n,1);
        x1((1.5*n+1):2*n,1) = x((i*n+1):(i*n+0.5*n),1);
    elseif (i < tlen )
        x1(1:2*n) = x((i-1)*n+1-n/2:i*n+n/2,1);
    else
        x1(1:1.5*n) = x((i-1)*n+1-n/2:i*n,1);
        for i1 = 1.5*n+1 : 2*n
            x1(i1, 1) = 0;
        end
    end
    		y((i-1)*n+1:i*n,1) = W1*x1;        
end

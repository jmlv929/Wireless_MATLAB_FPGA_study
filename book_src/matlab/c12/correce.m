n = 128;   %哈达码矩阵的阶数
n1 = log2(n);
W = zeros(n,n);
W(1,1) = 1;
for t = 1 : n1  %产生哈达码矩阵
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
x=randint(1,n);       %发送数据
t=10;   %分配给此用户的为哈达码矩阵的第t行
s=W(t,:).*x;     %产生发送的数据
snr=-10;          %信噪比
enn = 10^(snr/10);      
sigman = sqrt(var(s)/(2*enn));        %噪声方差
x_noise = zeros(1,n);
x_noise = sigman*(randn(1,n));          %产生噪声
r = x_noise + s;          %接收信号
for i=1:n
   v(i)=sum(r.*W(i,:));            %相关接收机处理
end
num=find(v==max(v));           %找到最大值所对应的沃尔什码
    
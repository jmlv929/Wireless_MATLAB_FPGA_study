u = 0.00005;    %迭代步长
n = 64;  %WHT-LMS的抽头数必须是2的幂
h = zeros(n ,1);    %抽头系数，n为抽头个数
x = zeros(1 ,n);    %滤波器抽头输入
%% 注意：读者需要给出输入信号xd, 参考信号d，运行本程序就能得到相应仿真图
e = zeros(n ,1);       %估计误差
y = zeros(len , 1);  %估计信号，len为数据长度
beita = 0.8;    %
p = zeros(n, 1);   %信号功率估计
for i = 1 : len
    x(1,2:end) = x(1,1:end-1);
    x(1,1) = xd(i,1);   %xd为输入信号
    xh = WHT(x, n); %完成WHT变换
    p = p*beita + (1-beita)*abs(xh).^2;   %功率估计
    y(i) = xh.'*conj(h);       %估计信号
    e(i) = d(i) - y(i);       %d为参考信号
    h = h + 2*u.*conj(e(i))*xh./(p+0.02);   %抽头系数更新
end
for i=1:len;
    err(i1)=abs(e(i).^2);    %统计均方误差
end

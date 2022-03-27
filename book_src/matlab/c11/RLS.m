N = 128;    %抽头数
Dlen = 1024;  %输出长度
Step = 0.005; %步长
%注意：需要给出输入data和参考信号s(n)才能运行本程序
w=zeros(N,1);           %N为抽头个数
p=(1/delta)*eye(N);       %delta为正则化参数
for n= N:Dlen
    u(1:N)=data(n:-1:n-N+1);  %滤波器输入
    v=p*u;
    k=(1/step)*v/(1+(1/step)*u'*v);
    y(n) = w'*u;            %滤波器输出
    e(n)=s(n)-y(n);
    w=w+k*conj(e(n));
    p=(1/step)*(eye(N)-k*u')*p;
end   

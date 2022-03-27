function y=LPF(fc);  %实现低通的频域形式
global dt df N t f T
Bs=N*df/2; %系统带宽 
x1=(Bs-fc/2)*N/(2*Bs);
x2=(Bs+fc/2)*N/(2*Bs);
y=zeros(1,N);
y(x1:x2)=1;

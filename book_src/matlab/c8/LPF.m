function y=LPF(fc);  %ʵ�ֵ�ͨ��Ƶ����ʽ
global dt df N t f T
Bs=N*df/2; %ϵͳ���� 
x1=(Bs-fc/2)*N/(2*Bs);
x2=(Bs+fc/2)*N/(2*Bs);
y=zeros(1,N);
y(x1:x2)=1;

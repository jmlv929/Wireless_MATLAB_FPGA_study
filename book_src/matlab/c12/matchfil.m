len=20;
nsamp=2;   %ÿ������Ĳ�������
x=zeros(1,len);
x(10:10+nsamp-1)=1;   %��n=10������һ������
h=ones(1,nsamp);   %ƥ���˲�����ͬ����nsamp������
y=conv(x,h);   %ͨ��ƥ���˲���
subplot(1,2,1);
stairs(x(1:20))   %����ƥ���˲����������źŲ���
axis([0 20 -0.5 1.5]);
subplot(1,2,2);
plot(y(1:20))   % ����ƥ���˲���������źŲ���
axis([0 20 -0.5 2.5]);
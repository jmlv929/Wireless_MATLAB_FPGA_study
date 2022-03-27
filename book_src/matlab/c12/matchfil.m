len=20;
nsamp=2;   %每个脉冲的采样个数
x=zeros(1,len);
x(10:10+nsamp-1)=1;   %在n=10处出现一个脉冲
h=ones(1,nsamp);   %匹配滤波器，同样有nsamp个采样
y=conv(x,h);   %通过匹配滤波器
subplot(1,2,1);
stairs(x(1:20))   %画出匹配滤波器的输入信号波形
axis([0 20 -0.5 1.5]);
subplot(1,2,2);
plot(y(1:20))   % 画出匹配滤波器的输出信号波形
axis([0 20 -0.5 2.5]);

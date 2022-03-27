iwl = 16;  %CIC滤波器输入信号的字长
owl = 32;  %CIC滤波器输出信号的字长
wlps = 32;  %CIC滤波器每级滤波器中每个字的比特数
decf = 4;  %CIC滤波器的抽取率
diffd = 1;  %CIC滤波器中的差分时延
numsecs = 3;  %CIC滤波器级数
l = 2;      %半带滤波器抽取因子
n = 16;       %半带滤波器阶数
fp = 0.0001;     %半带滤波器的通带归一化频率
decm=decf*l;
len=length(x);
x1 = CICdec(decf,diffd,numsecs,x,iwl,owl,wlps);   %调用子函数CICdec进行CIC的抽取
x2 = halfdec(n,fp,l,x1);          %调用子函数halfdec进行半带滤波器的抽取
x3 = filter(h,1,x2);       %经过FIR滤波器，h为滤波器系数
stem(real(x(1:decm:decm*len)));hold on;
stem(real(x3(1:len)),'r.');

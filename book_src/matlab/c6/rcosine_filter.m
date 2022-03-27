Fd= 1; %输入信号的采样率
Fs = 8;  %输出信号的采样率
Delay = 3;  %滤波器的群时延
R = 0.5;   %滚降因子
[yf,tf] = rcosine(Fd,Fs,'fir',R,Delay);
plot(yf)
grid
xlabel('Time')
ylabel('Amplitude');
% impz(rrcfilter,1); % 另外一种画冲激响应的方法
x=rand(100,1);  %产生随机信号
xt=zeros(1,800);  %对输入信号后面补零
xt(1:8:end)=x;
y=filter(yf,tf,xt);  %经过升余弦滤波器
yt=y((length(yf)+1)/2:8:end);    %下采样，去除滤波器的抽头时延
figure;stem(x(1:40),'.');
hold on;stem(yt(1:40),'r');
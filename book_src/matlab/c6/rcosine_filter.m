Fd= 1; %�����źŵĲ�����
Fs = 8;  %����źŵĲ�����
Delay = 3;  %�˲�����Ⱥʱ��
R = 0.5;   %��������
[yf,tf] = rcosine(Fd,Fs,'fir',R,Delay);
plot(yf)
grid
xlabel('Time')
ylabel('Amplitude');
% impz(rrcfilter,1); % ����һ�ֻ��弤��Ӧ�ķ���
x=rand(100,1);  %��������ź�
xt=zeros(1,800);  %�������źź��油��
xt(1:8:end)=x;
y=filter(yf,tf,xt);  %�����������˲���
yt=y((length(yf)+1)/2:8:end);    %�²�����ȥ���˲����ĳ�ͷʱ��
figure;stem(x(1:40),'.');
hold on;stem(yt(1:40),'r');
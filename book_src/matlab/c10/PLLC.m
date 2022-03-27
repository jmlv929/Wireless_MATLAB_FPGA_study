len=1000;  %仿真数据长度
%QPSK信号源
I_Data=randint(N,1)*2-1;
Q_Data=randint(N,1)*2-1;
s=I_Data + j*Q_Data;
%载波信号
Freq_Sample=2400;   %采样率
Delta_Freq=-60;     %频偏
Time_Sample=1/Freq_Sample;   %每个采样值的持续时间
Delta_Phase=rand(1)*2*pi;   %随机初始相位
Carrier=exp(j*(Delta_Freq/Freq_Sample*(1:len)+Delta_Phase));  %载波
r=s.*Carrier';  %调制
%锁相环处理过程如下
Signal_PLL=zeros(len,1);   %锁相环锁定及稳定后的数据
NCO_Phase = zeros(len,1);   %锁定的相位
Discriminator_Out=zeros(len,1);
Freq_Control=zeros(len,1);
PLL_Phase_Part=zeros(len,1);   %锁相环频率
PLL_Freq_Part=zeros(len,1);   %锁相环相位
%环路处理
C1=0.022013;  %环路滤波器参数
C2=0.00024722;
for i=2:N
    Signal_PLL(i)=r(i)*exp(-j*mod(NCO_Phase(i-1),2*pi));   %得到鉴相器的输入
    I_PLL(i)=real(Signal_PLL(i));   %鉴相器的I路输入信息数据
    Q_PLL(i)=imag(Signal_PLL(i));   %鉴相器的Q路输入信息数据
    Discriminator_Out(i)=(sign(I_PLL(i))*Q_PLL(i)-sign(Q_PLL(i))*I_PLL(i))...
                /(sqrt(2)*abs(Signal_PLL(i)));   %鉴相器的输出
    PLL_Phase_Part(i)=Discriminator_Out(i)*C1;   %环路滤波器处理
    Freq_Control(i)=PLL_Phase_Part(i)+PLL_Freq_Part(i-1);
    PLL_Freq_Part(i)=Discriminator_Out(i)*C2+PLL_Freq_Part(i-1);
    NCO_Phase(i)=NCO_Phase(i-1)+Freq_Control(i);  %进行相位调整
end
%画图显示结果
figure
subplot(2,2,1)
plot(-PLL_Freq_Part(2:len)*Freq_Sample);
grid on;
title('锁相环频率响应曲线');
axis([1 len -100 100]);
subplot(2,2,2)
plot(PLL_Phase_Part(2:len)*180/pi);
title('锁相环相位响应曲线');
axis([1 len -2 2]);
grid on;
%设定显示范围
Show_D=300; %起始位置
Show_U=900; %终止位置
Show_Length=Show_U-Show_D;
subplot(2,2,3)
plot(r(Show_D:Show_U),'*');
title('进入锁相环的数据星座图');
axis([-2 2 -2 2]);
grid on;
hold on;
subplot(2,2,3)
plot(Signal_PLL(Show_D:Show_U),'r*');
grid on;
subplot(2,2,4)
plot(Signal_PLL(Show_D:Show_U),'r*');
title('锁相环锁定及稳定后的数据星座图');
axis([-2 2 -2 2]);
grid on;
 
figure
%设定显示范围
Show_D=600; %起始位置
Show_U=650; %终止位置
Show_Length=Show_U-Show_D;
subplot(2,2,1)
plot(I_Data(Show_D:Show_U));
grid on;
title('I路信息数据');
axis([1 Show_Length -2 2]);
subplot(2,2,2)
plot(Q_Data(Show_D:Show_U));
grid on;
title('Q路信息数据');
axis([1 Show_Length -2 2]);
subplot(2,2,3)
plot(I_PLL(Show_D:Show_U));
grid on;
title('锁相环输出I路信息数据');
axis([1 Show_Length -2 2]);
subplot(2,2,4)
plot(Q_PLL(Show_D:Show_U));
grid on;
title('锁相环输出Q路信息数据');
axis([1 Show_Length -2 2]);

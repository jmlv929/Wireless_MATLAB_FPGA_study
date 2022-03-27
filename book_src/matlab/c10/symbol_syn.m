clear;
load c;
Fs=38400;    %WCDMA信号的采样率
nsamp=16;    %过采样率
delay=3;    %根号下升余弦的群时延
datain=c;   %这里c为WCDMA系统的扰码数据
Num=length(datain);  %计算相关的长度
 
dataout=RRCsend(datain,Fs,nsamp,delay); %调用子程序，经过发送端的根号下升余弦滤波，输入采样率为1，输出采样率为16
 
%经过AWGN信道
SNR_DB=-22;  %信噪比
snr=10^(SNR_DB/10);
noise_var = 2/snr;   %假设dataout的平均码片能量为2
noise = sqrt(1/2*noise_var)*(randn(1,length(dataout))+j*randn(1,length(dataout)));
datachannel=dataout+noise;   %加噪声

datarece=RRCrece(datachannel,Fs,nsamp,delay,1);% 调用子程序，收端的根号下升余弦匹配滤波器，输入输出的采样率都为16倍
optimal_sample_piont=1+2*delay*nsamp;   %最佳采样点的起始位置
dataext=[datain,datain,datain];   %用于接收端相关的扰码
 
%设计低通滤波器
[b,a] = cheby2(3,20,100/19200);  %3阶，带外衰减20dB，采用率38400Hz，低通带宽100Hz
%偏离最佳采样点，向前偏移
for ii=1:16
datasample=datarece(optimal_sample_piont-16+ii:16:length(datarece)-2*delay*nsamp-15);
temp=real(datasample).*real(dataext(Num:2*Num-1))+imag(datasample).*imag(dataext(Num:2*Num-1));
    temp=filter(b,a,temp);%经过低通滤波器
    val_co1=sum(temp);%早门支路相关
temp=real(datasample).*real(dataext(Num+2:2*Num+1))+imag(datasample).*imag(dataext(Num+2:2*Num+1));
    temp=filter(b,a,temp);% 经过低通滤波器
val_co2=sum(temp);% 迟门支路相关   
val_co(ii)=(val_co2-val_co1)/(2*Num);%计算两路相关的差值，并归一化
end;
%偏离最佳采样点，向后偏移 
for ii=1:15
datasample=datarece(optimal_sample_piont+ii:16:length(datarece)-2*delay*nsamp+1); temp=real(datasample).*real(dataext(Num:2*Num-1))+imag(datasample).*imag(dataext(Num:2*Num-1));
    temp=filter(b,a,temp);%经过低通滤波器
    val_co1=sum(temp);%早门支路相关
temp=real(datasample).*real(dataext(Num+2:2*Num+1))+imag(datasample).*imag(dataext(Num+2:2*Num+1));
    temp=filter(b,a,temp);% 经过低通滤波器
    val_co2=sum(temp);%迟门支路相关
    val_co(16+ii)=(val_co2-val_co1)/(2*Num);% 计算两路相关的差值，并归一化
end;
 
ii=-15:15;
figure
stem(ii,val_co);
xlabel('采样点偏移');
ylabel('归一化相关点');

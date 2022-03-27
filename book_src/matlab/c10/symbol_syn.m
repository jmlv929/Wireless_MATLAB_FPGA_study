clear;
load c;
Fs=38400;    %WCDMA�źŵĲ�����
nsamp=16;    %��������
delay=3;    %�����������ҵ�Ⱥʱ��
datain=c;   %����cΪWCDMAϵͳ����������
Num=length(datain);  %������صĳ���
 
dataout=RRCsend(datain,Fs,nsamp,delay); %�����ӳ��򣬾������Ͷ˵ĸ������������˲������������Ϊ1�����������Ϊ16
 
%����AWGN�ŵ�
SNR_DB=-22;  %�����
snr=10^(SNR_DB/10);
noise_var = 2/snr;   %����dataout��ƽ����Ƭ����Ϊ2
noise = sqrt(1/2*noise_var)*(randn(1,length(dataout))+j*randn(1,length(dataout)));
datachannel=dataout+noise;   %������

datarece=RRCrece(datachannel,Fs,nsamp,delay,1);% �����ӳ����ն˵ĸ�����������ƥ���˲�������������Ĳ����ʶ�Ϊ16��
optimal_sample_piont=1+2*delay*nsamp;   %��Ѳ��������ʼλ��
dataext=[datain,datain,datain];   %���ڽ��ն���ص�����
 
%��Ƶ�ͨ�˲���
[b,a] = cheby2(3,20,100/19200);  %3�ף�����˥��20dB��������38400Hz����ͨ����100Hz
%ƫ����Ѳ����㣬��ǰƫ��
for ii=1:16
datasample=datarece(optimal_sample_piont-16+ii:16:length(datarece)-2*delay*nsamp-15);
temp=real(datasample).*real(dataext(Num:2*Num-1))+imag(datasample).*imag(dataext(Num:2*Num-1));
    temp=filter(b,a,temp);%������ͨ�˲���
    val_co1=sum(temp);%����֧·���
temp=real(datasample).*real(dataext(Num+2:2*Num+1))+imag(datasample).*imag(dataext(Num+2:2*Num+1));
    temp=filter(b,a,temp);% ������ͨ�˲���
val_co2=sum(temp);% ����֧·���   
val_co(ii)=(val_co2-val_co1)/(2*Num);%������·��صĲ�ֵ������һ��
end;
%ƫ����Ѳ����㣬���ƫ�� 
for ii=1:15
datasample=datarece(optimal_sample_piont+ii:16:length(datarece)-2*delay*nsamp+1); temp=real(datasample).*real(dataext(Num:2*Num-1))+imag(datasample).*imag(dataext(Num:2*Num-1));
    temp=filter(b,a,temp);%������ͨ�˲���
    val_co1=sum(temp);%����֧·���
temp=real(datasample).*real(dataext(Num+2:2*Num+1))+imag(datasample).*imag(dataext(Num+2:2*Num+1));
    temp=filter(b,a,temp);% ������ͨ�˲���
    val_co2=sum(temp);%����֧·���
    val_co(16+ii)=(val_co2-val_co1)/(2*Num);% ������·��صĲ�ֵ������һ��
end;
 
ii=-15:15;
figure
stem(ii,val_co);
xlabel('������ƫ��');
ylabel('��һ����ص�');

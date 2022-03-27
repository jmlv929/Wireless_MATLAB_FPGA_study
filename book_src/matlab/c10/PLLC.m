len=1000;  %�������ݳ���
%QPSK�ź�Դ
I_Data=randint(N,1)*2-1;
Q_Data=randint(N,1)*2-1;
s=I_Data + j*Q_Data;
%�ز��ź�
Freq_Sample=2400;   %������
Delta_Freq=-60;     %Ƶƫ
Time_Sample=1/Freq_Sample;   %ÿ������ֵ�ĳ���ʱ��
Delta_Phase=rand(1)*2*pi;   %�����ʼ��λ
Carrier=exp(j*(Delta_Freq/Freq_Sample*(1:len)+Delta_Phase));  %�ز�
r=s.*Carrier';  %����
%���໷�����������
Signal_PLL=zeros(len,1);   %���໷�������ȶ��������
NCO_Phase = zeros(len,1);   %��������λ
Discriminator_Out=zeros(len,1);
Freq_Control=zeros(len,1);
PLL_Phase_Part=zeros(len,1);   %���໷Ƶ��
PLL_Freq_Part=zeros(len,1);   %���໷��λ
%��·����
C1=0.022013;  %��·�˲�������
C2=0.00024722;
for i=2:N
    Signal_PLL(i)=r(i)*exp(-j*mod(NCO_Phase(i-1),2*pi));   %�õ�������������
    I_PLL(i)=real(Signal_PLL(i));   %��������I·������Ϣ����
    Q_PLL(i)=imag(Signal_PLL(i));   %��������Q·������Ϣ����
    Discriminator_Out(i)=(sign(I_PLL(i))*Q_PLL(i)-sign(Q_PLL(i))*I_PLL(i))...
                /(sqrt(2)*abs(Signal_PLL(i)));   %�����������
    PLL_Phase_Part(i)=Discriminator_Out(i)*C1;   %��·�˲�������
    Freq_Control(i)=PLL_Phase_Part(i)+PLL_Freq_Part(i-1);
    PLL_Freq_Part(i)=Discriminator_Out(i)*C2+PLL_Freq_Part(i-1);
    NCO_Phase(i)=NCO_Phase(i-1)+Freq_Control(i);  %������λ����
end
%��ͼ��ʾ���
figure
subplot(2,2,1)
plot(-PLL_Freq_Part(2:len)*Freq_Sample);
grid on;
title('���໷Ƶ����Ӧ����');
axis([1 len -100 100]);
subplot(2,2,2)
plot(PLL_Phase_Part(2:len)*180/pi);
title('���໷��λ��Ӧ����');
axis([1 len -2 2]);
grid on;
%�趨��ʾ��Χ
Show_D=300; %��ʼλ��
Show_U=900; %��ֹλ��
Show_Length=Show_U-Show_D;
subplot(2,2,3)
plot(r(Show_D:Show_U),'*');
title('�������໷����������ͼ');
axis([-2 2 -2 2]);
grid on;
hold on;
subplot(2,2,3)
plot(Signal_PLL(Show_D:Show_U),'r*');
grid on;
subplot(2,2,4)
plot(Signal_PLL(Show_D:Show_U),'r*');
title('���໷�������ȶ������������ͼ');
axis([-2 2 -2 2]);
grid on;
 
figure
%�趨��ʾ��Χ
Show_D=600; %��ʼλ��
Show_U=650; %��ֹλ��
Show_Length=Show_U-Show_D;
subplot(2,2,1)
plot(I_Data(Show_D:Show_U));
grid on;
title('I·��Ϣ����');
axis([1 Show_Length -2 2]);
subplot(2,2,2)
plot(Q_Data(Show_D:Show_U));
grid on;
title('Q·��Ϣ����');
axis([1 Show_Length -2 2]);
subplot(2,2,3)
plot(I_PLL(Show_D:Show_U));
grid on;
title('���໷���I·��Ϣ����');
axis([1 Show_Length -2 2]);
subplot(2,2,4)
plot(Q_PLL(Show_D:Show_U));
grid on;
title('���໷���Q·��Ϣ����');
axis([1 Show_Length -2 2]);

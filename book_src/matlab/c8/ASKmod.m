clear all
global dt t f df N T %ȫ�ֱ���
close all 
N=2^20; 
dt=0.001; %ms 
df=1/(N*dt); %KHz 
T=N*dt; %�ض�ʱ�� 
Bs=N*df/2; %ϵͳ���� 
t=linspace(-T/2,T/2,N); %ʱ������� 
f=linspace(-Bs,Bs,N)+eps; %Ƶ������� 
fm=1; %ģ������ź�Ƶ��Ϊ1kHz 
fc=6; %�����ز��ź�Ƶ��Ϊ6kHz 
mt=cos(2*pi*fm*t); %ģ������ź� 
m(mt>0)=1;  %���ͱ���
m(mt<0)=0;
c=cos(2*pi*fc*t); %�����ز��ź� 
s=m.*c; %DSB-SC AM�ѵ��ź� 
S=T2F(s); 
n=awgn(s,20); %AWGN�ŵ�����
r=s+n; %�����ź� 
y=r.*c; 
Lpfil=LPF(fc); %��ͨ�˲��� 
Y=T2F(y); 
yrt=real(F2T(Lpfil.*Y)); 
yr=yrt-mean(yrt);
yr(yr>0)=1;  %���ͱ���
yr(yr<0)=0;
subplot(3,1,1) 
plot(t,m,'LineWidth',1.2)
title('�����ź�');
axis([-1,+1,-0.2,1.2*max(m)]) 
xlabel('t (ms)')
ylabel('s(t) (V)') 
subplot(3,1,2) 
plot(t,s,'LineWidth',1.2) 
title('2ASK���ƺ���');
axis([-1,+1,1.2*min(c),1.2*max(c)]) 
xlabel('t (ms)')
ylabel('s(t) (V)') 
subplot(3,1,3)
plot(t,yr,'LineWidth',1.2) 
axis([-1,+1,-0.2,1.2*max(yr)])
title(['2ASK�������']) 
xlabel('t (ms)') 
ylabel('s(t) (V)')

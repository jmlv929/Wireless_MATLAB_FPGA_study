%impinvar_bilinear.m
%chebyshev1ģ��ԭ���˲��� 
Omegap=0.2*pi;Rp=1;     %���ָ�� 
Omegas=0.3*pi;As=16; 
[n1,Wn1]=cheb1ord(Omegap,Omegas,Rp,As,'s');  %���chebyshev1�Ľ״κͽ�ֹƵ�� 
[B1,A1]=cheby1(n1,0.5,Wn1,'s');       %���chebyshev1ģ��ԭ���˲��� 
w1=[0:500]*0.5*pi/500;              %Ƶ��ȡ�����0��0.5pi 
h1=freqs(B1,A1,w1);                %�����ڸ�ȡ����ĸ���Ҷ�任ֵ 
subplot(3,1,1);plot(w1,abs(h1));        %���Ʒ�Ƶ���� 
axis([0,0.5*pi,0,1]); 
grid; 
ylabel('ģ��ԭ���˲���'); 

%����������Ӧ���䷨��������˲���
T=0.2; %ȡ������ 
[Bz,Az]=impinvar(B1,A1,1/T); 
w2=[0:500]*0.5*pi*T/500;           %Ƶ��ȡ�����0��0.5pi 
[H,W]=freqz(Bz,Az,w2);            %�����ڸ�ȡ����ĸ���Ҷ�任ֵ 
w=W/T;                          %������Ƶ��ת��Ϊģ��Ƶ�� 
subplot(3,1,2); 
plot(w,abs(H));                    %���Ʒ�Ƶ���� 
axis([0,0.5*pi,0,1]); 
grid; 
ylabel('������Ӧ���䷨'); 

%����˫���Ա任����������˲���
wp=Omegap*T;                    %��ģ��Ƶ��ת��Ϊ����Ƶ�� 
ws=Omegas*T; 
Omegap1=(2/T)*tan(wp/2);           %��ģ��Ƶ�ʽ���Ԥ���� 
Omegas1=(2/T)*tan(ws/2); 
[n,Wn]=cheb1ord(Omegap1,Omegas1,Rp,As,'s'); %���chebyshev1�Ľ״κͽ�ֹƵ�� 
[B,A]=cheby1(n,0.5,Wn,'s');          %���chebyshev1ģ��ԭ���˲��� 
[Bz,Az]=bilinear(B,A,1/T);           %����˫���Ա任����������˲��� 
w2=[0:500]*0.5*pi*T/500;           %Ƶ��ȡ�����0��0.5pi 
[H,W]=freqz(Bz,Az,w2);             %�����ڸ�ȡ����ĸ���Ҷ�任ֵ 
w=W/T;                           %������Ƶ��ת��Ϊģ��Ƶ�� 
subplot(3,1,3); 
plot(w,abs(H));                     %���Ʒ�Ƶ���� 
axis([0,0.5*pi,0,1]); 
grid; 
ylabel('˫���Ա任��'); 

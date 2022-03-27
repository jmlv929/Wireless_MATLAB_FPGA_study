%impinvar_bilinear.m
%chebyshev1模拟原型滤波器 
Omegap=0.2*pi;Rp=1;     %设计指标 
Omegas=0.3*pi;As=16; 
[n1,Wn1]=cheb1ord(Omegap,Omegas,Rp,As,'s');  %获得chebyshev1的阶次和截止频率 
[B1,A1]=cheby1(n1,0.5,Wn1,'s');       %获得chebyshev1模拟原型滤波器 
w1=[0:500]*0.5*pi/500;              %频率取样点从0到0.5pi 
h1=freqs(B1,A1,w1);                %计算在各取样点的傅立叶变换值 
subplot(3,1,1);plot(w1,abs(h1));        %绘制幅频特性 
axis([0,0.5*pi,0,1]); 
grid; 
ylabel('模拟原型滤波器'); 

%利用脉冲响应不变法设计数字滤波器
T=0.2; %取样周期 
[Bz,Az]=impinvar(B1,A1,1/T); 
w2=[0:500]*0.5*pi*T/500;           %频率取样点从0到0.5pi 
[H,W]=freqz(Bz,Az,w2);            %计算在各取样点的傅立叶变换值 
w=W/T;                          %将数字频率转换为模拟频率 
subplot(3,1,2); 
plot(w,abs(H));                    %绘制幅频特性 
axis([0,0.5*pi,0,1]); 
grid; 
ylabel('脉冲响应不变法'); 

%利用双线性变换法设计数字滤波器
wp=Omegap*T;                    %将模拟频率转换为数字频率 
ws=Omegas*T; 
Omegap1=(2/T)*tan(wp/2);           %对模拟频率进行预畸变 
Omegas1=(2/T)*tan(ws/2); 
[n,Wn]=cheb1ord(Omegap1,Omegas1,Rp,As,'s'); %获得chebyshev1的阶次和截止频率 
[B,A]=cheby1(n,0.5,Wn,'s');          %获得chebyshev1模拟原型滤波器 
[Bz,Az]=bilinear(B,A,1/T);           %利用双线性变换法设计数字滤波器 
w2=[0:500]*0.5*pi*T/500;           %频率取样点从0到0.5pi 
[H,W]=freqz(Bz,Az,w2);             %计算在各取样点的傅立叶变换值 
w=W/T;                           %将数字频率转换为模拟频率 
subplot(3,1,3); 
plot(w,abs(H));                     %绘制幅频特性 
axis([0,0.5*pi,0,1]); 
grid; 
ylabel('双线性变换法'); 

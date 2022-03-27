snr=10;
N=input('number');   %数据长度
Es=3;
g=[1 0 1;0 0 1];  %卷积码编码器两路的冲激响应
x=round(rand(1,N)); %产生信源
for i=1:N/2; %串并变换
   x1(i)=x(2*i-1);
x2(i)=x(2*i);
end; 
z=cnvc(g,x1,x2);  %进行(3,2,3)卷积码编码，z为三行的向量
len=size(z,2);
zt=z.';
for i=1:len   %进行8PSK映射，得到信号点在星座图上的位置
   f(i)=bin2deci(zt(i,:)); 
   if ((f(i)>=3)&(f(i)<7))   %在星座图上处于0.75pi,pi,1.25pi和1.5pi的点
      R(i)=awgn(sqrt(Es)*cos(2*pi*f(i)/8),snr,'measured'); 
      H(i)=awgn(sqrt(Es)*sin(2*pi*f(i)/8),snr,'measured'); 
      T(i)=pi+atan(H(i)/R(i)); 
   elseif f(i)<3  %在星座图上处于0,0.25pi,0.5pi的点
      R(i)=awgn(sqrt(Es)*cos(2*pi*f(i)/8),snr,'measured'); 
      H(i)=awgn(sqrt(Es)*sin(2*pi*f(i)/8),snr,'measured'); 
      T(i)=atan(H(i)/R(i)); 
   else   %在星座图上处于1.75pi的点
      R(i)=awgn(sqrt(Es)*cos(2*pi*f(i)/8),snr,'measured'); 
      H(i)=awgn(sqrt(Es)*sin(2*pi*f(i)/8),snr,'measured'); 
      T(i)=2*pi+atan(H(i)/R(i)); 
   end; 
end; 

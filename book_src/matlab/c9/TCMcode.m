snr=10;
N=input('number');   %���ݳ���
Es=3;
g=[1 0 1;0 0 1];  %������������·�ĳ弤��Ӧ
x=round(rand(1,N)); %������Դ
for i=1:N/2; %�����任
   x1(i)=x(2*i-1);
x2(i)=x(2*i);
end; 
z=cnvc(g,x1,x2);  %����(3,2,3)�������룬zΪ���е�����
len=size(z,2);
zt=z.';
for i=1:len   %����8PSKӳ�䣬�õ��źŵ�������ͼ�ϵ�λ��
   f(i)=bin2deci(zt(i,:)); 
   if ((f(i)>=3)&(f(i)<7))   %������ͼ�ϴ���0.75pi,pi,1.25pi��1.5pi�ĵ�
      R(i)=awgn(sqrt(Es)*cos(2*pi*f(i)/8),snr,'measured'); 
      H(i)=awgn(sqrt(Es)*sin(2*pi*f(i)/8),snr,'measured'); 
      T(i)=pi+atan(H(i)/R(i)); 
   elseif f(i)<3  %������ͼ�ϴ���0,0.25pi,0.5pi�ĵ�
      R(i)=awgn(sqrt(Es)*cos(2*pi*f(i)/8),snr,'measured'); 
      H(i)=awgn(sqrt(Es)*sin(2*pi*f(i)/8),snr,'measured'); 
      T(i)=atan(H(i)/R(i)); 
   else   %������ͼ�ϴ���1.75pi�ĵ�
      R(i)=awgn(sqrt(Es)*cos(2*pi*f(i)/8),snr,'measured'); 
      H(i)=awgn(sqrt(Es)*sin(2*pi*f(i)/8),snr,'measured'); 
      T(i)=2*pi+atan(H(i)/R(i)); 
   end; 
end; 

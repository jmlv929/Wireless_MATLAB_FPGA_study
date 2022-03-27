l=2;  %半带滤波器的插值因子
n = 16;     %半带滤波器阶数
fp = 0.0001;     %半带滤波器的通带归一化频率
r=4;     %CIC滤波器的插值因子
interp1=r*l;   %总的插值因子
hb1 = halfinterp(n,fp,l,x);        %调用子函数halfinterp进行半带滤波器的插值
x1 = CICinterp(r,hb1);            %调用子函数CICinterp进行CIC滤波器的插值
stem(real(x(1:len)));hold on;
stem(real(x3(1:interp1:interp1*len)),'r.');

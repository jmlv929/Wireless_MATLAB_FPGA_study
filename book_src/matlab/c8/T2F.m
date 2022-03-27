function X=T2F(x)
global dt df N t f T
%x为时域的取样值矢量，X为x的傅氏变换，X与x长度相同,并为2的整幂。　
H=fft(x);
X=[H(N/2+1:N),H(1:N/2)]*dt;
end

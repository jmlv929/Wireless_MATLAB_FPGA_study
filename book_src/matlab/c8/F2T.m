function x=F2T(X)
global dt df t f T N
%x为时域的取样值矢量，X为x的傅氏变换，X与x长度相同并为2的整幂
X=[X(N/2+1:N),X(1:N/2)];
x=ifft(X)/dt;
end 

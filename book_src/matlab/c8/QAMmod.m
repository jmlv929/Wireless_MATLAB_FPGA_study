M = 16; %M进制
x = randint(5000,1,M);
y=modulate(modem.qammod(M),x);   %调制
ynoisy = awgn(y,15,'measured');   %加噪声
scatterplot(y);
scatterplot(ynoisy);
z=demodulate(modem.qamdemod(M),ynoisy);  %解调
[num,rt]= symerr(x,z)  %计算误比特率

M = 16; %M����
x = randint(5000,1,M);
y=modulate(modem.qammod(M),x);   %����
ynoisy = awgn(y,15,'measured');   %������
scatterplot(y);
scatterplot(ynoisy);
z=demodulate(modem.qamdemod(M),ynoisy);  %���
[num,rt]= symerr(x,z)  %�����������

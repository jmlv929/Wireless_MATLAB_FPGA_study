n=1000;
x = randint(n,1);      %������Դ.
h = modem.pskmod (4);    %�������ƾ��
y = modulate(h,x);    %���źŽ��е���
g = modem.pskdemod (h)  %����������
z = demodulate(g,y);      %���н��

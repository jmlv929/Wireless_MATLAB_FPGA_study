n=1000;
x = randint(n,1);      %产生信源.
h = modem.pskmod (4);    %产生调制句柄
y = modulate(h,x);    %对信号进行调制
g = modem.pskdemod (h)  %产生解调句柄
z = demodulate(g,y);      %进行解调

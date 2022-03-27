fs = 22.05e3;               % 原始采样频率:22.05 kHz.
n = 0:5119;                % 5120个采样点
x = sin(2*pi*1e3/fs*n);       %原始信号
b = firhalfband(16,0.0001,'dev');
impz(b);
h = mfilt.firdecim(2,b);     
y_fi = filter(h,x);
x = double(x);
y = double(y_fi);
y = y/max(abs(y));
stem(n(1:44)/fs,x(1:44),'r');
hold on;
stem(n(1:2:44)/(fs),y(5:26),'filled');
xlabel('时间(sec)');ylabel('信号值');

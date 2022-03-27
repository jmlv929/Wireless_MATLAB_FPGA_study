r = 2;                  % 抽取因子
hm = mfilt.cicdecim(r);    
fs = 44.1e3;            %原始的采样率 44.1kHz.
n = 0:10239;            % 10240个采样点
x  = sin(2*pi*1e3/fs*n);  %原始信号
y_fi = filter(hm,x);        %得到抽取后的5120个采样点
x = double(x);
y = double(y_fi);
y = y/max(abs(y));
stem(n(1:44)/fs,x(2:45)); hold on;  
stem(n(1:22)/(fs/r),y(3:24),'r','filled'); 
xlabel('时间(sec)');ylabel('信号值');

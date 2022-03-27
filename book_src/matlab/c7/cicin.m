R = 2;                      %��ֵ����
hm = mfilt.cicinterp(R);
fs = 22.05e3;               % ԭʼ����Ƶ��:22.05 kHz.
n = 0:5119;                % 5120��������
x = sin(2*pi*1e3/fs*n);    %ԭʼ�ź�
y_fi = filter(hm,x);  
x = double(x);
y = double(y_fi);
y = y/max(abs(y));
stem(n(1:22)/fs,x(1:22),'filled'); 
hold on;
stem(n(1:44)/(fs*R),y(4:47),'r');  
xlabel('ʱ��(sec)');ylabel('�ź�ֵ');

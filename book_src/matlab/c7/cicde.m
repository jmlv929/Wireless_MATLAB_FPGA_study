r = 2;                  % ��ȡ����
hm = mfilt.cicdecim(r);    
fs = 44.1e3;            %ԭʼ�Ĳ����� 44.1kHz.
n = 0:10239;            % 10240��������
x  = sin(2*pi*1e3/fs*n);  %ԭʼ�ź�
y_fi = filter(hm,x);        %�õ���ȡ���5120��������
x = double(x);
y = double(y_fi);
y = y/max(abs(y));
stem(n(1:44)/fs,x(2:45)); hold on;  
stem(n(1:22)/(fs/r),y(3:24),'r','filled'); 
xlabel('ʱ��(sec)');ylabel('�ź�ֵ');

fs = 12e6; %����Ƶ��
ts = 1/fs; 
num = 2.5e6;  %���ݳ���
SNR = -15;
real_fc = 3563000; %ʵ�ź�Ƶ��
data = sin(2*pi*real_fc*(0:num-1)*ts+pi/4)+sqrt(10^(SNR/10))*randn(1,num); %��˹��˹���������ź�
fc = 3562800; %����Ƶ��
 
n = fs/1000; %�ۻ�ʱ��Ϊ1ms
nn = [0:n-1];
nf = floor(length(data)/n);% ���������ݷֳ�1ms�Ķ�����ݿ�
wfc = 2*pi*fc;  %�����ź�
phi_prv = 0;
temp = 0;
frame = 0;
carrier_phase = 0;
phase = 0;
 
%��·�˲����Ĳ���
c1 = 153.7130;
c2 = 6.1498;

for frame=1:nf 
% �������ص�sin��cos����
expcol = exp(j*(wfc*ts*nn+phase));
sine = imag(expcol);   
cosine = real(expcol);

x = data((1:n)+((frame-1)*n));
%������ת��������
x_sine = x.*sine;
x_cosine = x.*cosine;
 
Q = sum(x_sine);      %�����˲���
I = sum(x_cosine);
phase_discri(frame) = atan(Q/I);   %�õ����໷������
 
%���໷
dfrq = c1*phase_discri(frame)+temp; %������·�˲���
temp = temp+c2*phase_discri(frame);
wfc = wfc-dfrq*2*pi;   %�ı䱾��Ƶ��
dfrq_frame(frame) = wfc; 
phase = wfc*ts*n+phase;   %�õ���ͬ�����λ
end
plot(dfrq_frame/(2*pi));
hold on
plot([1:length(dfrq_frame)], real_fc,'r');
legend('���໷����','ʵ�ʵ��ز�Ƶ��');
grid
mean_freq=mean(dfrq_frame/2/pi)
p=abs(real_fc-mean_freq)/real_fc;

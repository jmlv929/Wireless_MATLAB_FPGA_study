iwl = 16;  %CIC�˲��������źŵ��ֳ�
owl = 32;  %CIC�˲�������źŵ��ֳ�
wlps = 32;  %CIC�˲���ÿ���˲�����ÿ���ֵı�����
decf = 4;  %CIC�˲����ĳ�ȡ��
diffd = 1;  %CIC�˲����еĲ��ʱ��
numsecs = 3;  %CIC�˲�������
l = 2;      %����˲�����ȡ����
n = 16;       %����˲�������
fp = 0.0001;     %����˲�����ͨ����һ��Ƶ��
decm=decf*l;
len=length(x);
x1 = CICdec(decf,diffd,numsecs,x,iwl,owl,wlps);   %�����Ӻ���CICdec����CIC�ĳ�ȡ
x2 = halfdec(n,fp,l,x1);          %�����Ӻ���halfdec���а���˲����ĳ�ȡ
x3 = filter(h,1,x2);       %����FIR�˲�����hΪ�˲���ϵ��
stem(real(x(1:decm:decm*len)));hold on;
stem(real(x3(1:len)),'r.');

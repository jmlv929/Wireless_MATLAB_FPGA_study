l=2;  %����˲����Ĳ�ֵ����
n = 16;     %����˲�������
fp = 0.0001;     %����˲�����ͨ����һ��Ƶ��
r=4;     %CIC�˲����Ĳ�ֵ����
interp1=r*l;   %�ܵĲ�ֵ����
hb1 = halfinterp(n,fp,l,x);        %�����Ӻ���halfinterp���а���˲����Ĳ�ֵ
x1 = CICinterp(r,hb1);            %�����Ӻ���CICinterp����CIC�˲����Ĳ�ֵ
stem(real(x(1:len)));hold on;
stem(real(x3(1:interp1:interp1*len)),'r.');

u = 0.00005;    %��������
n = 64;  %WHT-LMS�ĳ�ͷ��������2����
h = zeros(n ,1);    %��ͷϵ����nΪ��ͷ����
x = zeros(1 ,n);    %�˲�����ͷ����
%% ע�⣺������Ҫ���������ź�xd, �ο��ź�d�����б�������ܵõ���Ӧ����ͼ
e = zeros(n ,1);       %�������
y = zeros(len , 1);  %�����źţ�lenΪ���ݳ���
beita = 0.8;    %
p = zeros(n, 1);   %�źŹ��ʹ���
for i = 1 : len
    x(1,2:end) = x(1,1:end-1);
    x(1,1) = xd(i,1);   %xdΪ�����ź�
    xh = WHT(x, n); %���WHT�任
    p = p*beita + (1-beita)*abs(xh).^2;   %���ʹ���
    y(i) = xh.'*conj(h);       %�����ź�
    e(i) = d(i) - y(i);       %dΪ�ο��ź�
    h = h + 2*u.*conj(e(i))*xh./(p+0.02);   %��ͷϵ������
end
for i=1:len;
    err(i1)=abs(e(i).^2);    %ͳ�ƾ������
end

m = 4;             %ÿ�����ŵı�����
n = 10;             %���ֳ���
k = 8;              %ÿ�������
t = (n-k)/2;         %��ľ�������
nw = 1;            %��������ָ���
x=[0 1 2 3 4 5 6 7];   %������ַ�
msgw = gf(x,4);
c = rsenc(msgw,n,k);  %RS����
noise = (1+randint(nw,n,2^m-1)).*randerr(nw,n,t);  %����ʹ��ÿ�����ַ���t������
cnoisy = c + noise;   %������
%RS���룬dcΪ���������corrcodeΪ��������������
[dc,nerrs,corrcode] = rsdec(cnoisy,n,k);   
isequal(dc,msgw) & isequal(corrcode,c);  %���������Ƿ���ȷ
nerrs                       %���������Ĵ���������

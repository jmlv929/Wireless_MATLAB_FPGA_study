clear;
SNR = [-5:2:10];
NumAntenna =4;   %������Ԫ��
Tlen = 1000;    %ѵ�����г���
Dlen = 20000;   %���ݳ���
step = 0.0001;    %����
alfa = pi/3;           %���﷽��
theta = pi/2;

for nEN = 1:length(SNR)
    numoerror1=0;
    numoerror2=0;
    w = zeros(1,NumAntenna)';
    w(1)=1;
    d = randsrc(1,Tlen+Dlen); %����ѵ������
    en = 10^(SNR(nEN)/10);
    sigma = sqrt((1/(2*en)));
    m = [1:NumAntenna];
    a = exp(-i*2*pi*(m-1)*cos(alfa)*sin(theta));  %������������
    rd1 = d.'*a;
    rd2=awgn(rd1,SNR(nEN),'measured');
    for n = 1:Tlen
        u=rd2(n,:).';
        r(n) = w'*u/NumAntenna;        %������Ԫ���
        w = w-step*u*conj(r(n)-d(n));      %����LMS�㷨�����¼�Ȩ����
    end
    %��������
    for n = Tlen+1:Tlen+Dlen
        u=rd2(n,:).';
        r(n) = w'*u/NumAntenna;
    end
    %�������������ߣ�ֱ�ӽ���
    s = awgn(d(Tlen+1:end),SNR(nEN),'measured');
    for n=1:Dlen
        s1(n)=sign(real(s(n)));
        ds(n)=sign(real(r(n+Tlen)));
        s_data(n)=d(n+Tlen);
    end
    %ͳ��������
    numoerror1=sum(s1~=s_data);
    numoerror2=sum(ds~=s_data);
    ber1(nEN) = numoerror1/Dlen;
    ber2(nEN) = numoerror2/Dlen;
end
figure;semilogy(SNR,ber1);hold on;
semilogy(SNR,ber2,'*-');
xlabel('�����');
ylabel('�������');

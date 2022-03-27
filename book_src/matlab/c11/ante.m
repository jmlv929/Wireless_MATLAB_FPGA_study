clear;
SNR = [-5:2:10];
NumAntenna =4;   %天线阵元数
Tlen = 1000;    %训练序列长度
Dlen = 20000;   %数据长度
step = 0.0001;    %步长
alfa = pi/3;           %波达方向
theta = pi/2;

for nEN = 1:length(SNR)
    numoerror1=0;
    numoerror2=0;
    w = zeros(1,NumAntenna)';
    w(1)=1;
    d = randsrc(1,Tlen+Dlen); %产生训练序列
    en = 10^(SNR(nEN)/10);
    sigma = sqrt((1/(2*en)));
    m = [1:NumAntenna];
    a = exp(-i*2*pi*(m-1)*cos(alfa)*sin(theta));  %产生引导向量
    rd1 = d.'*a;
    rd2=awgn(rd1,SNR(nEN),'measured');
    for n = 1:Tlen
        u=rd2(n,:).';
        r(n) = w'*u/NumAntenna;        %天线阵元输出
        w = w-step*u*conj(r(n)-d(n));      %利用LMS算法，更新加权因子
    end
    %接收数据
    for n = Tlen+1:Tlen+Dlen
        u=rd2(n,:).';
        r(n) = w'*u/NumAntenna;
    end
    %不利用智能天线，直接接收
    s = awgn(d(Tlen+1:end),SNR(nEN),'measured');
    for n=1:Dlen
        s1(n)=sign(real(s(n)));
        ds(n)=sign(real(r(n+Tlen)));
        s_data(n)=d(n+Tlen);
    end
    %统计误码率
    numoerror1=sum(s1~=s_data);
    numoerror2=sum(ds~=s_data);
    ber1(nEN) = numoerror1/Dlen;
    ber2(nEN) = numoerror2/Dlen;
end
figure;semilogy(SNR,ber1);hold on;
semilogy(SNR,ber2,'*-');
xlabel('信噪比');
ylabel('误比特率');

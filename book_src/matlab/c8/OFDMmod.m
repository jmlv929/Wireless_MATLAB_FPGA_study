clear
clc
c=6;         % ���ز�����
bits=4000;      % ÿ���ŵ��ı�����
n=c*bits;       % �ܵĴ��ͱ�����
data= 2*round(rand(1,n))-1;     %������Դ����
s = reshape(data,c,bits);        % �����任
tp=1:0.1:(1+bits/10)-0.1;
for i=1:c
    carrier(i,:)=cos(2*i*pi*tp); % �����ز��ź�
    bpsk_sig(i,:)=s(i,:).*carrier(i,:); % ���������ź�
    fin(i,:)=ifft(bpsk_sig(i,:));  %���źŽ���ifft
end
%�����任
transmit=reshape(fin,1,n);
%������
snr=[-5:2:16];
for t=1:length(snr)
    rxdata=awgn(transmit,snr(t),'measured');
    %�����任
    rec=reshape(rxdata,c,bits);
    for i=1:c
        rxdataf(i,:)=fft(rec(i,:));  %����FFT����
        uncarry(i,:)=rxdataf(i,:).*carrier(i,:); %���
    end
    rdata=sign(real(uncarry));
    num(t)=biterr(rdata+1,s+1)/n;
end

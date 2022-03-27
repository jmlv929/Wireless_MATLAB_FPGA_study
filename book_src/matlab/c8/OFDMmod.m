clear
clc
c=6;         % 子载波个数
bits=4000;      % 每个信道的比特数
n=c*bits;       % 总的传送比特数
data= 2*round(rand(1,n))-1;     %产生信源数据
s = reshape(data,c,bits);        % 串并变换
tp=1:0.1:(1+bits/10)-0.1;
for i=1:c
    carrier(i,:)=cos(2*i*pi*tp); % 产生载波信号
    bpsk_sig(i,:)=s(i,:).*carrier(i,:); % 产生调制信号
    fin(i,:)=ifft(bpsk_sig(i,:));  %对信号进行ifft
end
%并串变换
transmit=reshape(fin,1,n);
%加噪声
snr=[-5:2:16];
for t=1:length(snr)
    rxdata=awgn(transmit,snr(t),'measured');
    %并串变换
    rec=reshape(rxdata,c,bits);
    for i=1:c
        rxdataf(i,:)=fft(rec(i,:));  %进行FFT处理
        uncarry(i,:)=rxdataf(i,:).*carrier(i,:); %解调
    end
    rdata=sign(real(uncarry));
    num(t)=biterr(rdata+1,s+1)/n;
end

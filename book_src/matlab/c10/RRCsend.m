function dataout=RRCsend(datain,Fs,nsamp,delay); 
num =rcosine(Fs,Fs*nsamp,'fir/sqrt',0.22,delay); %�˲�����ͷϵ��
dataoutr=rcosflt(real(datain),Fs,Fs*nsamp,'filter',num);
dataouti=rcosflt(imag(datain),Fs,Fs*nsamp,'filter',num);
dataout=(dataoutr+j*dataouti).';

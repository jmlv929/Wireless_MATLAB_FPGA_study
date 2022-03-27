function dataout=RRCrece(datain,Fs,nsamp,delay,carriers);
num = rcosine(Fs,Fs*nsamp,'fir/sqrt',0.22,delay); %ÂË²¨Æ÷³éÍ·ÏµÊı
dataoutr=rcosflt(real(datain),Fs,Fs*nsamp,'Fs/filter',num);
dataouti=rcosflt(imag(datain),Fs,Fs*nsamp,'Fs/filter',num);
dataout=(dataoutr+j*dataouti).';

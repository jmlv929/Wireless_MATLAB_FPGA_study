msg=[1 1 1 0 0 0 1 1 ];           %信息序列
poly=[1 1 0 0 1 1];              %生成多项式
[M N]=size(poly);              %生成多项式大小
mseg=[msg zeros(1,N-1)]     %存放加了CRC的序列
[q r]=deconv(mseg,poly);   %q为商，r为余数
r= mod(abs(r),2);   %进行模2处理
crc=r(length(msg)+1:end);   %crc校验码
frame = bitor(mseg,r);   %最后发送的序列
%frame(1)=1-frame(1);
%接收端处理
[qt rt]=deconv(frame,poly);    %将接收到的序列除以多项式
rt=mod(abs(rt),2);   %进行模2处理，得到信息序列

msg=[1 1 1 0 0 0 1 1 ];           %��Ϣ����
poly=[1 1 0 0 1 1];              %���ɶ���ʽ
[M N]=size(poly);              %���ɶ���ʽ��С
mseg=[msg zeros(1,N-1)]     %��ż���CRC������
[q r]=deconv(mseg,poly);   %qΪ�̣�rΪ����
r= mod(abs(r),2);   %����ģ2����
crc=r(length(msg)+1:end);   %crcУ����
frame = bitor(mseg,r);   %����͵�����
%frame(1)=1-frame(1);
%���ն˴���
[qt rt]=deconv(frame,poly);    %�����յ������г��Զ���ʽ
rt=mod(abs(rt),2);   %����ģ2�����õ���Ϣ����

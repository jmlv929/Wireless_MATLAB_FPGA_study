M=512;     %�˲�������
L=M;      %ÿ�����ݿ�ĳ���
N=2*M;    %FFT�ĳ���
%% ��Ҫ���u, y,d,e�����ݣ��ó�����ܸ���������11.4��LMS�㷨�ķ���ͼ
w=zeros(1,M);
wf=fft([w,zeros(1,M)]);       %Ƶ��ĳ�ͷϵ��
for k=0:blocknum-1;         %blocknumΪ���ݿ�ĸ���
    if(k==0)
        uf=fft([zeros(1,M),u(k*M+1:k*M+M)]);     %uΪ�����źţ������ص�������
    else
        uf=fft([u(k*M-M+1:k*M),u(k*M+1:k*M+M)]);
    end
    ytemp=ifft(uf.*wf);
    y(k*M+1:k*M+M)=ytemp(M+1:2*M);    %ȡ�����M��Ԫ��
    e(1,k*M+1:k*M+M)=y(k*M+1:k*M+M)-d(k*M+1:k*M+M);    %dΪ�ο�����
    error(1,1:M)=e(1,k*M+1:k*M+M);
    ef=fft([zeros(1,M),error]);
    corrtemp=ifft(ef.*conj(uf));
    corr=corrtemp(1:M);%ȡǰ���M��Ԫ��
    wf=wf+step*fft([corr,zeros(1,M)]);
end

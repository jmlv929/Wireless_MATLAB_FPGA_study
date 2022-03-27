M=512;     %滤波器长度
L=M;      %每个数据块的长度
N=2*M;    %FFT的长度
%% 需要添加u, y,d,e等数据，该程序就能给出类似于11.4节LMS算法的仿真图
w=zeros(1,M);
wf=fft([w,zeros(1,M)]);       %频域的抽头系数
for k=0:blocknum-1;         %blocknum为数据块的个数
    if(k==0)
        uf=fft([zeros(1,M),u(k*M+1:k*M+M)]);     %u为输入信号，进行重叠保留法
    else
        uf=fft([u(k*M-M+1:k*M),u(k*M+1:k*M+M)]);
    end
    ytemp=ifft(uf.*wf);
    y(k*M+1:k*M+M)=ytemp(M+1:2*M);    %取后面的M个元素
    e(1,k*M+1:k*M+M)=y(k*M+1:k*M+M)-d(k*M+1:k*M+M);    %d为参考数据
    error(1,1:M)=e(1,k*M+1:k*M+M);
    ef=fft([zeros(1,M),error]);
    corrtemp=ifft(ef.*conj(uf));
    corr=corrtemp(1:M);%取前面的M个元素
    wf=wf+step*fft([corr,zeros(1,M)]);
end

len=20000;
%假设用前2000个数据作为均衡器的训练数据
Tlen=2000;
step=0.001;
N=64;   %均衡器抽头个数
s=zeros(1,len);
s1=zeros(1,len);
x=zeros(1,N);
w=zeros(1,N);
s=randsrc(1,len);   %信源
s1(2:len)=s(1:len-1);   %第二径
p=0.9;
SNR=[0:10];
for db=1:length(SNR)
    s2=sqrt(p)*s+sqrt(1-p)*s1;
    s3=awgn(s2,db,'measured');
    for i=N:len
        u(1:N)=s3(i:-1:i-N+1); 
        y(i)=u*conj(w.');
        e(i)=u*w'-conj(s(i));
        w=w-step*u*(e(i));
        if y(i)>0   %有均衡器的判决输出
            y1(i)=1;
        else y1(i)=-1;
        end
        if s3(i)>0    %无均衡器的判决输出
            y2(i)=1;
        else y2(i)=-1;
        end
    end
 
    errornum1=sum(y1(Tlen:end)~=s(Tlen:end));    errornum2=sum(y2(Tlen:end)~=s(Tlen:end));
    ber1(db)=errornum1/(len-Tlen);    
    ber2(db)=errornum2/(len-Tlen);    
end
semilogy(SNR,ber1,'+-');hold on;
semilogy(SNR,ber2);

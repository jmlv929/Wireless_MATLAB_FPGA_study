Numusers=1;
Nc=16;  %扩频因子
ISI_Length=1; %每径延时为ISI_Length/2
EbN0db = [0:2:10];
Tlen=5000;%数据长度
Bit_Error_Number1=0;%误比特率的初始值
Bit_Error_Number2=0;
Bit_Error_Number3=0;
power_unitary_factor1=sqrt(5/9);%每径功率因子
power_unitary_factor2=sqrt(3/9);
power_unitary_factor3=sqrt(1/9);
s_initial=randsrc(1,Tlen);%数据源
%产生Walsh 矩阵                     
Wal2=[1 1;1 -1];
Wal4=[Wal2 Wal2;Wal2 Wal2*(-1)];
Wal8=[Wal4 Wal4;Wal4 Wal4*(-1)];
Wal16=[Wal8 Wal8;Wal8 Wal8*(-1)];
%扩频
s_spread=zeros(Numusers,Tlen*Nc);
ray1=zeros(Numusers,2*Tlen*Nc);
ray2=zeros(Numusers,2*Tlen*Nc);
ray3=zeros(Numusers,2*Tlen*Nc);
for i=1:Numusers
    x0=s_initial(i,:).'*Wal16(8,:);
    x1=x0.';
    s_Spread(i,:)=(x1(:)).';
end
%将每个扩频后输出重复为两次，有利于下面的延迟（延迟了半个码元）
ray1(1:2:2*Tlen*Nc-1)=s_Spread(1:Tlen*Nc); 
ray1(2:2:2*Tlen*Nc)=ray1(1:2:2*Tlen*Nc-1);

%产生第二径和第三径信号
ray2(ISI_Length+1:2*Tlen*Nc)=ray1(1:2*Tlen*Nc-ISI_Length);
ray3(2*ISI_Length+1:2*Tlen*Nc)=ray1(1:2*Tlen*Nc-2*ISI_Length);

for nEN = 1:length(EbN0db)
    en = 10^(EbN0db(nEN)/10);      % convert Eb/N0 from unit db to normal numbers
    sigma = sqrt((32/(2*en)));
    %接收到的信号demp
    demp=power_unitary_factor1*ray1+power_unitary_factor2*ray2+power_unitary_factor3*ray3+(randn(1,2*Tlen*Nc)+randn(1,2*Tlen*Nc)*i)*sigma;
    dt=reshape(demp,32,Tlen)';
    %将Walsh码重复为两次
    Wal16_d(1:2:31)=Wal16(8,1:16);
    Wal16_d(2:2:32)=Wal16(8,1:16);
    %解扩后rdata1为第一径输出
    rdata1=dt*Wal16_d(1,:).';
    %将Walsh码延迟半个码片
    Wal16_delay1(1,2:32)=Wal16_d(1,1:31);
    %解扩后rdata2为第二径输出
    rdata2=dt*Wal16_delay1(1,:).';
    %将Walsh码延迟一个码片
    Wal16_delay2(1,3:32)=Wal16_d(1,1:30);
    Wal16_delay2(1,1:2)=Wal16_d(1,31:32);
    %解扩后rdata3为第三径输出
    rdata3=dt*Wal16_delay2(1,:).';
    p1=rdata1'*rdata1;
    p2=rdata2'*rdata2;
    p3=rdata3'*rdata3;
    p=p1+p2+p3;
    u1=p1/p;
    u2=p2/p;
    u3=p3/p;
    %最大值合并
    rd_m1=real(rdata1*u1+rdata2*u2+rdata3*u3);
    %等增益合并
    rd_m2=(real(rdata1+rdata2+rdata3))/3;
    %选择式合并
    u=[u1,u2,u3];
    maxu=max(u);
    if(maxu==u1)
        rd_m3=real(rdata1);
    else if(maxu==u2)
            rd_m3=real(rdata2);
        else rd_m3=real(rdata3);
        end
    end
    %三种方法判决输出
    r_Data1=sign(rd_m1)';
    r_Data2=sign(rd_m2)';
    r_Data3=sign(rd_m3)';
    %计算误比特率
    Bit_Error_Number1=length(find(r_Data1(1:Tlen)~=s_initial(1:Tlen)));
    Bit_Error_Rate1(nEN)=Bit_Error_Number1/(Tlen);
    Bit_Error_Number2=length(find(r_Data2(1:Tlen)~=s_initial(1:Tlen)));
    Bit_Error_Rate2(nEN)=Bit_Error_Number2/(Tlen);
    Bit_Error_Number3=length(find(r_Data3(1:Tlen)~=s_initial(1:Tlen)));
    Bit_Error_Rate3(nEN)=Bit_Error_Number3/(Tlen);     
end
semilogy(EbN0db,Bit_Error_Rate1,'*-');hold on;
semilogy(EbN0db,Bit_Error_Rate2,'o-'); hold on;
semilogy(EbN0db,Bit_Error_Rate3,'+-');
legend('最大比合并','等增益合并','选择式合并');
xlabel('信噪比');
ylabel('误比特率');
title('3种主要分集合并方式性能比较');

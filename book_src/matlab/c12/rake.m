Numusers=1;
Nc=16;  %��Ƶ����
ISI_Length=1; %ÿ����ʱΪISI_Length/2
EbN0db = [0:2:10];
Tlen=5000;%���ݳ���
Bit_Error_Number1=0;%������ʵĳ�ʼֵ
Bit_Error_Number2=0;
Bit_Error_Number3=0;
power_unitary_factor1=sqrt(5/9);%ÿ����������
power_unitary_factor2=sqrt(3/9);
power_unitary_factor3=sqrt(1/9);
s_initial=randsrc(1,Tlen);%����Դ
%����Walsh ����                     
Wal2=[1 1;1 -1];
Wal4=[Wal2 Wal2;Wal2 Wal2*(-1)];
Wal8=[Wal4 Wal4;Wal4 Wal4*(-1)];
Wal16=[Wal8 Wal8;Wal8 Wal8*(-1)];
%��Ƶ
s_spread=zeros(Numusers,Tlen*Nc);
ray1=zeros(Numusers,2*Tlen*Nc);
ray2=zeros(Numusers,2*Tlen*Nc);
ray3=zeros(Numusers,2*Tlen*Nc);
for i=1:Numusers
    x0=s_initial(i,:).'*Wal16(8,:);
    x1=x0.';
    s_Spread(i,:)=(x1(:)).';
end
%��ÿ����Ƶ������ظ�Ϊ���Σ�������������ӳ٣��ӳ��˰����Ԫ��
ray1(1:2:2*Tlen*Nc-1)=s_Spread(1:Tlen*Nc); 
ray1(2:2:2*Tlen*Nc)=ray1(1:2:2*Tlen*Nc-1);

%�����ڶ����͵������ź�
ray2(ISI_Length+1:2*Tlen*Nc)=ray1(1:2*Tlen*Nc-ISI_Length);
ray3(2*ISI_Length+1:2*Tlen*Nc)=ray1(1:2*Tlen*Nc-2*ISI_Length);

for nEN = 1:length(EbN0db)
    en = 10^(EbN0db(nEN)/10);      % convert Eb/N0 from unit db to normal numbers
    sigma = sqrt((32/(2*en)));
    %���յ����ź�demp
    demp=power_unitary_factor1*ray1+power_unitary_factor2*ray2+power_unitary_factor3*ray3+(randn(1,2*Tlen*Nc)+randn(1,2*Tlen*Nc)*i)*sigma;
    dt=reshape(demp,32,Tlen)';
    %��Walsh���ظ�Ϊ����
    Wal16_d(1:2:31)=Wal16(8,1:16);
    Wal16_d(2:2:32)=Wal16(8,1:16);
    %������rdata1Ϊ��һ�����
    rdata1=dt*Wal16_d(1,:).';
    %��Walsh���ӳٰ����Ƭ
    Wal16_delay1(1,2:32)=Wal16_d(1,1:31);
    %������rdata2Ϊ�ڶ������
    rdata2=dt*Wal16_delay1(1,:).';
    %��Walsh���ӳ�һ����Ƭ
    Wal16_delay2(1,3:32)=Wal16_d(1,1:30);
    Wal16_delay2(1,1:2)=Wal16_d(1,31:32);
    %������rdata3Ϊ���������
    rdata3=dt*Wal16_delay2(1,:).';
    p1=rdata1'*rdata1;
    p2=rdata2'*rdata2;
    p3=rdata3'*rdata3;
    p=p1+p2+p3;
    u1=p1/p;
    u2=p2/p;
    u3=p3/p;
    %���ֵ�ϲ�
    rd_m1=real(rdata1*u1+rdata2*u2+rdata3*u3);
    %������ϲ�
    rd_m2=(real(rdata1+rdata2+rdata3))/3;
    %ѡ��ʽ�ϲ�
    u=[u1,u2,u3];
    maxu=max(u);
    if(maxu==u1)
        rd_m3=real(rdata1);
    else if(maxu==u2)
            rd_m3=real(rdata2);
        else rd_m3=real(rdata3);
        end
    end
    %���ַ����о����
    r_Data1=sign(rd_m1)';
    r_Data2=sign(rd_m2)';
    r_Data3=sign(rd_m3)';
    %�����������
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
legend('���Ⱥϲ�','������ϲ�','ѡ��ʽ�ϲ�');
xlabel('�����');
ylabel('�������');
title('3����Ҫ�ּ��ϲ���ʽ���ܱȽ�');

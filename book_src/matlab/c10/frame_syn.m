len=100;   %ÿ֡�����ݳ���
n=3;    %���з����֡��
c=[1 1 1 -1 -1 1 -1];    %�Ϳ���
for i=1:n
    s(i,:)=randsrc(1,len);   %����ÿ�ܵ���Դ����
end
r=[c s(1,:) c s(2,:) c s(3,:)];         %���Ϳ��������Դ������
thr=6;       %�о����ޣ������ֵ����ʵ��ϵͳ�н��е���
out=zeros(1,length(r));
num=[];      %������ܵ�֡ͷ
for i=7:n*len+n*7
    out(i)=sum(r(i-6:i).*c);    %ÿ7�����ݽ���һ��������
    if(out(i)>thr)           %�ж�������ֵ�Ƿ��������
        num=[num i];         %���������޵�λ�ý��д���
    end
end 
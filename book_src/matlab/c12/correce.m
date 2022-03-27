n = 128;   %���������Ľ���
n1 = log2(n);
W = zeros(n,n);
W(1,1) = 1;
for t = 1 : n1  %�������������
    for i = 1 : n
        for j = 1 : n
            if (i <= 2^(t-1) && j <= 2^(t-1))
                W(i ,j) = W(i ,j);
            elseif (i <= 2^(t-1) && j > 2^(t-1))
                W(i ,j) = W (i , j-2^(t-1));
            elseif (i > 2^(t-1) && j <= 2^(t-1))
                W(i ,j) = W (i-2^(t-1) , j);
            else
                W(i ,j) = -W (i-2^(t-1) , j-2^(t-1));
            end     
        end
    end   
end
x=randint(1,n);       %��������
t=10;   %��������û���Ϊ���������ĵ�t��
s=W(t,:).*x;     %�������͵�����
snr=-10;          %�����
enn = 10^(snr/10);      
sigman = sqrt(var(s)/(2*enn));        %��������
x_noise = zeros(1,n);
x_noise = sigman*(randn(1,n));          %��������
r = x_noise + s;          %�����ź�
for i=1:n
   v(i)=sum(r.*W(i,:));            %��ؽ��ջ�����
end
num=find(v==max(v));           %�ҵ����ֵ����Ӧ���ֶ�ʲ��
    
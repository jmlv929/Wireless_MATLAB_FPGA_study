function y = WHT(x_in, n)
% x ����������������
% n ��Walsh-Hardma�任�ĵ�����������2���ݴη�
% alpha ���ص����������ӣ������ǵķ�����alpha = 2
% y �������
% alpha=2;

alpha=2;

% �ж��������n
n1 = log2(n);
n2 = mod(n1,1);
if (n2 ~= 0)
    error('wht.mģ����������n������2���ݴη�');
end 

% ��������Ӧ����һ��������
% �ж���������x������������������
[a , b] = size(x_in);
if (a>1)
    x = x_in;
else
    x = x_in.'; % ע��.'��ת�ã�'�ǹ���ת��
end

y = zeros(length(x),1);

%% ����[n*2n]��Walsh-Hardma�任����
% [n*n]��Walsh-Hardma�任����
W = zeros(n,n);
W(1,1) = 1;
for t = 1 : n1  % t �ı�ǵ�λ��log2(n)
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
% ����[n*2n]��Walsh-Hardma�任����
W1 = zeros(n,2*n);
for i1 = 1 : n
    W1(i1,1:n) = W(i1,:);
    W1(i1,n+1:2*n) = W(i1,:);   
end

%% ���ɱ任���� x1 
len = n*2;
x1 = zeros(len, 1);

tlen = length(x) / n;

for i = 1:tlen
    if (i == 1)
        for i1 = 1 : n/2
            x1(i1, 1) = 0;
        end
        x1(n/2+1:1.5*n,1) = x((i-1)*n+1:i*n,1);
        x1((1.5*n+1):2*n,1) = x((i*n+1):(i*n+0.5*n),1);
    elseif (i < tlen )
        x1(1:2*n) = x((i-1)*n+1-n/2:i*n+n/2,1);
    else
        x1(1:1.5*n) = x((i-1)*n+1-n/2:i*n,1);
        for i1 = 1.5*n+1 : 2*n
            x1(i1, 1) = 0;
        end
    end
    		y((i-1)*n+1:i*n,1) = W1*x1;        
end

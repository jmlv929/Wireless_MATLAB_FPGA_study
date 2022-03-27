st1 = 27221; st2 = 4831;    %���������������״̬
n = 7; k = 4;              %������Ĳ���
msg = randint(k*500,1,2,st1);   %��Ϣ����
code = encode(msg,n,k,'hamming/binary');  %����
%����ͻ������ʹ���������ַ�������
errors = zeros(size(code)); errors(n-2:n+3) = [1 1 1 1 1 1];

inter = randintrlv(code,st2);     %��֯
inter_err = bitxor(inter,errors);   %����ͻ������
deinter = randdeintrlv(inter_err,st2);   %�⽻֯
decoded = decode(deinter,n,k,'hamming/binary');  %����
disp('Number of errors and error rate, with interleaving:');
[number_with,rate_with] = biterr(msg,decoded);   %��������

%û�н�֯
code_err = bitxor(code,errors);          %����ͻ������
decoded = decode(code_err,n,k,'hamming/binary');    %����
disp('Number of errors and error rate, without interleaving:');
[number_without,rate_without] = biterr(msg,decoded)   %��������

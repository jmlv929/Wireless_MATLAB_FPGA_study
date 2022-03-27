st1 = 27221; st2 = 4831;    %定义随机数产生的状态
n = 7; k = 4;              %汉明码的参数
msg = randint(k*500,1,2,st1);   %信息序列
code = encode(msg,n,k,'hamming/binary');  %编码
%产生突发错误，使得相邻码字发生错误
errors = zeros(size(code)); errors(n-2:n+3) = [1 1 1 1 1 1];

inter = randintrlv(code,st2);     %交织
inter_err = bitxor(inter,errors);   %加入突发错误
deinter = randdeintrlv(inter_err,st2);   %解交织
decoded = decode(deinter,n,k,'hamming/binary');  %译码
disp('Number of errors and error rate, with interleaving:');
[number_with,rate_with] = biterr(msg,decoded);   %误码数据

%没有交织
code_err = bitxor(code,errors);          %加入突发错误
decoded = decode(code_err,n,k,'hamming/binary');    %译码
disp('Number of errors and error rate, without interleaving:');
[number_without,rate_without] = biterr(msg,decoded)   %误码数据

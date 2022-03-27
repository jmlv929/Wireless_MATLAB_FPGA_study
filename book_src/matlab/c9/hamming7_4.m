n = 7;            %码长
k = 4;            %信息位长
A = [ 1 1 1;1 1 0;1 0 1;0 1 1 ];           
G = [ eye(k) A ];    %生成矩阵
H = [ A' eye(n-k) ];  %校验矩阵
%编码
msg = [ 1 1 1 1 ];       %信息比特
code = mod(msg*G,2);  %进行编码
%在信道传输中出现错误，任意取一个码字发生错误，这里取第二个码字发生错误
code(2)= ~code(2); %code(1)= ~code(1);code(3)= ~code(3);code(4)= ~code(4);
%code(5)= ~code(5);code(6)= ~code(6);code(7)= ~code(7);
recd = code;                  %接收信号
syndrome = mod(recd * H',2);    %译码
%寻找错误码字的位置
find = 0;
for ii = 1:n
    if ~find
        errvect = zeros(1,n);
        errvect(ii) = 1;
        search = mod(errvect * H',2);
        if search == syndrome
            find = 1;
            index = ii;   %index指示错误码字位置
        end
    end
end
correctedcode = recd;
correctedcode(index) = mod(recd(index)+1,2);        %纠正错误
msg_decoded=correctedcode;
msg_decoded=msg_decoded(1:4);                  %去除校验码

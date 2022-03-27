function y = rsc_encode(g, x, end1)
%x为输入序列，g为卷积码的生成多项式，y为编码后输出
%endl尾比特处理标志，如end1>0，有m个尾比特，编码至x最后一个比特到达最后一个寄存器；如end1<0，没有尾比特，编码至x最后一个比特进入编码器。
% K为约束长度，m为寄存器个数，码率为1/n
[n,K] = size(g);
m = K - 1;
if end1>0  %由endl决定编码输出
  L_info = length(x);
  L_total = L_info + m;
else
  L_total = length(x);
  L_info = L_total - m;
end  
%初始化状态向量
state = zeros(1,m); 
%产生码字
for i = 1:L_total
   if end1<0 | (end1>0 & i<=L_info)
      d_k = x(1,i);
   elseif end1>0 & i>L_info
      d_k = rem( g(1,2:K)*state', 2 );      %尾比特处理
   end
 
   a_k = rem( g(1,:)*[d_k state]', 2 );
   % a_k是编码器的第一个寄存器输入
   [output_bits, state] = encode_bit(g, a_k, state);  %进行编码，
   output_bits(1,1) = d_k;   %编码比特的第一位是信息位
   y(n*(i-1)+1:n*i) = output_bits;   %编码比特：信息位，校验位1，校验位2，…，校验位%n-1，信息位，……
end

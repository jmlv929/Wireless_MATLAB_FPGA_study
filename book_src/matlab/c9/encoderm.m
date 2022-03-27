function en_output = encoderm(x, g, alpha, puncture)
%x为待编码序列，g为生成多项式，alpha为交织映射表；
%如删余系数puncture = 1，则turbo码不删余，码率为1/3。如puncture = 0，则turbo码删余，码率为1/2。删余时，校验器选择RSC1的奇数位，RSC2的偶数位
%根据生成矩阵决定附加的尾比特数，编码器的寄存器数。K为约束长度，m为寄存器个数
[n,K] = size(g); 
m = K - 1;
L_info = length(x); 
L_total = L_info + m;  
%产生RSC1的码字
input = x;
output1 = rsc_encode(g,input,puncture);
y(1,:) = output1(1:2:2*L_total);  %将编码输出进行处理，y(1,:)为信息位
y(2,:) = output1(2:2:2*L_total);  % y(2,:)为校验位
%对信息位进行交织送入第二个编码器
for i = 1:L_info
   input1(1,i) = y(1,alpha(i)); 
end
output2 = rsc_encode(g, input1(1,1:L_info),puncture);
y(3,:) = output2(1:2:2*L_total);    %交织后的信息比特及其尾比特
y(4,:) = output2(2:2:2*L_total);    %交织后的信息比特编码后的校验比特及其尾比特
 
if puncture > 0     %不删余
   for i = 1:L_total
       for j = 1:3
           en_output(1,3*(i-1)+j) = y(j,i);
       end
   end
else            % 删余
   for i=1:L_total
       en_output(1,n*(i-1)+1) = y(1,i);
       if rem(i,2)
      % RSC1的奇数位
          en_output(1,n*i) = y(2,i);
       else
      %RSC2的偶数位
          en_output(1,n*i) = y(3,i);
       end 
    end  
end
%调制成+1/-1后，并行输出
en_output = 2 * y - ones(size(y));

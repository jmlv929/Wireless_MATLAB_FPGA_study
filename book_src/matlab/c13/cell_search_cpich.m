function y = cell_search_cpich(x, code_number);
% 用于WCDMA小区搜索的第三步,主扰码搜寻,函数返回主扰码的码号
% code_number的值为[0，63]；
if(code_number > 63 || code_number<0)
   error('基本扰码组的编号介于[0，63]，请重新输入');
end
lenframe = 2;
x_data=x(1:38400*lenframe);%取出两帧数据已足够
value = zeros(1, 8); %记录8路并行的累加器
% 调用8路扰码
t = [1:8];
yn = code_number*128 + (t-1)*16; %计算码组中的主扰码号
scramb1 = scramble(yn(1), lenframe);
scramb2 = scramble(yn(2), lenframe);
scramb3 = scramble(yn(3), lenframe);
scramb4 = scramble(yn(4), lenframe);
scramb5 = scramble(yn(5), lenframe);
scramb6 = scramble(yn(6), lenframe);
scramb7 = scramble(yn(7), lenframe);
scramb8 = scramble(yn(8), lenframe);
% 解扰
descramb1 = x_data.*conj(scramb1);
descramb2 = x_data.*conj(scramb2);
descramb3 = x_data.*conj(scramb3);
descramb4 = x_data.*conj(scramb4);
descramb5 = x_data.*conj(scramb5);
descramb6 = x_data.*conj(scramb6);
descramb7 = x_data.*conj(scramb7);
descramb8 = x_data.*conj(scramb8);
%累加
for i1=1:38400*lenframe
    value(1,1) = value(1,1) + descramb1(i1);
    value(1,2) = value(1,2) + descramb2(i1);
    value(1,3) = value(1,3) + descramb3(i1);
    value(1,4) = value(1,4) + descramb4(i1);
    value(1,5) = value(1,5) + descramb5(i1);
    value(1,6) = value(1,6) + descramb6(i1);
    value(1,7) = value(1,7) + descramb7(i1);
    value(1,8) = value(1,8) + descramb8(i1);
end
% 判决,并输出主绕码
[p_v, p_num] = max(abs(value)); 
% 返回扰码组号
y = code_number*128 + (p_num-1)*16;

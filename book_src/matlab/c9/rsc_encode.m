function y = rsc_encode(g, x, end1)
%xΪ�������У�gΪ���������ɶ���ʽ��yΪ��������
%endlβ���ش����־����end1>0����m��β���أ�������x���һ�����ص������һ���Ĵ�������end1<0��û��β���أ�������x���һ�����ؽ����������
% KΪԼ�����ȣ�mΪ�Ĵ�������������Ϊ1/n
[n,K] = size(g);
m = K - 1;
if end1>0  %��endl�����������
  L_info = length(x);
  L_total = L_info + m;
else
  L_total = length(x);
  L_info = L_total - m;
end  
%��ʼ��״̬����
state = zeros(1,m); 
%��������
for i = 1:L_total
   if end1<0 | (end1>0 & i<=L_info)
      d_k = x(1,i);
   elseif end1>0 & i>L_info
      d_k = rem( g(1,2:K)*state', 2 );      %β���ش���
   end
 
   a_k = rem( g(1,:)*[d_k state]', 2 );
   % a_k�Ǳ������ĵ�һ���Ĵ�������
   [output_bits, state] = encode_bit(g, a_k, state);  %���б��룬
   output_bits(1,1) = d_k;   %������صĵ�һλ����Ϣλ
   y(n*(i-1)+1:n*i) = output_bits;   %������أ���Ϣλ��У��λ1��У��λ2������У��λ%n-1����Ϣλ������
end

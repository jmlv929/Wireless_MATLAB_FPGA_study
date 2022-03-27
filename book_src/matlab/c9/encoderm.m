function en_output = encoderm(x, g, alpha, puncture)
%xΪ���������У�gΪ���ɶ���ʽ��alphaΪ��֯ӳ���
%��ɾ��ϵ��puncture = 1����turbo�벻ɾ�࣬����Ϊ1/3����puncture = 0����turbo��ɾ�࣬����Ϊ1/2��ɾ��ʱ��У����ѡ��RSC1������λ��RSC2��ż��λ
%�������ɾ���������ӵ�β���������������ļĴ�������KΪԼ�����ȣ�mΪ�Ĵ�������
[n,K] = size(g); 
m = K - 1;
L_info = length(x); 
L_total = L_info + m;  
%����RSC1������
input = x;
output1 = rsc_encode(g,input,puncture);
y(1,:) = output1(1:2:2*L_total);  %������������д���y(1,:)Ϊ��Ϣλ
y(2,:) = output1(2:2:2*L_total);  % y(2,:)ΪУ��λ
%����Ϣλ���н�֯����ڶ���������
for i = 1:L_info
   input1(1,i) = y(1,alpha(i)); 
end
output2 = rsc_encode(g, input1(1,1:L_info),puncture);
y(3,:) = output2(1:2:2*L_total);    %��֯�����Ϣ���ؼ���β����
y(4,:) = output2(2:2:2*L_total);    %��֯�����Ϣ���ر�����У����ؼ���β����
 
if puncture > 0     %��ɾ��
   for i = 1:L_total
       for j = 1:3
           en_output(1,3*(i-1)+j) = y(j,i);
       end
   end
else            % ɾ��
   for i=1:L_total
       en_output(1,n*(i-1)+1) = y(1,i);
       if rem(i,2)
      % RSC1������λ
          en_output(1,n*i) = y(2,i);
       else
      %RSC2��ż��λ
          en_output(1,n*i) = y(3,i);
       end 
    end  
end
%���Ƴ�+1/-1�󣬲������
en_output = 2 * y - ones(size(y));

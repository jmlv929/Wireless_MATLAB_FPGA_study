function x=F2T(X)
global dt df t f T N
%xΪʱ���ȡ��ֵʸ����XΪx�ĸ��ϱ任��X��x������ͬ��Ϊ2������
X=[X(N/2+1:N),X(1:N/2)];
x=ifft(X)/dt;
end 

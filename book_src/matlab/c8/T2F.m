function X=T2F(x)
global dt df N t f T
%xΪʱ���ȡ��ֵʸ����XΪx�ĸ��ϱ任��X��x������ͬ,��Ϊ2�����ݡ���
H=fft(x);
X=[H(N/2+1:N),H(1:N/2)]*dt;
end

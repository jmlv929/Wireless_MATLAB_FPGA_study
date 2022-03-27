function out = halfdec(n,fp,l,x)
b = firhalfband(n,fp,'dev');   %����˲���ϵ��
hf = mfilt.firdecim(l,b);     %���ð���˲������һ�������ȡ�˲���
x_real = real(x);
x_imag = imag(x);
out_real = filter(hf,x_real); %ʵ�����鲿�ֱ��˲�
out_imag = filter(hf,x_imag);
out = double(out_real) + j*double(out_imag);

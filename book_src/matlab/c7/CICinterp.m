function out = CICinterp(r,x); 
Hm = mfilt.cicinterp(r);    %ʹ��Ĭ�ϵ�CIC�����Ͳ��ʱ�ӣ��Լ��ֳ�
x_real = real(x);
x_imag = imag(x);
out_real = filter(Hm,x_real); %ʵ�����鲿�ֿ��˲�
out_imag = filter(Hm,x_imag);
outt = (double(out_real) + j*double(out_imag))/gain(Hm);
out=outt*sqrt(var(x)/var(outt));   %ʹ�����������Ĺ�����ͬ�Ա�Ƚ�

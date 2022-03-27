function out = CICinterp(r,x); 
Hm = mfilt.cicinterp(r);    %使用默认的CIC阶数和差分时延，以及字长
x_real = real(x);
x_imag = imag(x);
out_real = filter(Hm,x_real); %实部和虚部分开滤波
out_imag = filter(Hm,x_imag);
outt = (double(out_real) + j*double(out_imag))/gain(Hm);
out=outt*sqrt(var(x)/var(outt));   %使得输入和输出的功率相同以便比较

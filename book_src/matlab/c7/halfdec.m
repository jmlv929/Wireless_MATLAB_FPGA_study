function out = halfdec(n,fp,l,x)
b = firhalfband(n,fp,'dev');   %半带滤波器系数
hf = mfilt.firdecim(l,b);     %利用半带滤波器设计一个多相抽取滤波器
x_real = real(x);
x_imag = imag(x);
out_real = filter(hf,x_real); %实部和虚部分别滤波
out_imag = filter(hf,x_imag);
out = double(out_real) + j*double(out_imag);

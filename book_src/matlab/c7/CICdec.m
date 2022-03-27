function out = CICdec(decf, diffd, numsecs,x,iwl,owl,wlps)
Hd = mfilt.cicdecim(decf, diffd, numsecs,iwl,owl,wlps);  %得到CIC抽取滤波器
Hd.FilterInternals ='SpecifyPrecision';
%改变滤波器中默认的字长数，长度为级数的两倍
Hd.SectionWordLengths =[wlps wlps wlps wlps wlps wlps];  
Hd.SectionFracLengths =[8 8 8 8 8 8];  %改变滤波器中默认的小数部分长度
Hd.InputFracLength = 8;  %改变默认的输入小数部分长度
Hd.OutputFracLength = 8;  %改变默认的输出小数部分长度
x_real = real(x);
x_imag = imag(x);
out_real = filter(Hd,x_real); %实部和虚部分别滤波
out_imag = filter(Hd,x_imag);
%得到CIC的输出，其中对CIC滤波器的增益进行归一化
out = (double(out_real) + j*double(out_imag))/gain(Hd);  

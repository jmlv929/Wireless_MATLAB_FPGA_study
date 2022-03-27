function out = CICdec(decf, diffd, numsecs,x,iwl,owl,wlps)
Hd = mfilt.cicdecim(decf, diffd, numsecs,iwl,owl,wlps);  %�õ�CIC��ȡ�˲���
Hd.FilterInternals ='SpecifyPrecision';
%�ı��˲�����Ĭ�ϵ��ֳ���������Ϊ����������
Hd.SectionWordLengths =[wlps wlps wlps wlps wlps wlps];  
Hd.SectionFracLengths =[8 8 8 8 8 8];  %�ı��˲�����Ĭ�ϵ�С�����ֳ���
Hd.InputFracLength = 8;  %�ı�Ĭ�ϵ�����С�����ֳ���
Hd.OutputFracLength = 8;  %�ı�Ĭ�ϵ����С�����ֳ���
x_real = real(x);
x_imag = imag(x);
out_real = filter(Hd,x_real); %ʵ�����鲿�ֱ��˲�
out_imag = filter(Hd,x_imag);
%�õ�CIC����������ж�CIC�˲�����������й�һ��
out = (double(out_real) + j*double(out_imag))/gain(Hd);  

msg = randint(4000,1,2,139);   %���������
t = poly2trellis(7,[171 133]);   %����trellis
code = convenc(msg,t);     %�������
ncode = awgn(code,6,'measured',244); %������
qcode = quantiz(ncode,[0.001,.1,.3,.5,.7,.9,.999]);     %�����Խ������о�

tblen = 48; delay = tblen;       %�ع��·����
decoded = vitdec(qcode,t,tblen,'cont','soft',3);   %Viterbi����
%�����������
[number,ratio] = biterr(decoded(delay+1:end),msg(1:end-delay))

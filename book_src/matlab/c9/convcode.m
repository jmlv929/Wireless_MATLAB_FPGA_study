msg = randint(4000,1,2,139);   %产生随机数
t = poly2trellis(7,[171 133]);   %定义trellis
code = convenc(msg,t);     %卷积编码
ncode = awgn(code,6,'measured',244); %加噪声
qcode = quantiz(ncode,[0.001,.1,.3,.5,.7,.9,.999]);     %量化以进行软判决

tblen = 48; delay = tblen;       %回归的路径长
decoded = vitdec(qcode,t,tblen,'cont','soft',3);   %Viterbi译码
%计算误比特率
[number,ratio] = biterr(decoded(delay+1:end),msg(1:end-delay))

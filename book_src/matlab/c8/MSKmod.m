numbits = 99;   %每次迭代的比特数
numchans = 2;   %信号的信道数
nsamp = 16;    %每个符号的采样率
num=10;
numerrs = 0; % Number of bit errors seen so far
demod_ini_phase = zeros(1,numchans);  % 调制相位
mod_ini_phase = zeros(1,numchans);    % 解调相位
ini_state = complex(zeros(nsamp,numchans)); % 解调状态

for i = 1 : num
    x = randint(numbits,numchans);   %二进制信号
    [y,phaseout] = mskmod(x,nsamp,[],mod_ini_phase);
    mod_ini_phase = phaseout;    %用于下次MSK调制使用
    [z, phaseout, stateout] =mskdemod(awgn(y,5,'measured'),nsamp,[],demod_ini_phase,ini_state);
    ini_state = stateout;  %用于下次解调使用
    demod_ini_phase = phaseout;   %用于下次解调使用
%统计误比特率
numerrs = numerrs + length(find(x(:,1)~=z(:,1))) + length(find(x(:,2)~=z(:,2)));  
end
ber=numerrs/(numbits*numchans*num);

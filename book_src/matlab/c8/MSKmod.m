numbits = 99;   %ÿ�ε����ı�����
numchans = 2;   %�źŵ��ŵ���
nsamp = 16;    %ÿ�����ŵĲ�����
num=10;
numerrs = 0; % Number of bit errors seen so far
demod_ini_phase = zeros(1,numchans);  % ������λ
mod_ini_phase = zeros(1,numchans);    % �����λ
ini_state = complex(zeros(nsamp,numchans)); % ���״̬

for i = 1 : num
    x = randint(numbits,numchans);   %�������ź�
    [y,phaseout] = mskmod(x,nsamp,[],mod_ini_phase);
    mod_ini_phase = phaseout;    %�����´�MSK����ʹ��
    [z, phaseout, stateout] =mskdemod(awgn(y,5,'measured'),nsamp,[],demod_ini_phase,ini_state);
    ini_state = stateout;  %�����´ν��ʹ��
    demod_ini_phase = phaseout;   %�����´ν��ʹ��
%ͳ���������
numerrs = numerrs + length(find(x(:,1)~=z(:,1))) + length(find(x(:,2)~=z(:,2)));  
end
ber=numerrs/(numbits*numchans*num);

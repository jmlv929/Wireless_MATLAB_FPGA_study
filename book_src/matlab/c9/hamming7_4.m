n = 7;            %�볤
k = 4;            %��Ϣλ��
A = [ 1 1 1;1 1 0;1 0 1;0 1 1 ];           
G = [ eye(k) A ];    %���ɾ���
H = [ A' eye(n-k) ];  %У�����
%����
msg = [ 1 1 1 1 ];       %��Ϣ����
code = mod(msg*G,2);  %���б���
%���ŵ������г��ִ�������ȡһ�����ַ�����������ȡ�ڶ������ַ�������
code(2)= ~code(2); %code(1)= ~code(1);code(3)= ~code(3);code(4)= ~code(4);
%code(5)= ~code(5);code(6)= ~code(6);code(7)= ~code(7);
recd = code;                  %�����ź�
syndrome = mod(recd * H',2);    %����
%Ѱ�Ҵ������ֵ�λ��
find = 0;
for ii = 1:n
    if ~find
        errvect = zeros(1,n);
        errvect(ii) = 1;
        search = mod(errvect * H',2);
        if search == syndrome
            find = 1;
            index = ii;   %indexָʾ��������λ��
        end
    end
end
correctedcode = recd;
correctedcode(index) = mod(recd(index)+1,2);        %��������
msg_decoded=correctedcode;
msg_decoded=msg_decoded(1:4);                  %ȥ��У����

N = 128;    %��ͷ��
Dlen = 1024;  %�������
Step = 0.005; %����
%ע�⣺��Ҫ��������data�Ͳο��ź�s(n)�������б�����
w=zeros(N,1);           %NΪ��ͷ����
p=(1/delta)*eye(N);       %deltaΪ���򻯲���
for n= N:Dlen
    u(1:N)=data(n:-1:n-N+1);  %�˲�������
    v=p*u;
    k=(1/step)*v/(1+(1/step)*u'*v);
    y(n) = w'*u;            %�˲������
    e(n)=s(n)-y(n);
    w=w+k*conj(e(n));
    p=(1/step)*(eye(N)-k*u')*p;
end   

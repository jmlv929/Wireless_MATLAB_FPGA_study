len=100;   %每帧的数据长度
n=3;    %进行仿真的帧数
c=[1 1 1 -1 -1 1 -1];    %巴克码
for i=1:n
    s(i,:)=randsrc(1,len);   %产生每周的信源数据
end
r=[c s(1,:) c s(2,:) c s(3,:)];         %将巴克码插入信源数据中
thr=6;       %判决门限，这个数值可在实际系统中进行调整
out=zeros(1,length(r));
num=[];      %储存可能的帧头
for i=7:n*len+n*7
    out(i)=sum(r(i-6:i).*c);    %每7个数据进行一次相关求和
    if(out(i)>thr)           %判断相关求和值是否大于门限
        num=[num i];         %将大于门限的位置进行储存
    end
end 

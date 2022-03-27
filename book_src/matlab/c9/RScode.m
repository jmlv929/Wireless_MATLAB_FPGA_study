m = 4;             %每个符号的比特数
n = 10;             %码字长度
k = 8;              %每组符号数
t = (n-k)/2;         %码的纠正能力
nw = 1;            %处理的码字个数
x=[0 1 2 3 4 5 6 7];   %输入的字符
msgw = gf(x,4);
c = rsenc(msgw,n,k);  %RS编码
noise = (1+randint(nw,n,2^m-1)).*randerr(nw,n,t);  %噪声使得每组码字发生t个错误
cnoisy = c + noise;   %加噪声
%RS译码，dc为译码后结果，corrcode为纠正错误后的码字
[dc,nerrs,corrcode] = rsdec(cnoisy,n,k);   
isequal(dc,msgw) & isequal(corrcode,c);  %检验译码是否正确
nerrs                       %给出纠正的错误码字数

x = rand(100,1); %输入数据
num = rcosine(1,8,'sqrt'); %滤波器的转移函数 
y1 = rcosflt(x,1,8,'filter',num); %在发端对数据进行滤波
z1 = rcosflt(y1,1,8,'Fs/filter',num); %对接收数据进行滤波，但不过采样
z=z1(length(num):8:end);
stem(z(1:30),'.');hold on;stem(x(1:30),'r');
%% 方法二：
% x = rand(100,1); %输入数据
% y2 = rcosflt(x,1,8,'sqrt'); %在发端设计滤波器，并对数据进行滤波
% z2 = rcosflt(y2,1,8,'sqrt/Fs'); %在收端设计滤波器，并对接收数据进行滤波，但不过采样

import numpy as np


def binstr_2_dec(str1=''):
    sum = 0
    j = 0
    for i in range(len(str1)-1,-1,-1):
        if str1[i] == '1':
            sum += pow(2,j)
        j += 1
    return sum

def to_bin(value, num):#十进制数据，二进制位宽
	bin_chars = ""
	temp = value
	for i in range(num):
		bin_char = bin(temp % 2)[-1]
		temp = temp // 2
		bin_chars = bin_char + bin_chars
	return bin_chars.upper()#输出指定位宽的二进制字符串

def cordic_1QH(str1=''):
    if str1[0] == '1':
        num_sign = -1
        str2 = binstr_2_dec(str1[1:]) #去除符号位 二进制字符转十进制
        str2 = ~str2 + 1  # 十进制计算
        str2 = to_bin(str2, len(str1)-1)  # 十进制转指定位数的二进制
        str1 = str2
    else:
        num_sign = 1
        str1 = str1[1:]   #去除符号位
    
    num = 0
    j = 0
    for i in range(len(str1)):
        if str1[i] == '1':
            num += pow(2,j)
        j -= 1
    
    num *= num_sign
    return num
    
if __name__ == '__main__':
    
    print(np.cos(-np.pi/4))
    print(cordic_1QH('0010110100')) # (1111111101001010000000)_0010110100 只有后10位有效
    print('------------------------------')
    print(np.cos(np.pi/2))   # (0000000100000000111111)_1111111111   只有后10位有效
    print(cordic_1QH('1111111111'))
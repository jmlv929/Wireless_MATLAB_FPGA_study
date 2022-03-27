function [output, state] = encode_bit(g, input, state)
[n,k] = size(g);
m = k-1;
for i=1:n
   output(i) = g(i,1)*input;
   for j = 2:k
      output(i) = xor(output(i),g(i,j)*state(j-1));
   end;
end
state = [input, state(1:m-1)];

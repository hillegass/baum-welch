function beta = backward_procedure(emission, startprob, emitprob, A)

seq_len = length(emission);
possible_states = size(A, 1);

beta = zeros(possible_states, seq_len);
t = seq_len;

for i = 1:possible_states
   beta(i, t) = 1; 
end
t = t-1;

while t > 0
    for i = 1:possible_states
        sum = 0;
        for j = 1:possible_states
            sum = sum + beta(j, t+1) * A(i,j) * emitprob(j, emission(t+1));
        end
        beta(i, t) = sum; 
    end
    t = t - 1;
end


end


function gamma = gamma_them(alpha, beta)

possible_states = size(alpha, 1);
e_len = size(alpha, 2);
gamma = zeros(possible_states, e_len);
    
for t = 1:e_len;
    denominator = 0;
    for j = 1:possible_states
        denominator = denominator + alpha(j,t) * beta(j,t);
    end
    
    for i = 1:possible_states
        gamma(i, t) = alpha(i,t) * beta(i,t) / denominator;
    end
    
end
function xi = xi_them(alpha, beta, emission, startprob, emitprob, A)

possible_states = size(alpha, 1);
T = size(alpha, 2);
xi = zeros(possible_states, possible_states, T-1);
    
for t = 1:T-1;
    denominator = 0.0;
    for j = 1:possible_states
        for i = 1:possible_states
            denominator = denominator + alpha(i,t) * A(i,j) * beta(j,t+1) * emitprob(j, emission(t+1));
        end
    end
    
    for i = 1:possible_states
        for j = 1:possible_states
            xi(i,j,t)= alpha(i,t) * A(i,j) * beta(j, t+1) * emitprob(j, emission(t+1))/denominator;
        end
    end
    
end
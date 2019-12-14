function alpha = forward_procedure(emission, startprob, emitprob, A);
% Make a table of all alpha(i, t), the probability of seeing
% this sequence of emissions and being in ending state i at time t

seq_len = length(emission);
possible_states = size(A, 1);

alpha = zeros(possible_states, seq_len);

% Create the first column based on the first emission
for i = 1:possible_states
    alpha(i, 1) = startprob(i) * emitprob(i, emission(1));
end

for t = 2:seq_len
    for i = 1:possible_states
        prob_state = 0;
        for j = 1:possible_states
            prob_state = prob_state + alpha(j, t-1) * A(j, i);
        end
        alpha(i, t) = prob_state * emitprob(i, emission(t));
    end    
end

end


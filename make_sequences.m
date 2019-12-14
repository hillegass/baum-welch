function [states, emissions] = make_sequences(startprob, A, emitprob,sequence_length, total_sequences)

states = zeros(total_sequences, sequence_length,'int8');
emissions = zeros(total_sequences, sequence_length, 'int8');

for i = 1:total_sequences
    current_state = randindex(startprob);
    for t = 1:sequence_length
        states(i, t) = current_state;
        current_emission_probs = emitprob(current_state, :);
        current_emission = randindex(current_emission_probs);
        emissions(i, t) = current_emission;
        next_state_probs = A(current_state, :);
        current_state = randindex(next_state_probs); 
    end
end

end


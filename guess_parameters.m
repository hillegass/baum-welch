function [startprob, A, emitprob] = guess_parameters(emissions, state_count, emit_count, epochs)

% Initialize parameters to random
startprob = rand(1, state_count);

% startprob must sum to 1
startprob = startprob / sum(startprob);

for i = 1:state_count
   transitions = rand(1, state_count);
   
   % Rows of A must sum to 1
   transitions = transitions / sum(transitions);
   A(i, :) =  transitions;
   
   emit = rand(1, emit_count);
   
   % Rows of emitprob must sum to 1
   emit = emit / sum(emit);
   emitprob(i, :) = emit;
end

% Start learning

sequence_count = size(emissions, 1);
T = size(emissions, 2);

% Allocate holders for numerators and denominators
A_n = zeros(state_count, state_count, sequence_count); 
A_d = zeros(state_count, sequence_count);
    
emit_n = zeros(state_count, emit_count, sequence_count);
emit_d = zeros(state_count, sequence_count);
    
starts = zeros(state_count, sequence_count);

total_change = 100;
iteration_count = 0;

% Continue until convergence
while total_change > 0.000001
    
    % Just so we know how long that takes
    iteration_count = iteration_count + 1;

    % Go through each of the output sequences, nudging parameters each time
    for e_idx = 1:sequence_count
        
        % Get one sequence of emissions
        emission = emissions(e_idx, :);
        
        % Make a table of all alpha(i, t), the probability of seeing
        % this sequence of emissions and being in ending state i at time t
        alpha = forward_procedure(emission, startprob, emitprob, A);
        
        % Make a table of all beta(i, t), the probability of ending with
        % this sequence of emissions staring in state i at time t
        beta = backward_procedure(emission, startprob, emitprob, A);
        
        % Calculate gamma and xi
        gamma = gamma_them(alpha, beta);
        xi = xi_them(alpha, beta, emission, startprob, emitprob, A);
        
        % Record start probabiliites for this sequence
        starts(:, e_idx) = gamma(:,1);
        
        % Record numerators and denominators for A matrix
        for i = 1:state_count
            A_d(i,e_idx) = sum(gamma(i,1:T-1));
            
            for j = 1:state_count
                A_n(i, j, e_idx) = sum(xi(i,j,:));
            end
        end
                        
        % Record numerators and denominators for emitprobs
        for i = 1:state_count
           emit_d(i, e_idx) = sum(gamma(i,:));
           for j = 1:emit_count
               numerator = 0;
               for t = 1:T
                   if emission(t) == j
                       numerator = numerator + gamma(i,t);
                   end
               end
               emit_n(i, j, e_idx) = numerator;
           end
           
        end
        
    end
    
    % Average the starting probabilities across all sequences
    new_startprob = transpose(sum(starts, 2) / sequence_count);

    % Sum numerators for A and imitprob across all sequences
    new_A = sum(A_n, 3);
    new_emitprob = sum(emit_n, 3);
    
    % Devide each row by the appropriage denominator
    for i = 1:state_count
        new_A(i,:) = new_A(i,:) / sum(A_d(i,:));
        new_emitprob(i,:) = new_emitprob(i,:) / sum(emit_d(i,:));
    end
    
    % Figure out how much the parameters are changing
    A_change = sum(abs(A - new_A), 'all')/(state_count * state_count);
    A = new_A;
    
    emit_change = sum(abs(emitprob - new_emitprob), 'all')/(state_count * emit_count);
    emitprob = new_emitprob;
    
    start_change = sum(abs(startprob - new_startprob), 'all')/state_count;
    startprob = new_startprob;
    
    total_change = A_change + emit_change + start_change;   
end

fprintf('Convergence required %d iterations\n', iteration_count);

end


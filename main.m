% Let's do three possible states
% For identification purposes, always list starting probabilities in ascending order
startprob = [0.2, 0.3, 0.5];

% Make a transition matrix, each row must add to 1.0
A = [ 0.7, 0.2, 0.1; 
      0.1, 0.5, 0.4; 
      0.3, 0.1, 0.6];

% Make probabilities for different emissions in 
% the states. Each row represents one state and must sum to 1.0
emitprob = [0.2, 0.1, 0.1, 0.6;
            0.7, 0.1, 0.1, 0.1;
            0.1, 0.4, 0.4, 0.1];
        
       
% Generate sequences
sequence_length = 40;
total_sequences = 600;
[states, emissions] = make_sequences(startprob, A, emitprob, sequence_length, total_sequences);

% We will ignore the generated states making it truly "Hidden"

% Use the sequences and the knowledge that there are three states and four possible emissions
% to guess the parameters in some number of epochs
[g_startprob, g_A, g_emitprob] = guess_parameters(emissions, 3, 4);

% The states are probably reordered.
% Let's assume that the guessed startprop indicates the correct
% order
[g_startprob, I] = sort(g_startprob);

% Properly order the rows and columns of the guessed A
g_A = g_A(I,:);
g_A = g_A(:,I);

% Properly order the rows of guessed emission probabilities
g_emitprob = g_emitprob(I, :);

% How close are we?
display(A);
display(g_A);
display(startprob);
display(g_startprob);
display(emitprob);
display(g_emitprob);



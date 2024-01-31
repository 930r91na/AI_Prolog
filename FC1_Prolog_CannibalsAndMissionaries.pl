/* 
* Missionaries and Cannibals  
* */ 

  

% This represents, how the puzzle starts 3 cannibals and 3 missionaries at the beggining 
% Initial state 
initial_state(state(3, 3, 0, 0, 'beg')). 
% Win state
win(state(_, _, 3, 3, _)). 
% Any state is composed of the value of the cannibals and missionaries at the beggining 
% and the end, it also has a tag is it is the beg - beginning or the end

% Possible moves, rule for maximum number of people in the boat is achieved here
% The commented possibilities is for 3 person boat
 possibleMove(1, 0). % 1 missionary, 0 cannibals 
 possibleMove(2, 0). % 2 missionaries, 0 cannibals  
% possibleMove(3, 0). % 3 missionary, 0 cannibal  
possibleMove(0, 1). % 0 missionaries, 1 cannibal 
possibleMove(0, 2). % 0 missionaries, 2 cannibals  
% possibleMove(0, 3). % 0 missionary, 3 cannibal 
possibleMove(1, 1). % 1 missionary, 1 cannibal  
% possibleMove(2, 1). % 2 missionary, 1 cannibal 
% Rules for moving the boat from the beggining


% The function takes the intial state, the end state and the people that will move   
moveBoatFromBeg(state(MisBeg, CanBeg, MisEnd, CanEnd, 'beg'), NMis, NCan, state(NewMisBeg, NewCanBeg, NewMisEnd, NewCanEnd, 'end')):- 
    possibleMove(NMis, NCan),          % Generate a possible move 
    NMis =< MisBeg,                    % Validate there are enough missionaries to move 
    NCan =< CanBeg,                    % Validate there are enough cannibals to move 
    NewMisBeg is MisBeg - NMis,        % Calculate new number of missionaries at the beginning 
    NewCanBeg is CanBeg - NCan,        % Calculate new number of cannibals at the beginning 
    NewMisEnd is MisEnd + NMis,        % Calculate new number of missionaries at the end 
    NewCanEnd is CanEnd + NCan,        % Calculate new number of cannibals at the end 
    safe(state(NewMisBeg, NewCanBeg, NewMisEnd, NewCanEnd, 'end')). % Ensure the new state is safe 

% Rule for taking the boat from the end 
moveBoatFromEnd(state(MisBeg, CanBeg, MisEnd, CanEnd, 'end'), NMis, NCan, state(NewMisBeg, NewCanBeg, NewMisEnd, NewCanEnd, 'beg')):- 
    possibleMove(NMis, NCan),          % Generate a possible move 
    NMis =< MisEnd,                    % Validate there are enough missionaries to move 
    NCan =< CanEnd,                    % Validate there are enough cannibals to move 
    NewMisEnd is MisEnd - NMis,        % Calculate new number of missionaries at the end 
    NewCanEnd is CanEnd - NCan,        % Calculate new number of cannibals at the end 
    NewMisBeg is MisBeg + NMis,        % Calculate new number of missionaries at the beginning 
    NewCanBeg is CanBeg + NCan,        % Calculate new number of cannibals at the beginning 
    safe(state(NewMisBeg, NewCanBeg, NewMisEnd, NewCanEnd, 'beg')). % Ensure the new state is safe 

% Safe state is that in any part of the traject the missionaries are outonumbered
safe(State) :- 
    State = state(MisBeg, CanBeg, MisEnd, CanEnd, _), 
    (MisBeg >= CanBeg; MisBeg == 0),   % Missionaries are not outnumbered at the beginning 
    (MisEnd >= CanEnd; MisEnd == 0).   % Missionaries are not outnumbered at the end 

% Solve function has 2 possibilities, in that step the solution is found or not
% If it is foud, the history is printed, history is the sequence of movements to win
solve(State, History, []) :- 
    win(State), 
    write('Solution found: '), nl, 
    printHistory(History). 

% If it is not, the nextmove is set 
solve(State, History, [MoveDescription|Moves]) :- 
    not(win(State)), 
    move(State, NextState, MoveDescription), 
    safe(NextState), 
    not(member(NextState, History)), % Check if the move is already in the history
    solve(NextState, [NextState|History], Moves). 

% Move is set from the beg if it fails check to move from end
move(State, NextState, MoveDescription) :- 
    (moveBoatFromBeg(State, NMis, NCan, NextState); 
     moveBoatFromEnd(State, NMis, NCan, NextState)), 
    with_output_to(string(MoveDescription), format('Move ~w missionaries and ~w cannibals', [NMis, NCan])). 

% Recursively prints a list, first prints the current H and then calls itself
% The logic of the printing the states and no repeat was set with the help of ChatGpt
printHistory([]). 
printHistory([H|T]) :- 
    write(H), nl, 
    printHistory(T). 


% Find a solution 
find_solution :- 
    initial_state(InitialState), 
    solve(InitialState, [InitialState], Moves), 
    write('Moves to solve the puzzle: '), nl, 
    printHistory(Moves).


  
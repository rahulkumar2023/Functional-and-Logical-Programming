factorsLoop( N, Start, []) :- N > 1, Start > 1, Start >= N.

factorsLoop( N, Start, [Start | Rest]) :-
      N > 1, Start > 1, Start < N,
      (N mod Start) =:= 0,
      Next is Start + 1,
      factorsLoop( N, Next, Rest).

factorsLoop( N, Start, Rest) :-
      N > 1, Start > 1, Start < N,
      (N mod Start) =\= 0,
      Next is Start + 1,
      factorsLoop( N, Next, Rest).

/*
  factors(N, Factors): Given an integer N > 1,
                          return in Factors a list of all F such that
                              F > 1 and F < N and (N mod F) = 0.
                       (The list Factors includes non-prime factors.
                        For example, factors(20, [2, 4, 5, 10]) is true.)
*/
factors(N, Factors) :- N > 1, factorsLoop( N, 2, Factors).

% Check if a number is prime by confirming no non-trivial factors exist
isPrime(N, prime) :-
    factors(N, []).

% Check if a number is not prime and return its prime factors
isPrime(N, notprime(PrimeFactors)) :-
    /* Hint: our code for isPrime(N, prime) :-  checks if N has no factors.
             Here, check if N has at least one factor.
       Hint: You can use  List \= []  to check if List is not empty.
    */
    factors(N, Factors),  % Get all factors of N that are greater than 1 and less than N
    Factors \= [],        % Ensure that the factors list is not empty, implying N is not prime
    findPrimes(Factors, PrimeFactors).  % Filter out the prime factors from the factors list
    
% Base case for recursion: no numbers to check results in an empty list of primes
findPrimes([], []).

/*
  In this rule, we include X in the output: [X | Ys].
  So this rule should check that X is prime.
*/
% If X is prime, include it in the list of primes and recurse on the rest of the list
findPrimes([X | Xs], [X | Ys]) :-
    isPrime(X, prime),  % Check if X is prime
    findPrimes(Xs, Ys).  % Recursively find primes in the rest of the list

/*
  In this rule, we do not include X in the output: Ys.
  So this rule should check that X is not prime.
*/
% If X is not prime, do not include it in the list and recurse on the rest of the list
findPrimes([X | Xs], Ys) :-
    isPrime(X, notprime(_)),  % Check if X is not prime
    findPrimes(Xs, Ys).  % Recursively find primes in the rest of the list


/*
  upto(X, Y, Zs):
  Zs is every integer from X to Y

  Example:
     ?- upto(3, 7, Range)
     Range = [3, 4, 5, 6, 7]
*/
upto(X, X, [X]).
upto(X, Y, [X | Zs]) :-
    X < Y,
    Xplus1 is X + 1,
    upto(Xplus1, Y, Zs).

/*
  primes_list(M, N, Primes)
    Primes = all prime numbers between M and N, in increasing order.
    Example:
      ?- primes_list(60, 80, Primes).
      Primes = [61, 67, 71, 73, 79] .

 (Return only one solution.)
*/

% Find all prime numbers in the range between M and N
primes_list(M, N, Primes) :-
    upto(M, N, Range),  % Generate a list of integers from M to N
    findPrimes(Range, Primes).  % Filter out the prime numbers from the generated range

% Base case for recursion: if Dir is less than or equal to 0, the result is 1
gallop(Dir, _, 1) :- Dir =< 0.

% Recursive case: calculate the result when Dir is positive
gallop(Dir, Span, R) :-
    Dir > 0,
    NextDir is Dir - 10,  % Decrease Dir by 10 for the next recursive call
    NextSpan is Span * Dir,  % Update Span to Span * Dir for the next recursive call
    gallop(NextDir, NextSpan, Result),  % Recurse with the new values
    R is Span * Dir * Result.  % Compute the result as Span * Dir * Result from the recursive call

/*
  To test: ?- gallop(0, 32, 1).
           true ;                % type ;
           false.
           ?- gallop(-32, 5, 1).
           true ;                % type ;
           false.
           ?- gallop(7, 50, R).
           R = 350 .             % type .
           ?- gallop(13, 3, R).
           R = 4563 ;            % type ;
           false.

  Hint: The last query (and similar queries) should give
        only one solution.
*/

% Define rootkey if not already defined
% rootkey(NodeOrLeaf, Key) extracts the key K from a node or leaf structure.
rootkey(node(K, _, _), K).  % Extracts the key from a node structure.
rootkey(leaf(K), K).        % Extracts the key from a leaf structure.

% Helper predicate to determine if a node is a leaf
% is_leaf(Node) succeeds if Node is a leaf structure.
is_leaf(leaf(_)).

% Define all clauses for siblingpair contiguously
% siblingpair(Tree, Siblings) succeeds if Siblings is a pair of keys from sibling nodes in Tree.

% First clause: Finds sibling pairs directly under the current tree node.
% It extracts the keys of left and right children nodes and considers them siblings.
siblingpair(node(_, Left, Right), [LKey, RKey]) :-
    rootkey(Left, LKey),  % Extracts key from the left child
    rootkey(Right, RKey).  % Extracts key from the right child

% Second clause: Recursively find sibling pairs within the left subtree of the current node.
% This clause is activated if the left child is not a leaf, indicating more complex substructure.
siblingpair(node(_, Left, _), Pair) :-
    not(is_leaf(Left)),  % Ensures recursion proceeds only if Left is not a leaf
    siblingpair(Left, Pair).  % Recurses into the left subtree to find further sibling pairs

% Third clause: Recursively find sibling pairs within the right subtree of the current node.
% Similar to the previous, but operates on the right subtree.
siblingpair(node(_, _, Right), Pair) :-
    not(is_leaf(Right)),  % Ensures recursion proceeds only if Right is not a leaf
    siblingpair(Right, Pair).  % Recurses into the right subtree to find further sibling pairs

% Final clause for handling leaves: fails if the input is a leaf.
% Leaves cannot contain sibling pairs because they have no children.
siblingpair(leaf(_), _) :- fail.  % Returns fail if the tree node is a leaf, indicating no siblings possible

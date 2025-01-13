module A3
where
import Data.List

-- Variable is a synonym for String.
type Variable = String

-- In our simplified version of classical propositional logic,
-- we have the following definition for a Formula:
data Formula = Top                      -- truth (always true)
             | Bot                      -- falsehood (contradiction)
             | And Formula Formula      -- conjunction
             | Or Formula Formula       -- disjunction
             | Implies Formula Formula  -- implication
             | Not Formula              -- negation
             | Atom Variable            -- atomic proposition ("propositional variable")
             deriving (Eq, Show)

-- Some atoms, for convenience
vA = Atom "A"
vB = Atom "B"
vC = Atom "C"
vD = Atom "D"
vE = Atom "E"
vF = Atom "F"
vp = Atom "p"
vq = Atom "q"

-- Some example formulas that you can use to test your functions
formula1  = Implies (And vA vB) vC
formula2  = Implies Bot (And vA vB)
formula3  = Implies (And vA vB) Top
formula4  = And (Implies vA (And vB vC)) (And vD vE)
formula5  = And vA vB
formula6  = Not vA
formula7  = Implies vA vB
formula8  = Or vA (Not vA)
formula9  = Or vA (Not vB)

-- A Valuation is a list of pairs corresponding to a truth value (i.e. True or False)
--  for each atom in a formula
type Valuation = [(Variable, Bool)]

-- A TruthTable is an enumeration of the valuations for a given formula,
-- with each valuation paired with the corresponding evaluation of that formula.
-- (This corresponds to a truth table with no "intermediate columns".)
data TruthTable = TruthTable [(Valuation, Bool)]

{-
   This function is here so that when you print a TruthTable in GHCi, the table is nice and readable.
   You don't need to understand how this works to complete the assignment.
-}
instance Show TruthTable where
  show (TruthTable rows) =
    case rows of
      [] -> ""
      ([], result) : _ -> "   result is " ++ pad_show result ++ "\n"
      ((c,b) : valu, result) : xs -> 
        c ++ "=" ++ (pad_show b) ++ "   "
          ++ show (TruthTable [(valu,result)])
          ++ show (TruthTable xs)
    where
      pad_show True  = "True "
      pad_show False = "False"

-- | Extracts all unique variables present in a formula.
getVariables :: Formula -> [Variable]
-- Base cases:
getVariables Top               = []  -- Top formula has no variables
getVariables Bot               = []  -- Bot formula has no variables
getVariables (Atom v)          = [v] -- Atomic formula has one variable
-- Recursive cases:
getVariables (Not phi)         = getVariables phi         -- Negation formula
getVariables (And phi1 phi2)   = nub $ getVariables phi1  -- Conjunction formula
                               ++ getVariables phi2      -- with duplicates removed
getVariables (Or phi1 phi2)    = nub $ getVariables phi1  -- Disjunction formula
                               ++ getVariables phi2      -- with duplicates removed
getVariables (Implies phi psi) = nub $ getVariables phi   -- Implication formula
                               ++ getVariables psi      -- with duplicates removed

-- | Generates all possible valuations for a list of variables.
getValuations :: [Variable] -> [Valuation]
-- Base case: If there are no variables, return the empty valuation (the empty list).
getValuations []       = [[]]
-- Recursive case: For each variable 'c' in the list, generate valuations
-- by combining it with valuations of the rest of the variables.
getValuations (c : cs) = let restValuations = getValuations cs  -- Valuations for rest of variables
                         in [ (c, b) : valu | valu <- restValuations, b <- [True, False]] -- Combine 'c' with each possible truth value and combine with rest of the valuations


{-
  Hint: To apply a function f to every element of a list xs,
   write  map f xs.
  For example, the following adds 1 to the start of every list
   in a list of lists [[2,3], [2,4]]:
   map (\ys -> 1 : ys) [[2,3], [2,4]]  ==  [[1,2,3], [1,2,4]]
-}
-- | Evaluates a formula with a given valuation.
evalF :: Valuation -> Formula -> Bool
evalF valu formula =
    case formula of
        -- Base cases:
        Top               -> True   -- Top formula is always true
        Bot               -> False  -- Bot formula is always false
        Not phi1          -> not (evalF valu phi1)            -- Negation formula
        Implies phi1 phi2 -> not (evalF valu phi1) || (evalF valu phi2) -- Implication formula
        Atom c            -> case lookup c valu of   -- Atomic formula
                                Just b  -> b         -- Look up value of variable in valuation
                                Nothing -> error $ "Variable " ++ c ++ " not found in valuation." -- Error if variable not found
        -- Recursive cases:
        And phi1 phi2     -> evalF valu phi1 && evalF valu phi2 -- Conjunction formula
        Or phi1 phi2      -> evalF valu phi1 || evalF valu phi2  -- Disjunction formula

-- buildTable:
--  Build a truth table for a given formula.
--  You can use this function to help check your definitions
--  of getVariables, getValuations and evalF.
buildTable :: Formula -> TruthTable
buildTable psi =
  let valuations = getValuations (getVariables psi)
  in
    TruthTable (zip valuations
                    (map (\valu -> evalF valu psi) valuations))

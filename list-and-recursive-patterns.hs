module A2 where
import Data.Char

divisible_by :: Int -> Char -> Bool
divisible_by factor ch = (mod (ord ch) factor == 0)

rewrite :: (a -> Bool) -> [a] -> [a]
rewrite _ [] = []  -- Base case: Empty list remains unchanged.
rewrite f (x:xs)
  | f x       = x : x : rewrite f xs  -- Duplicate element if it satisfies the predicate.
  | otherwise = x : rewrite f xs      -- Keep the element unchanged if it doesn't satisfy the predicate.


-- Hint: Pattern-match on the second argument.


test_rewrite1 = (rewrite (divisible_by 5) "") == ""
test_rewrite2 = (rewrite (\x -> x == ' ') "it's a deed" == "it's  a  deed")
test_rewrite3 = (rewrite (divisible_by 5) "CombinatorFest" == "CombiinnatorFFesst")
test_rewrite = test_rewrite1 && test_rewrite2 && test_rewrite3

listCompare :: ([Int], [Int]) -> [Bool]

-- Base case: Both lists are empty, resulting in an empty list of Booleans.
listCompare ([],     []    ) = []             

-- Recursive case: Compare the head elements of both lists and prepend the result
-- to the list obtained by recursively comparing the remaining elements.
listCompare (x : xs, y : ys) = (x < y) : listCompare (xs, ys)  

-- Recursive case: The first list is not empty, but the second list is.
-- Prepend False to the list obtained by recursively comparing the remaining elements.
listCompare (x : xs, []    ) = False : listCompare (xs, []) 

-- Recursive case: The second list is not empty, but the first list is.
-- Prepend False to the list obtained by recursively comparing the remaining elements.
listCompare ([],     y : ys) = False : listCompare ([], ys)  




test_listCompare1 = listCompare ([], []) == []
test_listCompare2 = listCompare ([1, 2, 4], [3, 2, 0]) == [True, False, False]
test_listCompare3 = listCompare ([-2, -5, 0], [-6, 2, 0]) == [False, True, False]
test_listCompare4 = listCompare ([5, 4, 3, 2], [2, 9]) == [False, True, False, False]
test_listCompare5 = listCompare ([1, 0], [1, 1, 1, 1]) == [False, True, False, False]

test_listCompare = test_listCompare1 && test_listCompare2 && test_listCompare3 && test_listCompare4
                && test_listCompare5

genCompare :: (a -> a -> Bool) -> ([a], [a]) -> [Bool]

-- Base case: Both lists are empty, resulting in an empty list of Booleans.
genCompare cmp ([],     []    ) = []              

-- Recursive case: Compare the head elements of both lists using the provided function 'cmp'
-- and prepend the result to the list obtained by recursively comparing the remaining elements.
genCompare cmp (x : xs, y : ys) = cmp x y : genCompare cmp (xs, ys)  

-- Recursive case: The first list is not empty, but the second list is.
-- Prepend False to the list obtained by recursively comparing the remaining elements.
genCompare cmp (x : xs, []    ) = False : genCompare cmp (xs, []) 

-- Recursive case: The second list is not empty, but the first list is.
-- Prepend False to the list obtained by recursively comparing the remaining elements.
genCompare cmp ([],     y : ys) = False : genCompare cmp ([], ys)  


test_genCompare1 = genCompare (\i -> \j -> i < j) ([1, 2, 4], [3, 2, 0])
                   == [True, False, False]

-- whoever calls genCompare gets to define what "less than" means:
--  in test_genCompare2, the definition of "less than" is "shorter list"
shorter :: [a] -> [a] -> Bool
shorter xs ys = (length xs < length ys)
test_genCompare2 = genCompare shorter (["a",   "ab",  "abcd", ""            ],
                                       ["ccc", "xy",  "",     "S combinator"])
                                    == [True,  False, False,  True]

test_genCompare = test_genCompare1 && test_genCompare2

almostListCompare :: ([Int], [Int]) -> [Bool]
almostListCompare (xs, ys) = zipWith (<) xs ys
{- 

The almostListCompare function, implemented using zipWith (<) xs ys, does not fully implement the specification of listCompare because it does not handle cases where the lengths of the input lists (xs and ys) are different. The zipWith function stops processing elements when the shorter list is exhausted, potentially leading to an incomplete comparison.
In contrast, the listCompare function explicitly pads the result with False values for the remaining elements if one of the lists is longer than the other. This ensures that the resulting list has the same length as the longer input list, providing a complete comparison.
Therefore, almostListCompare may produce a result with a length equal to the length of the shorter list, and it does not handle the padding of False values for unmatched elements as specified in the listCompare function.

-}

test_rewrite_x1 = rewrite (\x -> x > 0) [-3, 5,    -7, 2,    1,    -9]
                                     == [-3, 5, 5, -7, 2, 2, 1, 1, -9]
test_rewrite_x2 = map (\f -> f 100)
                      (rewrite (\f -> (f 0) > 0) [(\x -> x), (\y -> 1), (\z -> z - 1)])
                  ==  [100, 1, 1, 99]

test_rewrite_x = test_rewrite_x1 && test_rewrite_x2

-- Test Case 1: Rewriting Doubles
test_rewrite_new1 = rewrite (\n -> n + 2 > 0) [3.5, -5.2, 1.8, 0, -2.1]
                    == [3.5, 3.5, -5.2, 1.8, 1.8, 0, 0, -2.1]

-- Test case 2: List of Tuples
test_rewrite_new2 = rewrite (\(x, y) -> x + y > 0) [(1, 2), (-3, 5), (0, 0)]
                     == [(1, 2), (1, 2), (-3, 5), (-3, 5), (0, 0)]

-- Combining the results of both test cases using the logical AND operator (`&&`)
test_rewrite_new = test_rewrite_new1 && test_rewrite_new2

data Song = Harmony Song Song
          | Atom String
          deriving (Show, Eq)    -- writing Eq here lets us use == to compare Songs
          
-- sing function to transform a Song based on specified rules
sing :: Song -> Song

-- Rule 1: If the left child of the root is a Harmony with Atom starting with 'K', return the motif
sing (Harmony (Harmony (Atom (x:xs)) motif) right)
  | x == 'K' = motif

-- Rule 2: If the left child of the root is a Harmony with Atom starting with 'S', transform the song
sing (Harmony (Harmony (Harmony (Atom (y:ys)) s1) s2) s3)
  | y == 'S' = Harmony (Harmony s1 s3) (Harmony s2 s3)

-- Rule 3: If no specific rule is matched, recursively apply sing on both children
sing (Harmony left right) = Harmony (sing left) (sing right)

-- Base case: If the song does not match any rule, return the song unchanged
sing atom@(Atom _) = atom

ascend = Harmony (Harmony (Atom "S0") (Atom "K1")) (Atom "K2")

test_sing1 = (sing (Harmony ascend (Atom "K3")))
              == Harmony (Harmony (Atom "K1") (Atom "K3"))
                         (Harmony (Atom "K2") (Atom "K3"))
                         
test_sing2 = sing (sing (Harmony (Harmony (Atom "K1") (Atom "K"))
                                 (Harmony (Atom "K2") (Atom "K"))))
              == Atom "K"

test_sing3 = (sing ascend) == ascend

test_sing4 = sing (Harmony (Atom "S.") (Harmony ascend (Atom "K4")))
              == Harmony
                   (Atom "S.")
                   (Harmony (Harmony (Atom "K1") (Atom "K4"))
                            (Harmony (Atom "K2") (Atom "K4")))

-- repeat_sing function to repeatedly apply sing until a fixed point is reached
repeat_sing :: Song -> Song

-- Base case: If the current song is equal to the song obtained by applying sing, return the current song
repeat_sing currentSong | currentSong == usedSong = currentSong

-- Recursive case: If the current song is not the fixed point, continue repeating sing
                        | otherwise = repeat_sing usedSong

-- Calculate the next iteration of the song by applying sing
  where usedSong = sing currentSong


test_repeat1 = repeat_sing (Harmony ascend (Atom "Z")) == Atom "Z"

diverging_song :: Song
diverging_song =
  Harmony
    (Harmony (Atom "A") (Atom "B"))  -- Harmony with Atoms "A" and "B"
    (Harmony
      (Harmony (Atom "C") (Atom "D"))  -- Harmony with Atoms "C" and "D"
      (Harmony (Atom "E") (Atom "F"))) -- Harmony with Atoms "E" and "F"

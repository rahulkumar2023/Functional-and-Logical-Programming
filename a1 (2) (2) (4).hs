module A1 where

{-
   sqroot m n  ==  True
   if and only if

     n is the principal square root of m

     or

     m is the principal square root of n

   where "principal square root of p" means an integer k
   such that  k > 0  and  k*k == p.
 
   Hints:
     There is a built-in function sqrt, but it doesn't work on integers.

     While (-3) squared equals 9, -3 is negative, so it is not a
     *principal* square root.  Thus,  sqroot (-3) 9  should be False.
-}
sqroot :: Integer -> Integer -> Bool
sqroot m n
  | m > 0 && m^2 == n = True 
  | n > 0 && n^2 == m = True
  | otherwise          = False

test_sqroot1, test_sqroot2, test_sqroot3, test_sqroot4, test_sqroot5, test_sqroot6 :: Bool
test_sqroot1 = (sqroot 1 (-1)) == False
test_sqroot2 = (sqroot (-3) 9) == False
test_sqroot3 = (sqroot 3 9) == True
test_sqroot4 = (sqroot 0 0) == False
test_sqroot5 = (sqroot 65536 256) == True
test_sqroot6 = (sqroot 65536 255) == False

-- Do all tests together
test_sqroot :: Bool
test_sqroot = test_sqroot1 && test_sqroot2
                           && test_sqroot3
                           && test_sqroot4
                           && test_sqroot5
                           && test_sqroot6

{-
  `gallop': given two integer arguments `dir' and `span',
  returns 1 if `dir' is less than or equal to 0,
  and otherwise returns (span * dir) * gallop (dir - 10) (span * dir).
-}

gallop :: Integer -> Integer -> Integer
gallop dir span
  | dir <= 0  = 1
  | otherwise = (span * dir) * gallop (dir - 10) (span * dir)

  
-- Testing gallop:
test_gallop1, test_gallop2, test_gallop3, test_gallop :: Bool
test_gallop1 = (gallop 0 32    == 1)
test_gallop2 = (gallop (-32) 5 == 1)
test_gallop3 = (gallop 7 50    == 350)
test_gallop4 = (gallop 36 360  == 761607593985740636160000)

test_gallop  = test_gallop1 && test_gallop2 && test_gallop3 && test_gallop4


{-
  gallop_seq n == string containing results of  gallop k 360 
                  for k in 1, ..., n, separated by semicolons

  For example,  gallop_seq 3  should return  "360;720;1080"
    because gallop 1 360 should return 360,
            gallop 2 360 should return 720,
        and gallop 3 360 should return 1080.

  If n < 1, gallop_seq should return the empty string: ""
  
  Hints:
     1. The built-in function  show  converts an integer
        to its (decimal) representation as a string.

     2. You can use the built-in function  ++  to concatenate strings.
          For example, "10" ++ "," == "10,".

     3. You may find it useful to define a helper function for gallop_seq to call.
-}
{-
The gallopHelper function takes two integers k and span as arguments, and it returns a string representation of the result obtained by calling the gallop function with those arguments. This process is done by using the show function.
-}
gallopHelper :: Integer -> Integer -> String
gallopHelper k span = show (gallop k span)

gallop_seq :: Integer -> String
gallop_seq n 
  | n < 1     = ""
  | otherwise = sequenceResult 1 360 n
  where
    {-
    The sequenceResult function generates a sequence of strings by repeatedly calling the gallopHelper function with different values of k and span until a specified condition is met.
    -}
    sequenceResult :: Integer -> Integer -> Integer -> String
    sequenceResult k span maxK
      | k == maxK = gallopHelper k span
      | k > maxK  = ""
      | otherwise = gallopHelper k span ++ ";" ++ sequenceResult (k + 1) span maxK

{-
Replace the underlines (_______).

     expression                   justification

     (\q -> 3 + (q * 9)) 2

  => 3 + (2 * 9)                  by function application with a substitution of "2 for q"

  => 3 + 18                       by arithmetic

  => 21                           by arithmetic

  For full marks, state the substitution in the function application step.
  For example:

  "...                          by function application
                                with 500 for q"
                                     ^^^^^^^^^
                          "500 for q" is the substitution

Replace the underlines (_______).
Assume a function `square' has been defined:
-}
square :: Integer -> Integer
square x = x * x
{-
     expression                            justification

     ((\s -> (\t -> s 3)) square) 10

  => (\t -> square 3) 10                   by function application with "the function square for s"

  => square 3                              by function application with "10 for t"

  => 3 * 3                                 by definition of square

  => 9                                     by arithmetic

  For full marks, state the substitution in all function application steps.

Step the following expression as far as possible.

  Hints:
     The given expression can only be stepped once.
     If you are stepping it more than once, you must have made a mistake.

     (x, 10) is a pair whose first component is x,
     and whose second component is 10.
     It is *not* the same as  x 10  which calls a function x with the
     argument 10.

     You cannot directly check the answer in Haskell,
     because Haskell will not print functions,
     so it will not print a pair that contains a function.

     expression                            justification

     (\x -> (x, 10)) square

  => (\x -> (square, 10))                  by function application with "the function square for x"
-}

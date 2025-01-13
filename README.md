# Functional and Logical Programming Repository

This repository contains a collection of programs written in **Haskell** and **Prolog**, focusing on recursion, mathematical computations, logical reasoning, and tree operations. Each file addresses distinct problem-solving techniques and implementations.

---

## Repository Structure

### Haskell Files

1. **`recursion-and-evaluation.hs`**
   - **Description:** Implements mathematical and recursive functions.
   - **Key Features:**
     - **`sqroot`**: Determines if one number is the principal square root of another.
     - **`gallop`**: Computes a recursive arithmetic product based on `dir` and `span`.
     - **`gallop_seq`**: Generates a sequence of results from the `gallop` function as a semicolon-separated string.
   - **Tests:** Includes comprehensive test cases for each function.

2. **`list-and-recursive-patterns.hs`**
   - **Description:** Focuses on list manipulation and functional transformations.
   - **Key Features:**
     - **`rewrite`**: Duplicates elements in a list based on a predicate.
     - **`listCompare`**: Compares two lists and produces a list of boolean values.
     - **`genCompare`**: Generalized version of `listCompare` with a custom comparison function.
     - **`almostListCompare`**: Simplified list comparison using `zipWith`.
     - **`sing` and `repeat_sing`**: Recursive transformations of custom `Song` data structures.
   - **Tests:** Comprehensive test cases for all functions, including list manipulation and recursive song processing.

3. **`propositional-logic-evaluator.hs`**
   - **Description:** Implements propositional logic operations and truth table generation.
   - **Key Features:**
     - **`Formula` data type**: Represents classical propositional logic.
     - **`getVariables`**: Extracts unique variables from a formula.
     - **`getValuations`**: Generates all possible truth valuations for variables.
     - **`evalF`**: Evaluates a formula under a given valuation.
     - **`buildTable`**: Constructs a truth table for a given formula.
   - **Tests:** Example formulas are provided to test logical correctness.

### Prolog File

4. **`math-and-tree-operations.pro`**
   - **Description:** Implements mathematical and tree operations using Prolog.
   - **Key Features:**
     - **`factorsLoop` and `factors`**: Computes all factors of a number.
     - **`isPrime`**: Determines if a number is prime and identifies its prime factors.
     - **`findPrimes`**: Extracts prime numbers from a list.
     - **`primes_list`**: Generates all prime numbers in a given range.
     - **`gallop`**: Computes a recursive arithmetic product.
     - **Tree Operations:**
       - **`siblingpair`**: Identifies sibling pairs in a binary tree.
   - **Tests:** Example queries are provided to test functionality in SWI-Prolog.

---

## How to Use

### Haskell Files
1. **Compile and Run:**
   - Use `ghc` to compile the files or `ghci` for interactive testing:
     ```bash
     ghc recursion-and-evaluation.hs
     ghci recursion-and-evaluation.hs
     ```
2. **Execute Test Cases:**
   - Run the provided test cases in GHCi to verify correctness:
     ```haskell
     > test_sqroot
     > test_gallop
     > test_rewrite
     ```

### Prolog File
1. **Load and Test in SWI-Prolog:**
   - Load the file:
     ```prolog
     ?- [math-and-tree-operations].
     ```
   - Example Queries:
     ```prolog
     ?- isPrime(7, Answer).
     ?- primes_list(10, 20, Primes).
     ?- siblingpair(node(4, node(2, leaf(1), leaf(3)), leaf(5)), Pair).
     ```

---

## Examples

### Haskell Example (`recursion-and-evaluation.hs`)
```haskell
> gallop 13 3
4563
> gallop_seq 3
"360;720;1080"
```

### Prolog Example (`math-and-tree-operations.pro`)
```prolog
?- isPrime(20, Answer).
Answer = notprime([2, 5]).

?- siblingpair(node(4, node(2, leaf(1), leaf(3)), leaf(5)), Pair).
Pair = [2, 5] ;
Pair = [1, 3].
```

---

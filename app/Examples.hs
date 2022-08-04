{-# LANGUAGE QualifiedDo, DataKinds #-}
module Examples where

import Prelude (Int, Bool(..), IO (..), (.), String)
import Horth

count1to10 = Horth.do
  literal 0
  while (dup >> literal 10 >> neq)
    (Horth.do
      dup
      println
      literal 1
      add
    )
  drop

whyConcatenative = Horth.do
  literal [1..5]
  literal even
  countWhere
  println
  where
    countWhere = length . filter
    -- vs native Haskell solution:
    -- countWhere = (length .) . filter
    -- see http://evincarofautumn.blogspot.com/2012/02/why-concatenative-programming-matters.html
    
    even :: Shape '[Int] '[Bool]
    even = switch . literal 
      [ (literal 1 >> eq,      drop >> literal False)
      , (literal 0 >> eq,      drop >> literal True)
      , (drop >> literal True, literal 2 >> sub >> even)
      ]
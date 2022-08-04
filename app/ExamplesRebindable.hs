{-# LANGUAGE QualifiedDo, DataKinds, RebindableSyntax #-}
module ExamplesRebindable where

import Prelude ((.), Bool, Integer)
import Horth
import Horth.Syntax

count1to10 = do
  0
  while (dup >> 10 >> neq)
    (do
      dup
      println
      1
      add
    )
  drop

whyConcatenative = do
  literal even
  countWhere
  println
  where
    countWhere = length . filter
    -- vs native Haskell solution:
    -- countWhere = (length .) . filter
    -- see http://evincarofautumn.blogspot.com/2012/02/why-concatenative-programming-matters.html
    
    even :: Shape '[Integer] '[Bool]
    even = do
      dup
      if eq . 0
      then drop >> true
      else not . odd . sub . 2

    odd :: Shape '[Integer] '[Bool]
    odd = do
      dup
      if less . 2
      then neq . 0
      else not . even . sub . 2
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE GADTs #-}

module Horth.Basic 
  ( Horth.Basic.add
  , Horth.Basic.drop
  , Horth.Basic.dup
  , Horth.Basic.eq
  , Horth.Basic.filter
  , Horth.Basic.less
  , Horth.Basic.neq
  , Horth.Basic.not
  , Horth.Basic.println
  , Horth.Basic.sub
  , Horth.Basic.swap
  , Horth.Basic.length
  ) where

import Horth.ControlFlow
import Horth.Language
import Control.Monad (filterM)

not :: Shape '[Bool] '[Bool]
not = call1 Prelude.not

length :: Shape '[[a]] '[Int]
length = call1 Prelude.length

add :: Num a => Shape '[a, a] '[a]
add = call2 (+)

sub :: Num a => Shape '[a, a] '[a]
sub = call2 (-)

dup :: Shape '[x] '[x, x]
dup = fmap (\(HCons x xs) -> x %: x %: xs)

swap :: Shape '[x, y] '[y, x]
swap = fmap (\(HCons x (HCons y r)) -> y %: x %: r)

drop :: Shape '[x] '[]
drop = fmap (\(HCons x xs) -> xs)

println :: Show x => Shape '[x] '[]
println io = do
  (HCons x xs) <- io
  print x
  return xs

eq :: Eq a => Shape '[a, a] '[Bool]
eq = call2 (==)

neq :: Eq a => Shape '[a, a] '[Bool]
neq = call2 (/=)

less :: Ord a => Shape '[a, a] '[Bool]
less = call2 (<)

filter :: State ((State '[a] -> State (Bool : y)) : [a] : xs) -> State ([a] : xs)
filter args = do
  (HCons f (HCons xs rest)) <- args
  xs <- filterM (front . f . wrap) xs
  return (xs %: rest)

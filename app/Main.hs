module Main where

import ExamplesRebindable as Examples

import Horth

example :: String -> (State a -> State b) -> State a -> IO ()
example message prog init = do
  putStrLn message
  prog init
  return ()

empty = return HNil

main :: IO ()
main = do
  example "Counting from 1 to 10"     count1to10 empty
  example "Why concatenative matters" whyConcatenative (literal [1..5] empty)

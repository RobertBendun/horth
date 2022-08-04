{-# LANGUAGE DataKinds  #-}
module Main where

import Examples

import Horth.Language (State, run)

example :: String -> (State '[] -> State s) -> IO ()
example message prog = do
  putStrLn message
  run prog
  return ()

main :: IO ()
main = do
  example "Counting from 1 to 10"     count1to10
  example "Why concatenative matters" whyConcatenative

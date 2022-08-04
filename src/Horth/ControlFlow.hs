{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
module Horth.ControlFlow
  ( cond
  , switch
  , while
  ) where

import Horth.Language

cond :: (State a -> State (Bool ': b))      -- Condition
     -> (State b -> State c)                -- Then
     -> (State b -> State c)                -- Else
     -> State a -> State c
cond test then' else' start = do
  (HCons condition remaining) <- test start
  if condition
  then then' $ return remaining
  else else' $ return remaining

while :: (State a -> State (Bool ': b)) -- Condition
      -> (State b -> State a)           -- Body
      -> State a -> State b
while test body start = do
  (HCons condition remaining) <- test start
  if condition
  then while test body $ body (return remaining)
  else return remaining

switch :: State ([(State r -> State (Bool : a), State r -> State r')] : r) -> State r'
switch args = do
  (HCons predicates input) <- args
  switch' predicates (return input)
  where
    switch' :: [(State r -> State (Bool : a), State r -> State r')] -> State r -> State r'
    switch' ((pred, body):xs) input = do
      match <- front $ pred input
      if match
      then body input
      else switch' xs input
    switch' _ _ = error "Switch not matched"

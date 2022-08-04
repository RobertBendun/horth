{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

module Horth.Language where

import Prelude hiding ((>>))

data HList :: [*] -> * where
  HNil  :: HList '[]
  HCons :: x -> HList xs -> HList (x ': xs)

infixr 5 %:
(%:) :: x -> HList xs -> HList (x ': xs)
(%:) = HCons

type family (:++:) a b :: [*] where
  (x:xs) :++: ys = x : (xs :++: ys)
  '[] :++: ys = ys

instance Show (HList '[]) where
  show HNil = "HNil"
instance (Show x, Show (HList xs)) => Show (HList (x ': xs)) where
  show (HCons x xs) = show x ++ " %: " ++ show xs

type State x = IO (HList x)
type Shape a b = forall xs . State (a :++: xs) -> State (b :++: xs)

(>>) :: (a -> b) -> (b -> c) -> a -> c
(>>) = flip (.)
infixr 9 >>

wrap :: a -> State '[a]
wrap = return . (`HCons` HNil)

front :: State (x : xs) -> IO x
front = fmap (\(HCons x _) -> x)

call1 :: (a -> b) -> Shape '[a] '[b]
call1 callback = fmap (\(HCons a xs) -> callback a %: xs)

call2 :: (b -> a -> c) -> Shape '[a, b] '[c]
call2 callback = fmap (\(HCons a (HCons b xs)) -> callback b a %: xs)

literal :: x -> State xs -> State (x : xs)
-- literal :: x -> Shape '[] '[x] <- this doesn't work for some reason
literal = fmap . HCons

run :: (State '[] -> State s) -> State s
run = ($ return HNil)


{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
module Horth.Syntax where

import qualified Prelude as P

import Horth

fromInteger :: P.Integer -> State xs -> State (P.Integer : xs)
fromInteger = literal

false = literal P.False

true = literal P.True

ifThenElse = cond
{-# LANGUAGE QualifiedDo, DataKinds #-}
module HelloWorld where
  
import Horth

hello :: Shape '[] '[]
hello = Horth.do
  literal "hello, world"
  println

main :: IO ()
main = do
  run hello
  return ()
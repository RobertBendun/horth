# Horth

Horth programming language is Forth-like embeded language inside Haskell.

```hs
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
```

## Examples

For basic DSL usage see [app/Examples.hs](./app/Examples.hs).

For usage with RebindableSyntax see [app/ExamplesRebindable.hs](./app/ExamplesRebindable.hs)


## Language documentation

### Definition of a word

Word is any function from `Horth.State` to `Horth.State`, where `State` is `IO (HList xs)`. Essentialy words are stack transformations with side effects.

### Word composition

Currenlty there are 3 equavilent methods of composing words in Horth:

- Using overloaded `do` notation: `(Horth.do foo; bar)`
- Using function composition: `(bar . foo)`
- Using sequence operator: `(foo >> bar)`

each of this program will first run `foo` and then `bar`.

### List of defined words

All defined words can be found in:

- For basic words like `dup`, `add` see [Horth.Basic](./src/Horth/Basic.hs) module
- For control flow see [Horth.ControlFlow](./src/Horth/ControlFlow.hs) module

additionaly there is `literal` word that accepts value and puts it on stack, e.g. `literal 42` puts 42 onto stack.

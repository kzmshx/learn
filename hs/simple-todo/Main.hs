module Main where

type Item = String

type Items = [Item]

main :: IO ()
main = do
  putStr "Name: "
  name <- getLine
  let out = "Hello, " ++ name ++ "!"
  putStrLn out

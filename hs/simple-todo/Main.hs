module Main where

main :: IO ()
main = do
  putStr "Name: "
  name <- getLine
  let out = "Hello, " ++ name ++ "!"
  putStrLn out

module Main where

type Item = String

type Items = [Item]

-- addItem returns a new list with the item added to the end.
addItem :: Item -> Items -> Items
addItem item items = item : items

-- displayItems returns a string representation of the items.
-- displayItems :: Items -> String

-- removeItem returns a new list without the item at the given index, if not found returns an error message.
-- removeItem :: Int -> Items -> Either String Items

main :: IO ()
main = do
  putStr "Name: "
  name <- getLine
  let out = "Hello, " ++ name ++ "!"
  putStrLn out

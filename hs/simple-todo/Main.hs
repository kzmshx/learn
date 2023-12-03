module Main where

type Item = String

type Items = [Item]

-- addItem returns a new list with the item added to the end.
addItem :: Item -> Items -> Items
addItem item items = item : items

-- displayItems returns a string representation of the items.
displayItems :: Items -> String
displayItems items =
  let displayItem index item = show index ++ " - " ++ item
      reversedItems = reverse items
      displayItemsList = zipWith displayItem [1 ..] reversedItems
   in unlines displayItemsList

-- removeItem returns a new list without the item at the given index, if not found returns an error message.
-- removeItem :: Int -> Items -> Either String Items

interactWithUser :: Items -> IO Items
interactWithUser items = do
  putStr "Enter a ToDo: "
  item <- getLine
  let newItems = addItem item items
  putStrLn "Item added!"
  putStrLn ""
  putStrLn "ToDo List:"
  putStrLn (displayItems newItems)
  interactWithUser newItems

main :: IO ()
main = do
  putStrLn "ToDo App"
  putStrLn ""

  let initialList = []
  interactWithUser initialList

  pure ()

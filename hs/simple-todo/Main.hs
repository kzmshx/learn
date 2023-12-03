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

data Command
  = AddItem String
  | ListItems
  | Help
  | Quit

parseCommand :: String -> Either String Command
parseCommand line = case words line of
  "add" : item -> Right (AddItem (unwords item))
  ["list"] -> Right ListItems
  ["help"] -> Right Help
  ["quit"] -> Right Quit
  _ -> Left "Unsupported command."

help :: String
help =
  unlines
    [ "add <item>  Add an item.",
      "list        Display the items.",
      "help        Display this help message.",
      "quit        Quit the program."
    ]

interactWithUser :: Items -> IO ()
interactWithUser items = do
  putStr "> "
  line <- getLine
  case parseCommand line of
    Right ListItems -> do
      putStrLn (displayItems items)
      interactWithUser items
    Right (AddItem item) -> do
      let newItems = addItem item items
      putStrLn ("Added: " ++ item)
      interactWithUser newItems
    Right Help -> do
      putStrLn help
      interactWithUser items
    Right Quit -> do
      putStrLn "Bye!"
      pure ()
    Left err -> do
      putStrLn ("Error: " ++ err)
      interactWithUser items

main :: IO ()
main = do
  putStrLn "ToDo App"
  putStrLn ""
  putStrLn help

  let initialList = []
  interactWithUser initialList

  pure ()

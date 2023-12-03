import Control.Arrow ((>>>))

data Move = Forward Int
          | Up Int
          | Down Int
          deriving Show

parseInput :: String -> [Move]
parseInput =
    lines
    >>> map (\l -> case words l of
        ["forward", n] -> Forward $ read n
        ["up", n] -> Up $ read n
        ["down", n] -> Down $ read n)

part1 :: [Move] -> Int
part1 = 
    foldl (\(pos, depth) m -> case m of
        Forward n -> (pos + n, depth)
        Up n -> (pos, depth - n)
        Down n -> (pos, depth + n)) (0,0)
    >>> uncurry (*)

main = do
    content <- parseInput <$> readFile "input"
    let answer1 = part1 content
    putStrLn $ "Part 1: " ++ show answer1

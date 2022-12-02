import Control.Arrow ( (>>>) )

convert :: String -> Int
convert "A" = 0
convert "B" = 1
convert "C" = 2
convert "X" = 0
convert "Y" = 1
convert "Z" = 2

parseInput :: String -> IO [(Int, Int)]
parseInput filename = 
    flip fmap (readFile filename)
    $ lines >>> map ((\(a:b:_) -> (a,b)) . map convert . words)

part1 :: [(Int, Int)] -> Int
part1 = foldr (\(a,b) acc -> acc + b + 1 + 
    case () of _ | a == (b + 1) `mod` 3 -> 0
                 | a == b -> 3
                 | a == (b - 1) `mod` 3 -> 6) 0

part2 :: [(Int, Int)] -> Int
part2 = foldr (\(a,b) acc -> acc + 
    case b of 0 -> (a - 1) `mod` 3 + 1
              1 -> 3 + a + 1
              2 -> 6 + (a + 1) `mod` 3 + 1) 0

main = do
    lines <- parseInput "input.txt"
    putStrLn $ "Part 1: " ++ show (part1 lines)
    putStrLn $ "Part 2: " ++ show (part2 lines)
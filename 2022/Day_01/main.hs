import Data.List (groupBy, sortBy)
import Data.Functor ( (<&>) )
import Control.Arrow ( (>>>) )

import Data.List.Split ( splitOn ) -- cabal install --lib split

parseInput :: String -> IO [[Int]]
parseInput filename = readFile filename <&> 
    (splitOn "\n\n" 
    >>> map (lines >>> map read))

part1 :: [[Int]] -> Int
part1 = map sum >>> maximum

part2 :: [[Int]] -> Int
part2 = map sum 
    >>> sortBy (flip compare) 
    >>> take 3
    >>> sum

main :: IO ()
main = do
    elves <- parseInput "input.txt"
    putStrLn $ "Part 1: " ++ show (part1 elves)
    putStrLn $ "Part 2: " ++ show (part2 elves)

    
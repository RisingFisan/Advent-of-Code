import qualified Data.Set as Set
import qualified Data.Map.Strict as Map
import Data.List.Split ( chunksOf )

import Control.Arrow ((>>>))
import Data.Function ((&))

priorities :: Map.Map Char Integer
priorities = Map.fromList (zip (['a'..'z'] ++ ['A'..'Z']) [1..52])

parseInput :: String -> IO [String]
parseInput filename = lines <$> readFile filename


part1 :: [String] -> Integer
part1 = 
    map (\sack -> 
        let half = length sack `div` 2
            (compart1, compart2) = splitAt half sack in 
        Set.intersection (Set.fromList compart1) (Set.fromList compart2)
        & Set.elemAt 0
        & (Map.!) priorities)
    >>> sum


part2 :: [String] -> Integer
part2 = 
    chunksOf 3
    >>> map (map Set.fromList)
    >>> map (\[sack1, sack2, sack3] ->
        Set.intersection sack1 sack2
        & Set.intersection sack3
        & Set.elemAt 0
        & (Map.!) priorities)
    >>> sum

main = do
    sacks <- parseInput "input.txt"
    putStrLn $ "Part 1: " ++ show (part1 sacks)
    putStrLn $ "Part 2: " ++ show (part2 sacks)


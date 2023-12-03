import Data.List
import Control.Arrow ((>>>))

import Data.List.Split

parseInput :: FilePath -> IO ([String],[[Int]])
parseInput filename = 
    (\(c:i:_) -> (parseCrates c, parseInstructions i)) . splitOn "\n\n" <$> readFile filename

parseCrates :: String -> [String]
parseCrates = lines
    >>> init
    >>> transpose
    >>> zip [0..]
    >>> filter (\(i,_) -> i `mod` 4 == 1)
    >>> map (dropWhile (== ' ') . snd)

parseInstructions :: String -> [[Int]]
parseInstructions = 
    lines >>> map (words
        >>> zip [0..]
        >>> filter (odd . fst)
        >>> map (read . snd))

solve :: Bool -> ([String], [[Int]]) -> String
solve part1 = uncurry (foldl (\crates [move, from, to] ->
        let (new_crates, taken) = 
                foldr (\(i, stack) (new_crates, taken) ->
                    if i == from then
                        let (snip, snap) = splitAt move stack in
                        (snap : new_crates, snip)
                    else
                        (stack : new_crates, taken)
                ) ([],[]) (zip [1..] crates) in
        foldr (\(i, stack) final_crates ->
            if i == to then
                ((if part1 then reverse taken else taken) ++ stack) : final_crates
            else
                stack : final_crates
        ) [] (zip [1..] new_crates)
    ))
    >>> map head

main = do
    parsedInput <- parseInput "input.txt"
    putStrLn $ "Part 1: " ++ show (solve True parsedInput)
    putStrLn $ "Part 2: " ++ show (solve False parsedInput)
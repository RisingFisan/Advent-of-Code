import Data.Functor ((<&>))
import Control.Arrow ((>>>))
import Data.List (intersect)
import Data.List.Split ( splitOn )

parseInput :: String -> IO [([Int],[Int])]
parseInput filename =
    readFile filename
    <&> (lines
    >>> map (
        splitOn "," 
        >>> map (
            splitOn "-" 
            >>> (\(a:b:_) -> [read a..read b])) 
        >>> (\(a:b:_) -> (a,b)))
    )

part1 :: [([Int],[Int])] -> Int
part1 = foldr (\(elf1, elf2) acc ->
    if elf1 `intersect` elf2 == elf2 || elf1 `intersect` elf2 == elf1 then
        acc + 1
    else
        acc
    ) 0

part2 :: [([Int],[Int])] -> Int
part2 = foldr (\(elf1, elf2) acc ->
    if not $ null $ elf1 `intersect` elf2 then
        acc + 1
    else
        acc
    ) 0

main = do
    parsedInput <- parseInput "input.txt"
    putStrLn $ "Part 1: " ++ show (part1 parsedInput)
    putStrLn $ "Part 2: " ++ show (part2 parsedInput)
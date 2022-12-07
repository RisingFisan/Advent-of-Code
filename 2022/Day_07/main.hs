{-# LANGUAGE LambdaCase #-}

import Data.Functor ((<&>))
import Data.Function ((&))
import Control.Arrow ((>>>))
import Data.List (sort, find)
import Data.Either (rights)
import Data.Maybe (fromJust)

import Data.List.Split

data FileSystem = File Int | Dir String [FileSystem] deriving Show

parseInput :: FilePath -> IO FileSystem
parseInput filename = readFile filename
    <&> (tail
    >>> splitOn "\n$ "
    >>> tail
    >>> generateFS (Dir "/" []) ["/"])

generateFS :: FileSystem -> [String] -> [String] -> FileSystem
generateFS fs curdir [] = fs
generateFS fs curdir (inst:instructions) =
    case inst of 
        ('c':'d':' ':'.':'.':_) -> generateFS fs (init curdir) instructions
        ('c':'d':' ':dirname) -> generateFS fs (curdir ++ [dirname]) instructions
        ('l':'s':'\n':t) ->
            let files = lines t in
                generateFS (createFiles fs curdir files) curdir instructions

createFiles :: FileSystem -> [String] -> [String] -> FileSystem
createFiles (Dir dirname fls) (h:t) files =
    if dirname == h then
        if null t then
            Dir dirname (map (\case
                'd':'i':'r':' ':dir -> Dir dir []
                file -> let (size,_) = break (== ' ') file in File (read size)
            ) files)
        else
            Dir dirname (map (\x -> createFiles x t files) fls)
    else
        Dir dirname fls
createFiles fs _ _ = fs

part1 :: FileSystem -> Int
part1 fs = let Right sizes = getSize fs in
    sizes
    & filter (< 100000)
    & sum

getSize :: FileSystem -> Either Int [Int]
getSize (Dir _ files) = let r = map getSize files in
    Right $ (sum . map (either id head)) r : concat (rights r)
getSize (File size) = Left size

part2 :: FileSystem -> Int
part2 fs = let Right sizes = getSize fs 
               total = head sizes in
    sizes
    & sort
    & find (> (30_000_000 - (70_000_000 - total)))
    & fromJust

main = do
    fs <- parseInput "input.txt"
    putStrLn $ "Part 1: " ++ show (part1 fs)
    putStrLn $ "Part 2: " ++ show (part2 fs)
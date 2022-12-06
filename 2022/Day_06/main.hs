import Control.Monad (foldM)
import Control.Arrow ((>>>))
import Data.List (nub)
import Data.Either (fromLeft)

solve :: Int -> String -> Int
solve n = 
    zip [1..]
    >>> foldM (\acc (i,c) -> 
        let new_acc = (if length acc == n then tail acc else acc) ++ [c] in
            if (length . nub) new_acc == n then
                Left i
            else
                Right new_acc
        ) ""
    >>> fromLeft 0

main = do
    input <- readFile "input.txt"
    putStrLn $ "Part 1: " ++ show (solve 4 input)
    putStrLn $ "Part 2: " ++ show (solve 14 input)
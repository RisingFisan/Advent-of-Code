import Data.Function ((&))
import Data.Functor ((<&>))
import Data.Char (isDigit, digitToInt, intToDigit)
import Data.List (tails)
import Data.Maybe (fromJust)

part1 =
    sum
    . map (read
        . (\l -> head l : last l : "")
        . filter isDigit)

getNumber "" = Nothing
getNumber (x:xs)
    | isDigit x = Just $ digitToInt x
    | otherwise = case x:xs of
        'o':'n':'e':_ -> Just 1
        't':'w':'o':_ -> Just 2
        't':'h':'r':'e':'e':_ -> Just 3
        'f':'o':'u':'r':_ -> Just 4
        'f':'i':'v':'e':_ -> Just 5
        's':'i':'x':_ -> Just 6
        's':'e':'v':'e':'n':_ -> Just 7
        'e':'i':'g':'h':'t':_ -> Just 8
        'n':'i':'n':'e':_ -> Just 9
        _ -> getNumber xs

getLastNumber = head . dropWhile (== Nothing) . map getNumber . reverse . tails

part2 =
    sum
    . map (read . (\line -> intToDigit (fromJust (getNumber line)) : intToDigit (fromJust (getLastNumber line)) : ""))

main = do
    input <- readFile "input.txt" <&> lines
    let ans1 = part1 input
    putStrLn $ "Part 1: " ++ show ans1
    let ans2 = part2 input
    putStrLn $ "Part 2: " ++ show ans2
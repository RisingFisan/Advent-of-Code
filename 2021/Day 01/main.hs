import System.Environment ( getArgs )

getLines :: FilePath -> IO [String]
getLines filename = lines <$> readFile filename

part1 :: [Int] -> Int
part1 lines = foldr (\(a,b) acc -> if b > a then succ acc else acc) 0 (zip lines (tail lines))

part2 :: [Int] -> Int
part2 lines = foldr (\(a,b) acc -> if b > a then succ acc else acc) 0 (zip windows (tail windows))
    where windows = [ a + b + c | (a,b,c) <- zip3 lines (tail lines) (tail (tail lines)) ]

main :: IO ()
main = do
    args <- getArgs
    let filename = if not (null args) then head args else "input"
    lines <- map read <$> getLines filename
    
    let ans1 = part1 lines
    putStrLn $ unwords ["Part 1:", show ans1]

    let ans2 = part2 lines
    putStrLn $ unwords ["Part 1:", show ans2]
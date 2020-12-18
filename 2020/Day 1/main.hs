part1 :: [Int] -> Int
part1 l = head [a*b | a <- l, b <- l, a + b == 2020]

part2 :: [Int] -> Int
part2 l = head [a*b*c | a <- l, b <- l, c <- l, a + b + c == 2020]

main :: IO ()
main = do
    lines <- map read . lines <$> readFile "input"
    let ans1 = part1 lines
    putStrLn $ "Part 1 = " ++ show ans1

    let ans2 = part2 lines
    putStrLn $ "Part 2 = " ++ show ans2
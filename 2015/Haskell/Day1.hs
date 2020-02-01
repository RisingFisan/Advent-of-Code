part1 :: IO Int
part1 = do
    file <- readFile "Day1Input.txt"
    let final_floor = foldl (\acc inst -> if inst == '(' then acc + 1 else acc - 1) 0 file
    print "Answer to part 1:"
    return final_floor

part2 :: IO Int
part2 = do
    file <- readFile "Day1Input.txt"
    let floors = scanl (\acc inst -> if inst == '(' then acc + 1 else acc - 1) 0 file
    let answer_part2 = find_basement floors
    print "Answer to part 2:"
    return answer_part2

    where find_basement :: [Int] -> Int
          find_basement (h:t)
              | h == -1 = 0
              | otherwise = 1 + find_basement t

main :: IO Int
main = do
    answer1 <- part1
    print answer1
    part2
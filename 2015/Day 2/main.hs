part1 :: IO Int
part1 = do
    file <- readFile "Day2Input.txt"
    let presents = map (\x -> [read num | num <- splitOn "x" x]) (lines file)
    let total_area = foldl (\acc present -> acc + sum (areas present) + minimum (areas present)) 0 presents
    return total_area

    where areas :: [Int] -> [Int]
          areas (l:w:h:_) = [l*w,l*w,l*h,l*h,w*h,w*h]

part2 :: IO Int
part2 = do
    file <- readFile "Day2Input.txt"
    let presents = map (\x -> [read num | num <- splitOn "x" x]) (lines file)
    let total_length = foldl (\acc present -> acc + minimum (diff_perimeters present) + product present) 0 presents
    return total_length

    where diff_perimeters :: [Int] -> [Int]
          diff_perimeters (l:w:h:_) = map (*2) [l+w,w+h,l+h]

splitOn :: Eq a => [a] -> [a] -> [[a]]
splitOn _ [] = [[]]
splitOn del list
    | del == take (length del) list = []:splitOn del (drop (length del) list)
    | otherwise = (head list : h) : t
    where h:t = splitOn del (tail list)

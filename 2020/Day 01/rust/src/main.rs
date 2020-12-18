use std::{
    fs::File,
    io::{prelude::*, BufReader},
    path::Path,
};

fn main() {
    let file = File::open("../input").expect("Error - no file found");
    let buf = BufReader::new(file);
    let numbers : Vec<i32> = buf.lines()
                                .map(|l| l.expect("Could not read line")
                                                             .parse::<i32>()
                                                             .expect("Could not parse line as int"))
                                .collect();
    
    for i in 0..numbers.len() {
        for j in i..numbers.len() {
            for k in j..numbers.len() {
                if numbers[i] + numbers[j] + numbers[k] == 2020 {
                    println!("Part 2 = {}", numbers[i]*numbers[j]*numbers[k])
                }
            }
            if numbers[i] + numbers[j] == 2020 {
                println!("Part 1 = {}",numbers[i]*numbers[j]);
            }
        }
    }
}

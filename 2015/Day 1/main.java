import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day1 {
    public static void main(String[] args) {
        int answer1 = part1();
        System.out.printf("Answer to part 1: %d\n",answer1);
        int answer2 = part2();
        System.out.printf("Answer to part 2: %d\n",answer2);
    }

    public static int part1() {
        try {
            File file = new File("Day1Input.txt");
            Scanner fileReader = new Scanner(file);
            fileReader.useDelimiter("");
            int floor = 0;
            while(fileReader.hasNext()) {
                String inst = fileReader.next();
                if(inst.compareTo("(") == 0) floor++;
                else floor--;
            }
            fileReader.close();
            return floor;
        }
        catch (FileNotFoundException e) {
            System.out.println("An error occurred");
            e.printStackTrace();
            return -1;
        }
    }

    public static int part2() {
        try {
            File file = new File("Day1Input.txt");
            Scanner fileReader = new Scanner(file);
            fileReader.useDelimiter("");
            int floor = 0, i = 0;
            while(fileReader.hasNext()) {
                String inst = fileReader.next();
                if(inst.compareTo("(") == 0) floor++;
                else floor--;
                i++;
                if(floor == -1) break;
            }
            fileReader.close();
            return i;
        }
        catch (FileNotFoundException e) {
            System.out.println("An error occurred");
            e.printStackTrace();
            return -1;
        }
    }
}

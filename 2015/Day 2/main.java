import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;


public class Day2 {
    public static void main(String[] args) {
        try {
            File file = new File("Day2Input.txt");
            Scanner fileReader = new Scanner(file);
            fileReader.useDelimiter("\r\n");
            int total_area = 0;
            int total_length = 0;

            while(fileReader.hasNext()) {
                String line = fileReader.next();

                Scanner lineReader = new Scanner(line);
                lineReader.useDelimiter("x");
                int[] dimensions = new int[3];
                for(int i = 0; i < 3; i++)
                    dimensions[i] = lineReader.nextInt();
                int[] areas = {dimensions[0] * dimensions[1], dimensions[0] * dimensions[2], dimensions[1] * dimensions[2]};
                int[] perimeters = {2 * (dimensions[0] + dimensions[1]), 2 * (dimensions[0] + dimensions[2]), 2 * (dimensions[1] + dimensions[2])};
                int min_area = areas[0];
                for(int area : areas) {
                    total_area += 2 * area;
                    if(area < min_area) min_area = area;
                }
                total_area += min_area;
                int min_perimeter = perimeters[0];
                for(int perimeter : perimeters)
                    if(perimeter < min_perimeter) min_perimeter = perimeter;
                total_length += min_perimeter + (dimensions[0] * dimensions[1] * dimensions[2]);
                lineReader.close();
            }
            fileReader.close();

            System.out.println(String.format("Answer to part 1: %d", total_area));
            System.out.println(String.format("Answer to part 2: %d", total_length));
        }
        catch(FileNotFoundException e) {
            System.out.println("An error occurred");
            e.printStackTrace();
        }
    }
}
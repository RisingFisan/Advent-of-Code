#include <stdio.h>

int part1() {
    FILE *file = fopen("Day1Input.txt","r");
    int final_floor = 0;
    char inst;
    while((inst = fgetc(file)) != EOF) {
        if(inst == '(') final_floor++;
        else final_floor--;
    }
    return final_floor;
}

int part2() {
    FILE *file = fopen("Day1Input.txt","r");
    int floor = 0, i = 0;
    char inst;
    while((inst = fgetc(file)) != EOF) {
        if(inst == '(') floor++;
        else floor--;
        i++;
        if(floor == -1) return i;
    }
}

int main(int argc, char const *argv[]) {
    int answer1 = part1();
    printf("Answer to part 1: %d\n",answer1);
    int answer2 = part2();
    printf("Answer to part 2: %d\n",answer2);
    return 0;
}

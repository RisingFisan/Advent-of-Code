#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#define MAXSIZE 100

int sum(int *array, int n) {
    int total = 0;
    for(int i = 0; i < n; i++)
        total += array[i];
    return total;
}

int min(int *array, int n) {
    int answer = INT_MAX;
    for(int i = 0; i < n; i++)
        if(array[i] < answer) answer = array[i];
    return answer;
}

int main(int argc, char const *argv[]) {
    FILE *file = fopen("Day2Input.txt","r");
    int total_area = 0, total_length = 0;
    int length, width, height;
    char *dimensions = malloc(MAXSIZE);

    while(fgets(dimensions,MAXSIZE,file) != NULL) {
        sscanf(dimensions,"%dx%dx%d",&length,&width,&height);

        int areas[3] = {length * width, length * height, width * height};
        total_area += 2 * sum(areas,3) + min(areas,3);

        int perimeters[3] = {2 * (length + width), 2 * (length + height), 2 * (height + width)};
        total_length += min(perimeters,3) + (length * width * height);
    }

    printf("Answer to part 1: %d\n", total_area);
    printf("Answer to part 2: %d\n", total_length);
    
    return 0;
}

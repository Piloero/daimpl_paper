#include <stdio.h>

static int redundant(int a, int b) {
    if (a > 5) {
        printf("Going to return %i!\n", a + b);
    }

    return a + b;
}

int main() {
    redundant(10, 5);
}


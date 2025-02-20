#include "mpi.h"
#include <stdio.h>

int fibonacci(int n) {
    if (n <= 1) return n;
    
    int a = 0, b = 1, c;
    for (int i = 2; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    return b;
}

int main(int argc, char *argv[]) {
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank % 2 == 0) {
        int fact = 1;
        for (int i = 1; i <= rank; i++) {
            fact *= i;
        }
        printf("Rank %d (Even) -> Factorial: %d\n", rank, fact);
    } else {
        printf("Rank %d (Odd) -> Fibonacci Series: ", rank);
        for (int i = 0; i <= rank; i++) {
            printf("%d ", fibonacci(i));
        }
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}

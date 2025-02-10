#include "mpi.h"
#include <stdio.h>

int main(int argc, char *argv[]) {
    int rank, size, N, A[10], B[10], c, i;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        N = size;  // Assuming the number of values matches the number of processes
        printf("Enter %d values:\n", N);
        fflush(stdout);
        for (i = 0; i < N; i++) {
            scanf("%d", &A[i]);
        }
    }

    // Scatter the array A so that each process gets one integer
    MPI_Scatter(A, 1, MPI_INT, &c, 1, MPI_INT, 0, MPI_COMM_WORLD);

    // Each process prints the value it has received
    printf("I have received %d in process %d\n", c, rank);
    fflush(stdout);

    // Each process squares its received number
    c = c * c;

    // Gather the squared numbers into array B at the root process (rank 0)
    MPI_Gather(&c, 1, MPI_INT, B, 1, MPI_INT, 0, MPI_COMM_WORLD);

    // Process 0 prints the gathered results
    if (rank == 0) {
        printf("The Result gathered in the root:\n");
        fflush(stdout);
        for (i = 0; i < N; i++) {
            printf("%d\t", B[i]);
        }
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}

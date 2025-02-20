#include <mpi.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define max 99
int main(int argc, char *argv[]) {
    int rank, size, n;
    char input[100], local_result[100] = "", cumulative_result[500] = "";
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0) {
        printf("Enter a word: ");
        fflush(stdout);
        fgets(input , max , stdin);
        n = strlen(input);
    }
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(input, max , MPI_CHAR, 0, MPI_COMM_WORLD);
    if (rank < n) {
        char local_char = input[rank];
        for (int i = 0; i <= rank; i++) {
            local_result[i] = local_char;
        }
    }
    MPI_Gather(local_result, 100, MPI_CHAR, cumulative_result, 100, MPI_CHAR, 0, MPI_COMM_WORLD);
    if (rank == 0) {
        char final_result[500] = "";
        for (int i = 0; i < n; i++) {
            strcat(final_result, &cumulative_result[i * 100]);
        }
        printf("Transformed string: %s\n", final_result);
    }    
    MPI_Finalize();
    return 0;
}
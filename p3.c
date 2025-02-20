#include "mpi.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    int rank, size;
    char buf[1024];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter the word: ");
        fflush(stdout);
        scanf("%s", buf);
    }

    MPI_Bcast(buf, 1024, MPI_CHAR, 0, MPI_COMM_WORLD);

    int len = strlen(buf);
    if (rank < len) {
        if (islower(buf[rank])) {
            buf[rank] = toupper(buf[rank]);
        } else if (isupper(buf[rank])) {
            buf[rank] = tolower(buf[rank]);
        }
    }

    MPI_Gather(&buf[rank], 1, MPI_CHAR, buf, 1, MPI_CHAR, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Toggled string: %s\n", buf);
    }

    MPI_Finalize();
    return 0;
}

#include <mpi.h>
#include <stdio.h>
#include <string.h>

#define MAX_STRING_LENGTH 100

// Function to reverse a string in place.
void reverse_string(char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp         = str[i];
        str[i]            = str[len - i - 1];
        str[len - i - 1]  = temp;
    }
}

int main(int argc, char *argv[]) {
    int rank, size;
    char local_string[MAX_STRING_LENGTH];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // The root process will read all the strings.
    // We assume one string per process, so create a 2D array with 'size' rows.
    char all_strings[size][MAX_STRING_LENGTH];

    if (rank == 0) {
        printf("Enter %d strings:\n", size);
        for (int i = 0; i < size; i++) {
            scanf("%s", all_strings[i]);
        }
    }

    // Scatter one string from the root's all_strings to each process.
    MPI_Scatter(all_strings, MAX_STRING_LENGTH, MPI_CHAR,
                local_string, MAX_STRING_LENGTH, MPI_CHAR,
                0, MPI_COMM_WORLD);

    // Each process reverses its own string.
    reverse_string(local_string);

    // Gather the reversed strings back at the root process.
    MPI_Gather(local_string, MAX_STRING_LENGTH, MPI_CHAR,
               all_strings, MAX_STRING_LENGTH, MPI_CHAR,
               0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("\nReversed strings:\n");
        for (int i = 0; i < size; i++) {
            printf("%s\n", all_strings[i]);
        }
    }

    MPI_Finalize();
    return 0;
}

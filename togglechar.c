#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX 99

int main(int argc, char* argv[]){
    int rank, size, n;
    char str[MAX];
    char toggled;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if(rank == 0){
        printf("Enter a string (max length %d): ", MAX-1);
        fflush(stdout);
        fgets(str, MAX, stdin);
        n = strlen(str);
        if(str[n-1] == '\n'){
            str[n-1] = '\0';
            n--;
        }
    }
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(str, MAX, MPI_CHAR, 0, MPI_COMM_WORLD);
    if(rank < n){
        char c = str[rank];
        if(c >= 'A' && c <= 'Z')
            toggled = c + ('a' - 'A');
        else if(c >= 'a' && c <= 'z')
            toggled = c - ('a' - 'A');
        else
            toggled = c;
    } else {
        toggled = '\0';
    }
    char gathered[MAX];
    MPI_Gather(&toggled, 1, MPI_CHAR, gathered, 1, MPI_CHAR, 0, MPI_COMM_WORLD);
    if(rank == 0){
        gathered[n] = '\0';
        printf("Final toggled string: %s\n", gathered);
    }
    MPI_Finalize();
    return 0;
}

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char *argv[]){
    int rank, size, x;
    MPI_Init(&argc, &argv);                       
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);           
    MPI_Comm_size(MPI_COMM_WORLD, &size);         
    if(rank == 0){
        printf("Enter the value of X : ");
        fflush(stdout);
        scanf("%d", &x);
    }
    MPI_Bcast(&x, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int ans = (int)pow(x, rank);
    printf("Process %d: %d^%d = %d\n", rank, x, rank, ans);
    MPI_Finalize();                                  
    return 0;
}

// int MPI_Bcast(void *buffer, int count, MPI_Datatype datatype, int root, MPI_Comm comm);

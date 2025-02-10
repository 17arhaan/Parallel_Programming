#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char* argv[]){
    int rank, size, num;
    MPI_Init(&argc , &argv);
    MPI_Comm_rank(MPI_COMM_WORLD , &rank);
    MPI_Comm_size(MPI_COMM_WORLD , &size);
    MPI_Status status;
    if (rank == 0){
        printf("Enter Number : ");
        fflush(stdout);
        scanf("%d",&num);
        MPI_Send(&num , 1 , MPI_INT , 1 , 0 , MPI_COMM_WORLD);
        fflush(stdout);
        fprintf(stdout,"Process 0 : message sent..\n");
    } else {
        MPI_Recv( &num, 1 , MPI_INT , 0 , 0, MPI_COMM_WORLD, &status);
        fflush(stdout);
        fprintf(stdout,"Process 1 : %d  (message) recieved..\n",num);
        MPI_Finalize();
    }
    MPI_Finalize();
    return 0;
}
#include "mpi.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    int rank, size;
    char msg[200];
    char rcv[200];
    int size2;
    MPI_Status status;
    
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(!rank){
        printf("Enter the message : ");
        fflush(stdout);
        scanf("%s",msg);

        MPI_Ssend(&msg,sizeof(msg),MPI_CHAR,1,0,MPI_COMM_WORLD);
        size2 = sizeof(msg);
        MPI_Ssend(&size2,1,MPI_INT,1,0,MPI_COMM_WORLD);
        MPI_Recv(&msg,size2,MPI_CHAR,0,0,MPI_COMM_WORLD,&status);
        printf("The message is : %s",msg);


    }
    else if(rank == 1){

        MPI_Recv(&size2,1,MPI_INT,0,0,MPI_COMM_WORLD,&status);
        MPI_Recv(&rcv,size2,MPI_CHAR,0,0,MPI_COMM_WORLD,&status);

        for(int i = 0;i<size2;i++){
            if(rcv[i] >= 'A' && rcv[i] <= 'Z'){
                rcv[i] = rcv[i] +32;
            }
            else{
                rcv[i] = rcv[i] - 32;
            }
            
        }
        MPI_Ssend(&rcv,sizeof(msg),MPI_CHAR,0,0,MPI_COMM_WORLD);

    }

    MPI_Finalize();
    return 0;

}
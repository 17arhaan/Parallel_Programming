#include <stdio.h>
#include "mpi.h"

int main(int argc , char *argv[]){
    int rank,size;
    int num1,num2;


    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    if(!rank){
        printf("Enter number 1 : \n");
        fflush(stdout);
        scanf("%d",&num1);
        printf("Enter second number : \n");
        fflush(stdout);
        scanf("%d",&num2);
    }

    MPI_Bcast(&num1,1,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Bcast(&num2,1,MPI_INT,0,MPI_COMM_WORLD);

    if(rank == 1){
        printf("The sum of number is : %d \n",num1+num2);
    }
    else if(rank == 2){
        printf("The product of numbers is : %d \n",num1*num2);
    }
    else if(rank ==3){
        printf("The difference of numbers is : %d \n",num1-num2);
    }

    MPI_Finalize();
    return 0;
}
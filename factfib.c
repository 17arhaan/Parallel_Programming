#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int factorial(int number){
    int factt = 1;
    for(int i = 1 ; i <= number ; i ++){
        factt *= i;
    }
    return factt;
}
int fibonacci(int number){
    int fibb;
    if(number == 0){
        return 0;
    } else if ( number == 1){
        return 1;
    } else {
        fibb = fibonacci(number - 1) + fibonacci(number - 2);
        return fibb;
    }
    return fibb;
}

int main(int argc , char* argv[]){
    int rank , size;
    MPI_Init(&argc ,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD , &rank);
    MPI_Comm_size(MPI_COMM_WORLD , &size);
    if(rank % 2 == 0){
        int factt = factorial(rank);
        printf("Process %d | Factorial --> %d.\n",rank,factt);
    } else {
        int fibb = fibonacci(rank);
        printf("Process %d | Fibonacci --> %d.\n",rank,fibb);  
    }
    MPI_Finalize();
    return 0;
}
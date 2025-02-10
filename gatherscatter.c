#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
int main(int argc , char*argv[]){
    int rank , size;
    int c , i;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    int a[size] , b[size];
    if (rank == 0) {
        printf("Enter %d Elements ---> : ",size);
        fflush(stdout);
        for (int i = 0 ; i < size ; i ++){
            scanf("%d",&a[i]);
        }
    }
    MPI_Scatter(a , 1 , MPI_INT , &c , 1 , MPI_INT , 0 , MPI_COMM_WORLD);
    printf("I have received %d in process %d\n", c, rank);
    fflush(stdout);
    c = c * c;
    MPI_Gather(&c,1,MPI_INT,b,1,MPI_INT,0,MPI_COMM_WORLD);
    if (rank == 0) {
        printf("The Result gathered in the root:\n");
        fflush(stdout);
        for (i = 0; i < size; i++) {
            printf("%d\t", b[i]);
        } printf("\n");
    }
    MPI_Finalize();
    return 0;
}
#include <stdio.h>
#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int value;
    MPI_Status status;

    int pack_size;
    MPI_Pack_size(1, MPI_INT, MPI_COMM_WORLD, &pack_size);
    int bsize = pack_size + MPI_BSEND_OVERHEAD;
    char *buffer = malloc(bsize);

    MPI_Buffer_attach(buffer, bsize);

    if (rank == 0)
    {
        int arr[size];
        printf("Enter Elements : ");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            scanf("%d", &arr[i]);
        }
        for (int i = 0; i < size; i++)
        {
            MPI_Bsend(&arr[i], 1, MPI_INT, i, 0, MPI_COMM_WORLD);
        }
    }

    MPI_Recv(&value, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);

    if (rank % 2 == 0)
    {
        int result = value * value;
        printf("Process %d , Recieved %d - Square %d\n", rank, value, result);
    }
    else
    {
        int result = value * value * value;
        printf("Process %d , Recieved %d - Cube %d\n", rank, value, result);
    }

    MPI_Buffer_detach(&buffer, &bsize);
    free(buffer);

    MPI_Finalize();
    return 0;
}
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void rowsum(int *a, int n, int *row)
{
    int i = (blockIdx.x * blockDim.x) + threadIdx.x;
    row[i] = 0;
    for (int j = 0; j < n; ++j)
    {
        row[i] += a[(i * n) + j];
    }
    return;
}

__global__ void colsum(int *a, int n, int *col)
{
    int i = (blockIdx.x * blockDim.x) + threadIdx.x;
    col[i] = 0;
    for (int j = 0; j < n; ++j)
    {
        col[i] += a[(j * n) + i];
    }
    return;
}

__global__ void replace(int *a, int n, int *row, int *col)
{
    int i = blockIdx.x;
    int j = threadIdx.x;
    a[(i * n) + j] = row[i] + col[j];
    return;
}

int main()
{
    int *a, m, n, *da, *drow, *dcol;
    printf("enter m and n\n");
    scanf("%d %d", &m, &n);
    a = (int *)malloc(sizeof(int) * m * n);
    printf("enter a\n");
    for (int i = 0; i < m; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            scanf("%d", &a[(i * n) + j]);
        }
    }
    cudaMalloc((void **)&da, sizeof(int) * m * n);
    cudaMalloc((void **)&drow, sizeof(int) * m);
    cudaMalloc((void **)&dcol, sizeof(int) * n);
    cudaMemcpy(da, a, sizeof(int) * m * n, cudaMemcpyHostToDevice);
    rowsum<<<1, m>>>(da, n, drow);
    colsum<<<1, n>>>(da, n, dcol);
    replace<<<m, n>>>(da, n, drow, dcol);
    cudaMemcpy(a, da, sizeof(int) * m * n, cudaMemcpyDeviceToHost);
    printf("answer\n");
    for (int i = 0; i < m; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            printf("%d ", a[(i * n) + j]);
        }
        printf("\n");
    }
    cudaFree(da);
    cudaFree(drow);
    cudaFree(dcol);
    return 0;
}
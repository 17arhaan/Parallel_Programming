#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void rowsum(int *a, int *ans, int n){
    int id = (blockIdx.x * blockDim.x) + threadIdx.x;
    ans[id] = 0;
    for(int i = 0; i < n; ++i){
        ans[id] += a[(id * n) + i];
    }
    return;
}

__global__ void colsum(int *a, int *ans, int m, int n){
    int id = (blockIdx.x * blockDim.x) + threadIdx.x;
    ans[id] = 0;
    for(int i = 0; i < m; ++i){
        ans[id] += a[(i * n) + id];
    }
    return;
}

__global__ void solve(int *a, int *row, int *col){
    int r = blockIdx.x;
    int c = threadIdx.x;
    if(a[(r * blockDim.x) + c] % 2 == 0){
        a[(r * blockDim.x) + c] = row[r];
    }
    else{
        a[(r * blockDim.x) + c] = col[c];
    }
    return;
}

int main(){
    int *a, *drow, *dcol, *da, m, n;
    printf("enter m and n\n");
    scanf("%d %d", &m, &n);
    a = (int *)malloc(sizeof(int) * m * n);
    printf("enter a\n");
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &a[(i * n) + j]);
        }
    }
    cudaMalloc((void **)&da, m * n * sizeof(int));
    cudaMalloc((void **)&drow, m * sizeof(int));
    cudaMalloc((void **)&dcol, n * sizeof(int));
    cudaMemcpy(da, a, m * n * sizeof(int), cudaMemcpyHostToDevice);
    rowsum<<<1, m>>>(da, drow, n);
    colsum<<<1, n>>>(da, dcol, m, n);
    solve<<<m, n>>>(da, drow, dcol);
    cudaMemcpy(a, da, m * n * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            printf("%d ", a[(i * n) + j]);
        }
        printf("\n");
    }
    cudaFree(da);
    cudaFree(drow);
    cudaFree(dcol);
    return 0;
}
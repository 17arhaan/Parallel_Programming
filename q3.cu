#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void add(int *a, int *b, int m, int n, int *ans){
    int r = blockIdx.x;
    int c = threadIdx.x;
    ans[(r * n) + c] = a[(r * n) + c] + b[(r * n) + c];
    return;
}

int main(){
    int *a, *b, *ans, m, n, *da, *db, *dans;
    printf("enter m and n\n");
    scanf("%d %d", &m, &n);
    a = (int *)malloc(m * n * sizeof(int));
    b = (int *)malloc(m * n * sizeof(int));
    ans = (int *)malloc(m * n * sizeof(int));
    printf("enter a\n");
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &a[(i * n) + j]);
        }
    }
    printf("enter b\n");
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &b[(i * n) + j]);
        }
    }
    cudaMalloc((void **)&da, m * n * sizeof(int));
    cudaMalloc((void **)&db, m * n * sizeof(int));
    cudaMalloc((void **)&dans, m * n * sizeof(int));
    cudaMemcpy(da, a, m * n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, m * n * sizeof(int), cudaMemcpyHostToDevice);
    add<<<m, n>>>(da, db, m, n, dans);
    cudaMemcpy(ans, dans, m * n * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            printf("%d ", ans[(i * n) + j]);
        }
        printf("\n");
    }
    cudaFree(a);
    cudaFree(b);
    cudaFree(ans);
    return 0;
}
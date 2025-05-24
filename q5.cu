#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void mul(int *a, int *b, int *ans, int m1, int n1, int n2){
    int id = (blockIdx.x * blockDim.x) + threadIdx.x;
    for(int i = 0; i < m1; ++i){
        ans[(i * n2) + id] = 0;
        for(int j = 0; j < n1; ++j){
            ans[(i * n2) + id] += a[(i * n1) + j] * b[(j * n2) + id];
        }
    }
    return;
}

int main(){
    int *a, *b, *ans, *da, *db, *dans, m1, n1, m2, n2;
    printf("enter m1, n1, m2, n2\n");
    scanf("%d %d %d %d", &m1, &n1, &m2, &n2);
    a = (int *)malloc(sizeof(int) * m1 * n1);
    b = (int *)malloc(sizeof(int) * m2 * n2);
    ans = (int *)malloc(sizeof(int) * m1 * n2);
    printf("enter a\n");
    for(int i = 0; i < m1; ++i){
        for(int j = 0; j < n1; ++j){
            scanf("%d", &a[(i * n1) + j]);
        }
    }
    printf("enter b\n");
    for(int i = 0; i < m2; ++i){
        for(int j = 0; j < n2; ++j){
            scanf("%d", &b[(i * n2) + j]);
        }
    }
    cudaMalloc((void **)&da, sizeof(int) * m1 * n1);
    cudaMalloc((void **)&db, sizeof(int) * m2 * n2);
    cudaMalloc((void **)&dans, sizeof(int) * m1 * n2);
    cudaMemcpy(da, a, sizeof(int) * m1 * n1, cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, sizeof(int) * m2 * n2, cudaMemcpyHostToDevice);
    mul<<<1, n2>>>(da, db, dans, m1, n1, n2);
    cudaMemcpy(ans, dans, sizeof(int) * m1 * n2, cudaMemcpyDeviceToHost);
    for(int i = 0; i < m1; ++i){
        for(int j = 0; j < n2; ++j){
            printf("%d ", ans[(i * m1) + j]);
        }
        printf("\n");
    }
    cudaFree(da);
    cudaFree(db);
    cudaFree(dans);
    return 0;
}
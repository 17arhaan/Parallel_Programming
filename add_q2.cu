#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void diagonal(int *a){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    a[(i * blockDim.x) + i] = 0;
    return;
}

__global__ void factorial(int *a){
    int i = (blockIdx.x * blockDim.x) + threadIdx.x;
    for(int j = i + 1; j < blockDim.x; ++j){
        int add = a[(i * blockDim.x) + j];
        int val = 1;
        while(add > 0){
            val *= add;
            add -= 1;
        }
        a[(i * blockDim.x) + j] = val;
    }
    return;
}

__global__ void summ(int *a){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    for(int j = 0; j < i; ++j){
        int val = a[(i * blockDim.x) + j];
        int add = 0;
        while(val > 0){
            add += val % 10;
            val /= 10;
        }
        a[(i * blockDim.x) + j] = add;
    }
    return;
}

int main(){
    int *a, n, *da;
    printf("enter n\n");
    scanf("%d", &n);
    a = (int *)malloc(sizeof(int) * n * n);
    printf("enter a\n");
    for(int i = 0; i < n; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &a[(i * n) + j]);
        }
    }
    cudaMalloc((void **)&da, n * n * sizeof(int));
    cudaMemcpy(da, a, n * n * sizeof(int), cudaMemcpyHostToDevice);
    diagonal<<<1, n>>>(da);
    factorial<<<1, n>>>(da);
    summ<<<1, n>>>(da);
    cudaMemcpy(a, da, n * n * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < n; ++i){
        for(int j = 0; j < n; ++j){
            printf("%d ", a[(i * n) + j]);
        }
        printf("\n");
    }
    cudaFree(da);
    return 0;
}
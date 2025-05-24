#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void create(char *input, int n, char *ans){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i < n){
        int j = (i * (i + 1)) / 2;
        for (int k = 0; k < i + 1; ++k){
            ans[j + k] = input[i];
        }
    }
    return;
}

int main(){
    char *input, *dinput, *ans, *dans;
    int n;
    printf("enter length of string\n");
    scanf("%d", &n);
    getchar();
    printf("enter string\n");
    input = (char *)malloc((n + 1) * sizeof(char));
    fgets(input, n + 1, stdin);
    ans = (char *)malloc((((n * (n + 1)) / 2) + 1) * sizeof(char));
    cudaMalloc((void **)&dinput, (n + 1) * sizeof(char));
    cudaMalloc((void **)&dans, (((n * (n + 1)) / 2) + 1) * sizeof(char));
    cudaMemcpy(dinput, input, (n + 1) * sizeof(char), cudaMemcpyHostToDevice);
    create<<<1, n>>>(dinput, n, dans);
    cudaMemcpy(ans, dans, (((n * (n + 1)) / 2) + 1) * sizeof(char), cudaMemcpyDeviceToHost);
    cudaFree(dinput);
    cudaFree(dans);
    printf("answer - %s", ans);
    return 0;
}
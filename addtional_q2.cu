#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void create(char *input, char *ans, int n, int l){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if(i < l){
        char c = input[i];
        for(int j = 0; j < n; ++j){
            ans[i + (l * j)] = c;
        }
    }
    return;
}

int main(){
    char *input, *dinput, *ans, *dans;
    int n, l;
    printf("enter length of string\n");
    scanf("%d", &l);
    getchar();
    input = (char *)malloc((l + 1) * sizeof(char));
    printf("enter n value\n");
    scanf("%d", &n);
    getchar();
    ans = (char *)malloc(((l * n) + 1) * sizeof(char));
    printf("enter string\n");
    fgets(input, l + 1, stdin);
    cudaMalloc((void **)&dinput, (l + 1) * sizeof(char));
    cudaMalloc((void **)&dans, ((l * n) + 1) * sizeof(char));
    cudaMemcpy(dinput, input, (l + 1) * sizeof(char), cudaMemcpyHostToDevice);
    create<<<1, l>>>(dinput, dans, n, l);
    cudaMemcpy(ans, dans, ((n * l) + 1) * sizeof(char), cudaMemcpyDeviceToHost);
    ans[(n * l)] = '\0';
    printf("answer - %s", ans);
    cudaFree(dans);
    cudaFree(dinput);
    return 0;
}
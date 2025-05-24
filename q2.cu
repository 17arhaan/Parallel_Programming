#include <stdio.h>
#include <stdlib.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void newstring(char *inp, char *ans, int l){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i < l){
        int copy = l - i;
        int j = ((l * (l + 1)) / 2) - ((copy * (copy + 1)) / 2);
        for(int k = 0; k < copy; ++k){
            ans[j + k] = inp[k];
        }
    }
    return;
}

int main(){
    char *arr, *ans;
    int l;
    printf("enter word length\n");
    scanf("%d", &l);
    printf("enter word\n");
    arr = (char *)malloc(sizeof(char) * (l + 1));
    scanf("%s", arr);
    ans = (char *)malloc(sizeof(char) * (((l * (l + 1)) / 2) + 1));
    char *darr, *dans;
    cudaMalloc((void **)&darr, sizeof(char) * (l + 1));
    cudaMalloc((void **)&dans, sizeof(char) * (((l * (l + 1)) / 2) + 1));
    cudaMemcpy(darr, arr, sizeof(char) * (l + 1), cudaMemcpyHostToDevice);
    newstring<<<1, 100>>>(darr, dans, l);
    cudaMemcpy(ans, dans, sizeof(char) * (((l * (l + 1)) / 2) + 1), cudaMemcpyDeviceToHost);
    cudaFree(darr);
    cudaFree(dans);
    printf("%s", ans);
    return 0;
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void find(char *arr, int la, char *word, int lw, int *ans) {
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i + lw <= la) {
        int found = 1;
        for (int j = 0; j < lw; ++j) {
            if (word[j] != arr[i + j]) {
                found = 0;
                break;
            }
        }
        if (found == 1) {
            atomicAdd(ans, 1);
        }
    }
}

int main() {
    int la, lw, ans = 0, *dans;
    char *arr, *word, *darr, *dword;

    printf("Enter string length\n");
    scanf("%d", &la);
    getchar();

    arr = (char *)malloc(sizeof(char) * (la + 1));
    
    printf("Enter string\n");
    fgets(arr, la + 1, stdin);

    printf("Enter word size\n");
    scanf("%d", &lw);
    getchar();

    word = (char *)malloc(sizeof(char) * (lw + 1));
    
    printf("Enter word\n");
    fgets(word, lw + 1, stdin);

    cudaMalloc((void **)&darr, sizeof(char) * (la + 1));
    cudaMalloc((void **)&dword, sizeof(char) * (lw + 1));
    cudaMalloc((void **)&dans, sizeof(int));

    cudaMemcpy(darr, arr, sizeof(char) * (la + 1), cudaMemcpyHostToDevice);
    cudaMemcpy(dword, word, sizeof(char) * (lw + 1), cudaMemcpyHostToDevice);
    cudaMemset(dans, 0, sizeof(int));

    int threadsPerBlock = 256;
    int blocksPerGrid = (la + threadsPerBlock - 1) / threadsPerBlock;

    find<<<blocksPerGrid, threadsPerBlock>>>(darr, la, dword, lw, dans);

    cudaMemcpy(&ans, dans, sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(dans);
    cudaFree(darr);
    cudaFree(dword);

    printf("Occurrences: %d\n", ans);

    free(arr);
    free(word);

    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void reverse(char *string, int n){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i < n && (string[i] == ' ' || i == 0)){
        if (i == 0){
            i -= 1;
        }
        int j = i + 1;
        while (string[j] != '\0' && string[j] != ' '){
            j += 1;
        }
        j -= 1;
        if (j - i > 0){
            i += 1;
            for(int k = 0; k < (j - i) / 2; ++k){
                char t = string[i + k];
                string[i + k] = string[j - k];
                string[j - k] = t;
            }
        }
    }
    return;
}

int main(){
    char *string, *dstring;
    int n;
    printf("enter the string length\n");
    scanf("%d", &n);
    getchar();
    string = (char *)malloc((n + 1) * sizeof(char));
    printf("enter the string\n");
    fgets(string, n + 1, stdin);
    cudaMalloc((void **)&dstring, (n + 1) * sizeof(char));
    cudaMemcpy(dstring, string, (n + 1) * sizeof(char), cudaMemcpyHostToDevice);
    reverse<<<1, n>>>(dstring, n);
    cudaMemcpy(string, dstring, (n + 1) * sizeof(char), cudaMemcpyDeviceToHost);
    printf("answer - %s", string);
    return 0;
}
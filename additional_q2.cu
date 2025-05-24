#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void makestr(char *a, int *prefix, int n, char *ans)
{
    int i = blockIdx.x;
    int j = threadIdx.x;
    for (int k = prefix[(i * n) + j]; k < prefix[(i * n) + j + 1]; ++k)
    {
        ans[k] = a[(i * n) + j];
    }
    return;
}
int main()
{
    char *a, *ans, *da, *dans;
    int *prefix, m, n, *dprefix;
    printf("enter m and n\n");
    scanf("%d %d", &m, &n);
    a = (char *)malloc(sizeof(char) * m * n);
    prefix = (int *)malloc(sizeof(int) * ((m * n) + 1));
    printf("enter a\n");
    for (int i = 0; i < m; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            getchar();
            scanf("%c", &a[(i * n) + j]);
        }
    }
    printf("enter b\n");
    prefix[0] = 0;
    for (int i = 0; i < m; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            int val = 0;
            scanf("%d", &val);
            prefix[(i * n) + j + 1] = prefix[(i * n) + j] + val;
        }
    }
    ans = (char *)malloc(sizeof(char) * (prefix[m * n] + 1));
    cudaMalloc((void **)&da, sizeof(char) * m * n);
    cudaMalloc((void **)&dans, sizeof(char) * prefix[m * n]);
    cudaMalloc((void **)&dprefix, sizeof(int) * ((m * n) + 1));
    cudaMemcpy(da, a, sizeof(char) * m * n, cudaMemcpyHostToDevice);
    cudaMemcpy(dprefix, prefix, sizeof(int) * ((m * n) + 1), cudaMemcpyHostToDevice);
    makestr<<<m, n>>>(da, dprefix, n, dans);
    cudaMemcpy(ans, dans, sizeof(char) * prefix[m * n], cudaMemcpyDeviceToHost);
    ans[prefix[m * n]] = '\0';
    printf("answer - %s", ans);
    return 0;
}
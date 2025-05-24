#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define TILE_SIZE 5
#define MASK_RADIUS 2

__constant__ int mask[5];

__global__ void conv1d(int *a, int n, int *ans)
{
    __shared__ int m[TILE_SIZE + (2 * MASK_RADIUS)];
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i < n)
    {
        m[threadIdx.x + MASK_RADIUS] = a[i];
        if (threadIdx.x < MASK_RADIUS)
        {
            if (i - MASK_RADIUS < 0)
            {
                m[threadIdx.x] = 0;
            }
            else
            {
                m[threadIdx.x] = a[i - threadIdx.x];
            }
        }
        if (threadIdx.x + (2 * MASK_RADIUS) >= TILE_SIZE)
        {
            if (i + MASK_RADIUS < n)
            {
                m[threadIdx.x + (2 * MASK_RADIUS)] = a[i + threadIdx.x];
            }
            else
            {
                m[threadIdx.x + (2 * MASK_RADIUS)] = 0;
            }
        }
        __syncthreads();
        int val = 0;
        for (int j = -MASK_RADIUS; j < MASK_RADIUS + 1; ++j)
        {
            val += m[threadIdx.x + MASK_RADIUS + j] * mask[MASK_RADIUS + j];
        }
        ans[i] = val;
        __syncthreads();
    }
    return;
}
int main()
{
    int *a, *ans, n, *da, *dans, *mmask;
    printf("enter array size\n");
    scanf("%d", &n);
    a = (int *)malloc(sizeof(int) * n);
    ans = (int *)malloc(sizeof(int) * n);
    mmask = (int *)malloc(sizeof(int) * 5);
    printf("enter array\n");
    for (int i = 0; i < n; ++i)
    {
        scanf("%d", &a[i]);
    }
    printf("enter mask\n");
    for (int i = 0; i < 5; ++i)
    {
        scanf("%d", &mmask[i]);
    }
    cudaMemcpyToSymbol(mask, mmask, sizeof(int) * 5);
    cudaMalloc((void **)&da, sizeof(int) * n);
    cudaMalloc((void **)&dans, sizeof(int) * n);
    cudaMemcpy(da, a, sizeof(int) * n, cudaMemcpyHostToDevice);
    conv1d<<<1, n>>>(da, n, dans);
    cudaMemcpy(ans, dans, sizeof(int) * n, cudaMemcpyDeviceToHost);
    printf("answer\n");
    for (int i = 0; i < n; ++i)
    {
        printf("%d", ans[i]);
    }
    return 0;
}
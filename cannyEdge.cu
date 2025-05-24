#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>

#define BLOCK_SIZE 16

__global__ void gaussianBlurKernel(unsigned char *input, unsigned char *output, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    int idx = y * width + x;

    if (x > 0 && x < width - 1 && y > 0 && y < height - 1) {
        float kernel[3][3] = {{1, 2, 1}, {2, 4, 2}, {1, 2, 1}};
        float sum = 0;
        float normalization = 16.0;
        float blurred_pixel = 0.0;

        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
                blurred_pixel += input[(y + i) * width + (x + j)] * kernel[i + 1][j + 1];
                sum += kernel[i + 1][j + 1];
            }
        }

        output[idx] = (unsigned char)(blurred_pixel / normalization);
    }
}

__global__ void sobelFilterKernel(unsigned char *input, float *gradient, float *direction, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x > 0 && x < width - 1 && y > 0 && y < height - 1) {
        float Gx = 0, Gy = 0;
        int idx = y * width + x;
        
        int sobelX[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
        int sobelY[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
        
        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
                int pixel = input[(y + i) * width + (x + j)];
                Gx += pixel * sobelX[i + 1][j + 1];
                Gy += pixel * sobelY[i + 1][j + 1];
            }
        }
        
        gradient[idx] = sqrtf(Gx * Gx + Gy * Gy);
        direction[idx] = atan2f(Gy, Gx);
    }
}

__global__ void nonMaxSuppressionKernel(float *gradient, float *direction, unsigned char *output, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    int idx = y * width + x;

    if (x > 0 && x < width - 1 && y > 0 && y < height - 1) {
        float angle = direction[idx] * 180.0 / M_PI;
        angle = fmodf(angle + 180.0, 180.0);
        float grad = gradient[idx];

        int neighbor1, neighbor2;
        if ((angle >= 0 && angle < 22.5) || (angle >= 157.5 && angle < 180)) {
            neighbor1 = y * width + (x - 1);
            neighbor2 = y * width + (x + 1);
        } else if (angle >= 22.5 && angle < 67.5) {
            neighbor1 = (y - 1) * width + (x + 1);
            neighbor2 = (y + 1) * width + (x - 1);
        } else if (angle >= 67.5 && angle < 112.5) {
            neighbor1 = (y - 1) * width + x;
            neighbor2 = (y + 1) * width + x;
        } else {
            neighbor1 = (y - 1) * width + (x - 1);
            neighbor2 = (y + 1) * width + (x + 1);
        }

        if (grad >= gradient[neighbor1] && grad >= gradient[neighbor2]) {
            output[idx] = (unsigned char)grad;
        } else {
            output[idx] = 0;
        }
    }
}

__global__ void hysteresisKernel(unsigned char *input, unsigned char *output, int width, int height, int lowThreshold, int highThreshold) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    int idx = y * width + x;

    if (x > 0 && x < width - 1 && y > 0 && y < height - 1) {
        if (input[idx] >= highThreshold) {
            output[idx] = 255;
        } else if (input[idx] >= lowThreshold) {
            output[idx] = 128;
        } else {
            output[idx] = 0;
        }
    }
}

void cannyEdgeDetection(unsigned char *d_input, unsigned char *d_output, int width, int height) {
    unsigned char *d_blurred;
    float *d_gradient, *d_direction;
    cudaMalloc(&d_blurred, width * height * sizeof(unsigned char));
    cudaMalloc(&d_gradient, width * height * sizeof(float));
    cudaMalloc(&d_direction, width * height * sizeof(float));
    
    dim3 blockSize(BLOCK_SIZE, BLOCK_SIZE);
    dim3 gridSize((width + BLOCK_SIZE - 1) / BLOCK_SIZE, (height + BLOCK_SIZE - 1) / BLOCK_SIZE);
    
    gaussianBlurKernel<<<gridSize, blockSize>>>(d_input, d_blurred, width, height);
    sobelFilterKernel<<<gridSize, blockSize>>>(d_blurred, d_gradient, d_direction, width, height);
    nonMaxSuppressionKernel<<<gridSize, blockSize>>>(d_gradient, d_direction, d_output, width, height);
    hysteresisKernel<<<gridSize, blockSize>>>(d_output, d_output, width, height, 50, 150);
    
    cudaFree(d_blurred);
    cudaFree(d_gradient);
    cudaFree(d_direction);
}

int main() {
   // Load image using OpenCV
   Mat image = imread("input.jpg", IMREAD_GRAYSCALE);
   if (image.empty()) {
       printf("Error: Could not open image!\n");
       return -1;
   }
   int width = image.cols;
   int height = image.rows;
   
   // Allocate memory
   unsigned char *d_input, *d_output;
   cudaMalloc(&d_input, width * height * sizeof(unsigned char));
   cudaMalloc(&d_output, width * height * sizeof(unsigned char));
   
   // Copy data to GPU
   cudaMemcpy(d_input, image.data, width * height * sizeof(unsigned char), cudaMemcpyHostToDevice);
   
   // Perform Canny edge detection
   cannyEdgeDetection(d_input, d_output, width, height);
   
   // Copy result back to CPU
   Mat outputImage(height, width, CV_8UC1);
   cudaMemcpy(outputImage.data, d_output, width * height * sizeof(unsigned char), cudaMemcpyDeviceToHost);
   
   // Save the result
   imwrite("output.jpg", outputImage);
   
   // Cleanup
   cudaFree(d_input);
   cudaFree(d_output);
   
   return 0;
}

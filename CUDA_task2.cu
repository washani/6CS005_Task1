// Name: H.G. Manesha Washani
// Student Id: 1432289

#include <stdio.h>
#include <stdlib.h>

#define N 4

/* The _global_ indicates a function that runs on the device and it called for host code. A kernel to add two integers */
 
__global__ void Matrix(int A[][N], int B[][N], int C[][N]){
           int g = threadIdx.x;
           int h = threadIdx.y;

           C[g][h] = A[g][h] + B[g][h];
}


int main(){

  int A[N][N] =
    {
      {1, 5, 6, 7},
      {4, 4, 8, 0},
      {2, 3, 4, 5},
      {2, 3, 4, 5}
   };

  int B[N][N] = 
    {
      {1, 5, 6, 7},
      {4, 4, 8, 0},
      {2, 3, 4, 5},
      {2, 3, 4, 5}
   };

  int C[N][N] = 
     {
      {0, 0, 0, 0},
      {0, 0, 0, 0},
      {0, 0, 0, 0},
      {0, 0, 0, 0}
   };

  
  int (*d_A)[N], (*d_B)[N], (*d_C)[N];

  /* device copies of A, B, C and Allocate space for device copies of A, B, C */
  
  cudaMalloc((void**)&d_A, (N*N)*sizeof(int));
  cudaMalloc((void**)&d_B, (N*N)*sizeof(int));
  cudaMalloc((void**)&d_C, (N*N)*sizeof(int));
  
 // copy input to device

  cudaMemcpy(d_A, A, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, B, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_C, C, (N*N)*sizeof(int), cudaMemcpyHostToDevice);

  // Launch add() kernel on GPU
  int numBlocks = 1;
  dim3 threadsPerBlock(N,N);
  Matrix<<<numBlocks,threadsPerBlock>>>(d_A,d_B,d_C);

  // Copy result back to the host
  cudaMemcpy(C, d_C, (N*N)*sizeof(int), cudaMemcpyDeviceToHost);

  int g, h; printf("C = \n");
    for(g=0;g<N;g++){
        for(h=0;h<N;h++){
            printf("%d ", C[g][h]);
        }
        printf("\n");
    }

// This is cleanup 
  cudaFree(d_A); 
  cudaFree(d_B); 
  cudaFree(d_C);

  printf("\n");

  return 0;
}


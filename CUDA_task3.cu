// Name: H.G. Manesha Washani
// Student Id: 1432289

#include <stdio.h>
#include <stdlib.h>

#define N 6

/* The _global_ indicates a function that runs on the device and it called for host code. A kernel to add two integers */

__global__ void MatAdd(int A[][N], int B[][N], int C[][N]){
           int g = threadIdx.x;
           int h = threadIdx.y;

           C[g][h] = A[g][h] + B[g][h];
}

/* My code i used variable is int g and int h, because of that reason i changed given code variables */


void randmatfunc(int newmat[N][N]){
  int g, h, k; 
    for(g=0;g<N;g++){
        for(h=0;h<N;h++){
          k = rand() % 100 + 1;;
            printf("%d ", k);
            newmat[g][h] =k;
        }
        printf("\n");
       
    } 
  printf("\n-----------------------------------\n"); 
}

int main(){

int A[N][N];  
randmatfunc(A);
  
int B[N][N];  
randmatfunc(B);  



  int C[N][N];

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
  MatAdd<<<numBlocks,threadsPerBlock>>>(d_A,d_B,d_C);

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


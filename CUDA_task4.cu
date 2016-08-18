// Name: H.G. Manesha Washani
// Student Id: 1432289

#include <stdio.h>
#include <stdlib.h>

#define N 20

__global__ void MatAdd(int A[][N], int B[][N], int C[][N]){
           int g = blockIdx.x;
           int h = blockIdx.y;

           C[g][h] = A[g][h] + B[g][h];
}

//int** randmatfunc();


void randmatfunc(int newmat[N][N]){
  int i, j, k; 
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
          k = rand() % 100 + 1;;
            printf("%d ", k);
            newmat[i][j] =k;
        }
        printf("\n");
       
    } 
  printf("\n--------------------------------------\n"); 
}

int main(){

int A[N][N];  
randmatfunc(A);
  
int B[N][N];  
randmatfunc(B);  



  int C[N][N];

  int (*d_A)[N], (*d_B)[N], (*d_C)[N];

  cudaMalloc((void**)&d_A, (N*N)*sizeof(int));
  cudaMalloc((void**)&d_B, (N*N)*sizeof(int));
  cudaMalloc((void**)&d_C, (N*N)*sizeof(int));

  cudaMemcpy(d_A, A, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, B, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_C, C, (N*N)*sizeof(int), cudaMemcpyHostToDevice);

  int numThreads = 1;
  dim3 numBlocks(N,N);
  MatAdd<<<numBlocks,numThreads>>>(d_A,d_B,d_C);

  cudaMemcpy(C, d_C, (N*N)*sizeof(int), cudaMemcpyDeviceToHost);

  int g, h; printf("C = \n");
    for(g=0;g<N;g++){
        for(h=0;h<N;h++){
            printf("%d ", C[g][h]);
        }
        printf("\n");
    }

  cudaFree(d_A); 
  cudaFree(d_B); 
  cudaFree(d_C);

  printf("\n");

  return 0;
}

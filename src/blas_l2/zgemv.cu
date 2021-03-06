/**
 * @copyright (c) 2012- King Abdullah University of Science and
 *                      Technology (KAUST). All rights reserved.
 **/


/**
 * @file src/blas_l2/zgemv.cu

 * KBLAS is a high performance CUDA library for subset of BLAS
 *    and LAPACK routines optimized for NVIDIA GPUs.
 * KBLAS is provided by KAUST.
 *
 * @version 2.0.0
 * @author Ahmad Abdelfattah
 * @date 2017-11-13
 **/

#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime_api.h>
#include <cublas.h>
#include "gemv_core.cuh"

#if(SM >= 30)

#define zgemvn_bs		(16)
#define zgemvn_ty		(8)
// TODO:check errors generated with cuda-memcheck if the value is not (1)
//		The if statement inside the for loop for the special case generates some
//		memory access violations with the z-precision only
#define zgemvn_by		(2)

#define zgemvt_bs		(32)
#define zgemvt_ty		(8)
#define zgemvt_by		(2)

#else

#define zgemvn_bs		(32)
#define zgemvn_ty		(8)
#define zgemvn_by		(2)

#define zgemvt_bs		(32)
#define zgemvt_ty		(8)
#define zgemvt_by		(2)

#endif

extern "C"
int kblas_zscal_async(int n, cuDoubleComplex alpha, cuDoubleComplex *x, int incx, cudaStream_t stream);

int kblas_zgemv_driver( char trans, int rows, int cols,
						cuDoubleComplex alpha, cuDoubleComplex *dA, int lda,
				 		cuDoubleComplex *dX, int incx,
				 		cuDoubleComplex  beta, cuDoubleComplex *dY, int incy,
				 		cudaStream_t stream)
{
	if(trans == 'n' || trans == 'N')
	{
		// scaling with beta
		kblas_zscal_async(rows, beta, dY, incy, stream);

		int mod_r = rows % zgemvn_bs;
		int mod_c = cols % zgemvn_bs;

		if(mod_r == 0)
		{
			if(mod_c == 0)
			{
				// special case
				int blocks = rows/zgemvn_bs;
				const int thread_x = zgemvn_bs;
				const int thread_y = zgemvn_ty;
				dim3 dimBlock(thread_x, thread_y);
				dim3 dimGrid(blocks, zgemvn_by);
				const int elements_per_thread = thread_x/(2*thread_y);
				gemvn_special<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy);
			}
			else
			{
				// generic case for columns only
				int blocks = rows/zgemvn_bs;
				blocks += 1;	// dummy thread block
				const int thread_x = zgemvn_bs;
				const int thread_y = zgemvn_ty;
				dim3 dimBlock(thread_x, thread_y);
				dim3 dimGrid(blocks, zgemvn_by);
				const int elements_per_thread = thread_x/(2*thread_y);
				const int irregular_cols = mod_c % elements_per_thread;
				switch(irregular_cols)
				{
					/**
					 * The kernel for irregular dimensions has an extra template parameter.
				 	 * This parameter must be among the values listed in the switch-case statement below.
				 	 * The possible values are in the range 0 - (elements_per_thread-1)
				 	 * Make sure these values are updated whenever you change the configuration parameters.
					**/
					case  0: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  0><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  1: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  1><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  2: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  2><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  3: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  3><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  4: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  4><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  5: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  5><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  6: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  6><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  7: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  7><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  8: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  8><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					default: printf("ZGEMV-N error: improper template parameter. Please read the inline documentation for this function. \n"); return -1;

				}
			}
		}
		else	// mod_r != 0
		{
			if(mod_c == 0)
			{
				// generic case for columns only
				int blocks = (rows/zgemvn_bs) + (mod_r != 0);
				const int thread_x = zgemvn_bs;
				const int thread_y = zgemvn_ty;
				dim3 dimBlock(thread_x, thread_y);
				dim3 dimGrid(blocks, zgemvn_by);
				const int elements_per_thread = thread_x/(2*thread_y);
				gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread, 0><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c);
			}
			else
			{
				// generic case for rows and cols
				int blocks = (rows/zgemvn_bs) + (mod_r != 0);
				const int thread_x = zgemvn_bs;
				const int thread_y = zgemvn_ty;
				dim3 dimBlock(thread_x, thread_y);
				dim3 dimGrid(blocks, zgemvn_by);
				const int elements_per_thread = thread_x/(2*thread_y);
				const int irregular_cols = mod_c % elements_per_thread;
				switch(irregular_cols)
				{
					/**
					 * The kernel for irregular dimensions has an extra template parameter.
				 	 * This parameter must be among the values listed in the switch-case statement below.
				 	 * The possible values are in the range 0 - (elements_per_thread-1)
				 	 * Make sure these values are updated whenever you change the configuration parameters.
					**/
					case  0: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  0><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  1: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  1><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  2: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  2><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  3: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  3><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  4: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  4><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  5: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  5><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  6: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  6><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  7: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  7><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					case  8: gemvn_generic<cuDoubleComplex, zgemvn_bs, zgemvn_bs, zgemvn_ty, elements_per_thread,  8><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c); break;
					default: printf("ZGEMV-N error: improper template parameter. Please read the inline documentation for this function. \n"); return -1;

				}
			}
		}
	}	// end of non-transpose case
	else if (trans == 't' || trans == 'T' || trans == 'c' || trans == 'C')
	{
		int conj;
		if(trans == 'c' || trans == 'C') conj = 1;
		else conj = 0;
		// scaling with beta
		kblas_zscal_async(cols, beta, dY, incy, stream);

		int mod_r = rows % zgemvt_bs;
		int mod_c = cols % zgemvt_bs;

		if(mod_c == 0)
		{
			if(mod_r == 0)
			{
				// special case
				int blocks = cols/zgemvt_bs;
				const int thread_x = zgemvt_bs;
				const int thread_y = zgemvt_ty;
				const int elements_per_thread = thread_x/(2*thread_y);
				dim3 dimBlock(thread_x, thread_y);
				dim3 dimGrid(blocks, zgemvt_by);
				gemvt_special<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, conj);
			}
			else
			{
				// mod_r != 0
				int blocks = cols/zgemvt_bs;
				blocks += 1;	// dummy thread block
				const int thread_x = zgemvt_bs;
				const int thread_y = zgemvt_ty;
				const int elements_per_thread = thread_x/(2*thread_y);
				dim3 dimBlock(thread_x, thread_y);
				dim3 dimGrid(blocks, zgemvt_by);
				gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread, 0><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj);
			}
		}
		else	// mod_c != 0
		{
			int blocks = cols/zgemvt_bs + (mod_c != 0);
			const int thread_x = zgemvt_bs;
			const int thread_y = zgemvt_ty;
			const int elements_per_thread = thread_x/(2*thread_y);
			const int irregular_cols = mod_c % elements_per_thread;
			dim3 dimBlock(thread_x, thread_y);
			dim3 dimGrid(blocks, zgemvt_by);

			switch(irregular_cols)
			{
				/**
				  * The kernel for irregular dimensions has an extra template parameter.
				  * This parameter must be among the values listed in the switch-case statement below.
				  * The possible values are in the range 0 - (elements_per_thread-1)
				  * Make sure these values are updated whenever you change the configuration parameters.
				**/
				case  0: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  0><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				case  1: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  1><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				case  2: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  2><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				case  3: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  3><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				case  4: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  4><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				case  5: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  5><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				case  6: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  6><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				case  7: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  7><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				case  8: gemvt_generic<cuDoubleComplex, zgemvt_bs, thread_x, thread_y, elements_per_thread,  8><<<dimGrid, dimBlock, 0, stream>>>(rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, mod_r, mod_c, conj); break;
				default: printf("ZGEMV-T error: improper template parameter. Please read the inline documentation for this function. \n"); return -1;
			}
		}
	}
	else
	{
		printf("ZGEMV error: Unrecognized transpose mode %c \n", trans);
		return -1;
	}

	return 0;
}


extern "C"
int kblas_zgemv( char trans, int rows, int cols,
				 cuDoubleComplex alpha, cuDoubleComplex *dA, int lda,
				 cuDoubleComplex *dX, int incx,
				 cuDoubleComplex  beta, cuDoubleComplex *dY, int incy)
{
	return kblas_zgemv_driver( trans, rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, 0);
}

extern "C"
int kblas_zgemv_async( char trans, int rows, int cols,
						cuDoubleComplex alpha, cuDoubleComplex *dA, int lda,
				 		cuDoubleComplex *dX, int incx,
				 		cuDoubleComplex  beta, cuDoubleComplex *dY, int incy,
				 		cudaStream_t stream)
{
	return kblas_zgemv_driver( trans, rows, cols, alpha, dA, lda, dX, incx, beta, dY, incy, stream);
}

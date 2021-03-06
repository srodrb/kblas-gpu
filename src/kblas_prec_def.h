/**
 * @copyright (c) 2012- King Abdullah University of Science and
 *                      Technology (KAUST). All rights reserved.
 **/


/**
 * @file src/kblas_prec_def.h

 * KBLAS is a high performance CUDA library for subset of BLAS
 *    and LAPACK routines optimized for NVIDIA GPUs.
 * KBLAS is provided by KAUST.
 *
 * @version 2.0.0
 * @author Ali Charara
 * @date 2017-11-13
 **/

#ifndef __KBLAS_PREC_DEF__
#define __KBLAS_PREC_DEF__

#if defined   PREC_s
  #define TYPE float

  #define kblasXgemm_batch kblasSgemm_batch
  #define kblasXgemm_batch_strided kblasSgemm_batch_strided
  // #define Xgemm_batch_strided_wsquery sgemm_batch_strided_wsquery

  #define kblasXsyrk_batch_wsquery kblasSsyrk_batch_wsquery
  #define kblasXsyrk_batch kblasSsyrk_batch
  #define kblasXsyrk_batch_strided_wsquery kblasSsyrk_batch_strided_wsquery
  #define kblasXsyrk_batch_strided kblasSsyrk_batch_strided

  #define kblasXtrsm_batch kblasStrsm_batch
  #define kblasXtrsm_batch_strided kblasStrsm_batch_strided

  #define kblasXtrmm_batch kblasStrmm_batch
  #define kblasXtrmm_batch_strided kblasStrmm_batch_strided

  #define kblasXpotrf_batch kblasSpotrf_batch
  #define kblasXpotrf_batch_strided kblasSpotrf_batch_strided

  #define kblasXlauum_batch kblasSlauum_batch
  #define kblasXlauum_batch_strided kblasSlauum_batch_strided

  #define kblasXtrtri_batch kblasStrtri_batch
  #define kblasXtrtri_batch_strided kblasStrtri_batch_strided

  #define kblasXpotrs_batch kblasSpotrs_batch
  #define kblasXpotrs_batch_strided kblasSpotrs_batch_strided

  #define kblasXpotri_batch kblasSpotri_batch
  #define kblasXpotri_batch_strided kblasSpotri_batch_strided

  #define kblasXpoti_batch kblasSpoti_batch
  #define kblasXpoti_batch_strided kblasSpoti_batch_strided

  #define kblasXposv_batch kblasSposv_batch
  #define kblasXposv_batch_strided kblasSposv_batch_strided

  #define cublasXgemm cublasSgemm
  #define cublasXgemmBatched cublasSgemmBatched
  #define cublasXgemmStridedBatched cublasSgemmStridedBatched
  #define magmablas_Xgemm_batched magmablas_sgemm_batched

#elif defined PREC_d
  #define TYPE double

  #define kblasXgemm_batch kblasDgemm_batch
  #define kblasXgemm_batch_strided kblasDgemm_batch_strided
  // #define Xgemm_batch_strided_wsquery dgemm_batch_strided_wsquery

  #define kblasXsyrk_batch_wsquery kblasDsyrk_batch_wsquery
  #define kblasXsyrk_batch kblasDsyrk_batch
  #define kblasXsyrk_batch_strided_wsquery kblasDsyrk_batch_strided_wsquery
  #define kblasXsyrk_batch_strided kblasDsyrk_batch_strided

  #define kblasXtrsm_batch kblasDtrsm_batch
  #define kblasXtrsm_batch_strided kblasDtrsm_batch_strided

  #define kblasXtrmm_batch kblasDtrmm_batch
  #define kblasXtrmm_batch_strided kblasDtrmm_batch_strided

  #define kblasXpotrf_batch kblasDpotrf_batch
  #define kblasXpotrf_batch_strided kblasDpotrf_batch_strided

  #define kblasXlauum_batch kblasDlauum_batch
  #define kblasXlauum_batch_strided kblasDlauum_batch_strided

  #define kblasXtrtri_batch kblasDtrtri_batch
  #define kblasXtrtri_batch_strided kblasDtrtri_batch_strided

  #define kblasXpotrs_batch kblasDpotrs_batch
  #define kblasXpotrs_batch_strided kblasDpotrs_batch_strided

  #define kblasXpotri_batch kblasDpotri_batch
  #define kblasXpotri_batch_strided kblasDpotri_batch_strided

  #define kblasXpoti_batch kblasDpoti_batch
  #define kblasXpoti_batch_strided kblasDpoti_batch_strided

  #define kblasXposv_batch kblasDposv_batch
  #define kblasXposv_batch_strided kblasDposv_batch_strided

  #define cublasXgemm cublasDgemm
  #define cublasXgemmBatched cublasDgemmBatched
  #define cublasXgemmStridedBatched cublasDgemmStridedBatched
  #define magmablas_Xgemm_batched magmablas_dgemm_batched

#elif defined PREC_c
  #define TYPE cuComplex

  #define kblasXgemm_batch kblasCgemm_batch
  #define kblasXgemm_batch_strided kblasCgemm_batch_strided
  // #define Xgemm_batch_strided_wsquery cgemm_batch_strided_wsquery

  #define kblasXsyrk_batch_wsquery kblasCsyrk_batch_wsquery
  #define kblasXsyrk_batch kblasCsyrk_batch
  #define kblasXsyrk_batch_strided_wsquery kblasCsyrk_batch_strided_wsquery
  #define kblasXsyrk_batch_strided kblasCsyrk_batch_strided

  #define kblasXtrsm_batch kblasCtrsm_batch
  #define kblasXtrsm_batch_strided kblasCtrsm_batch_strided

  #define kblasXtrmm_batch kblasCtrmm_batch
  #define kblasXtrmm_batch_strided kblasCtrmm_batch_strided

  #define kblasXpotrf_batch kblasCpotrf_batch
  #define kblasXpotrf_batch_strided kblasCpotrf_batch_strided

  #define kblasXlauum_batch kblasClauum_batch
  #define kblasXlauum_batch_strided kblasClauum_batch_strided

  #define kblasXtrtri_batch kblasCtrtri_batch
  #define kblasXtrtri_batch_strided kblasCtrtri_batch_strided

  #define kblasXpotrs_batch kblasCpotrs_batch
  #define kblasXpotrs_batch_strided kblasCpotrs_batch_strided

  #define kblasXpotri_batch kblasCpotri_batch
  #define kblasXpotri_batch_strided kblasCpotri_batch_strided

  #define kblasXpoti_batch kblasCpoti_batch
  #define kblasXpoti_batch_strided kblasCpoti_batch_strided

  #define kblasXposv_batch kblasCposv_batch
  #define kblasXposv_batch_strided kblasCposv_batch_strided

  #define cublasXgemm cublasCgemm
  #define cublasXgemmBatched cublasCgemmBatched
  #define cublasXgemmStridedBatched cublasCgemmStridedBatched
  #define magmablas_Xgemm_batched magmablas_cgemm_batched

#elif defined PREC_z
  #define TYPE cuDoubleComplex

  #define kblasXgemm_batch kblasZgemm_batch
  #define kblasXgemm_batch_strided kblasZgemm_batch_strided
  // #define Xgemm_batch_strided_wsquery zgemm_batch_strided_wsquery

  #define kblasXsyrk_batch_wsquery kblasZsyrk_batch_wsquery
  #define kblasXsyrk_batch kblasZsyrk_batch
  #define kblasXsyrk_batch_strided_wsquery kblasZsyrk_batch_strided_wsquery
  #define kblasXsyrk_batch_strided kblasZsyrk_batch_strided

  #define kblasXtrsm_batch kblasZtrsm_batch
  #define kblasXtrsm_batch_strided kblasZtrsm_batch_strided

  #define kblasXtrmm_batch kblasZtrmm_batch
  #define kblasXtrmm_batch_strided kblasZtrmm_batch_strided

  #define kblasXpotrf_batch kblasZpotrf_batch
  #define kblasXpotrf_batch_strided kblasZpotrf_batch_strided

  #define kblasXlauum_batch kblasZlauum_batch
  #define kblasXlauum_batch_strided kblasZlauum_batch_strided

  #define kblasXtrtri_batch kblasZtrtri_batch
  #define kblasXtrtri_batch_strided kblasZtrtri_batch_strided

  #define kblasXpotrs_batch kblasZpotrs_batch
  #define kblasXpotrs_batch_strided kblasZpotrs_batch_strided

  #define kblasXpotri_batch kblasZpotri_batch
  #define kblasXpotri_batch_strided kblasZpotri_batch_strided

  #define kblasXpoti_batch kblasZpoti_batch
  #define kblasXpoti_batch_strided kblasZpoti_batch_strided

  #define kblasXposv_batch kblasZposv_batch
  #define kblasXposv_batch_strided kblasZposv_batch_strided

  #define cublasXgemm cublasZgemm
  #define cublasXgemmBatched cublasZgemmBatched
  #define cublasXgemmStridedBatched cublasZgemmStridedBatched
  #define magmablas_Xgemm_batched magmablas_zgemm_batched

#else
  #error "No precesion defined"
#endif

#endif //__KBLAS_PREC_DEF__

; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX

; PR21507 - https://llvm.org/bugs/show_bug.cgi?id=21507
; Each function should be a single math op; no extra moves.


define <4 x float> @recip(<4 x float> %x) {
; SSE-LABEL: recip:
; SSE:       # %bb.0:
; SSE-NEXT:    rcpss %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: recip:
; AVX:       # %bb.0:
; AVX-NEXT:    vrcpss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %y = tail call <4 x float> @llvm.x86.sse.rcp.ss(<4 x float> %x)
  %shuf = shufflevector <4 x float> %y, <4 x float> %x, <4 x i32> <i32 0, i32 5, i32 6, i32 7>
  ret <4 x float> %shuf
}

define <4 x float> @recip_square_root(<4 x float> %x) {
; SSE-LABEL: recip_square_root:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: recip_square_root:
; AVX:       # %bb.0:
; AVX-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %y = tail call <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float> %x)
  %shuf = shufflevector <4 x float> %y, <4 x float> %x, <4 x i32> <i32 0, i32 5, i32 6, i32 7>
  ret <4 x float> %shuf
}

define <4 x float> @square_root(<4 x float> %x) {
; SSE-LABEL: square_root:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtss %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: square_root:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %y = tail call <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float> %x)
  %shuf = shufflevector <4 x float> %y, <4 x float> %x, <4 x i32> <i32 0, i32 5, i32 6, i32 7>
  ret <4 x float> %shuf
}

define <2 x double> @square_root_double(<2 x double> %x) {
; SSE-LABEL: square_root_double:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: square_root_double:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %y = tail call <2 x double> @llvm.x86.sse2.sqrt.sd(<2 x double> %x)
  %shuf = shufflevector <2 x double> %y, <2 x double> %x, <2 x i32> <i32 0, i32 3>
  ret <2 x double> %shuf
}

declare <4 x float> @llvm.x86.sse.rcp.ss(<4 x float>)
declare <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float>)
declare <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float>)
declare <2 x double> @llvm.x86.sse2.sqrt.sd(<2 x double>)


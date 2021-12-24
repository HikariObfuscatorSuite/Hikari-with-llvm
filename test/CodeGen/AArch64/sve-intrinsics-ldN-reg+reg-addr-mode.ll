; RUN: llc -mtriple=aarch64--linux-gnu -mattr=sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

; ld2b
define <vscale x 32 x i8> @ld2.nxv32i8(<vscale x 16 x i1> %Pg, i8 *%addr, i64 %a) {
; CHECK-LABEL: ld2.nxv32i8:
; CHECK: ld2b { z0.b, z1.b }, p0/z, [x0, x1]
; CHECK-NEXT: ret
%addr2 = getelementptr i8, i8 *  %addr, i64 %a
%res = call <vscale x 32 x i8> @llvm.aarch64.sve.ld2.nxv32i8.nxv16i1.p0i8(<vscale x 16 x i1> %Pg, i8 *%addr2)
ret <vscale x 32 x i8> %res
}

; ld2h
define <vscale x 16 x i16> @ld2.nxv16i16(<vscale x 8 x i1> %Pg, i16 *%addr, i64 %a) {
; CHECK-LABEL: ld2.nxv16i16:
; CHECK: ld2h { z0.h, z1.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr i16, i16 *  %addr, i64 %a
%res = call <vscale x 16 x i16> @llvm.aarch64.sve.ld2.nxv16i16.nxv8i1.p0i16(<vscale x 8 x i1> %Pg, i16 *%addr2)
ret <vscale x 16 x i16> %res
}

define <vscale x 16 x half> @ld2.nxv16f16(<vscale x 8 x i1> %Pg, half *%addr, i64 %a) {
; CHECK-LABEL: ld2.nxv16f16:
; CHECK: ld2h { z0.h, z1.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr half, half *  %addr, i64 %a
%res = call <vscale x 16 x half> @llvm.aarch64.sve.ld2.nxv16f16.nxv8i1.p0f16(<vscale x 8 x i1> %Pg, half *%addr2)
ret <vscale x 16 x half> %res
}

define <vscale x 16 x bfloat> @ld2.nxv16bf16(<vscale x 8 x i1> %Pg, bfloat *%addr, i64 %a) #0 {
; CHECK-LABEL: ld2.nxv16bf16:
; CHECK: ld2h { z0.h, z1.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr bfloat, bfloat *  %addr, i64 %a
%res = call <vscale x 16 x bfloat> @llvm.aarch64.sve.ld2.nxv16bf16.nxv8i1.p0bf16(<vscale x 8 x i1> %Pg, bfloat *%addr2)
ret <vscale x 16 x bfloat> %res
}

; ld2w
define <vscale x 8 x i32> @ld2.nxv8i32(<vscale x 4 x i1> %Pg, i32 *%addr, i64 %a) {
; CHECK-LABEL: ld2.nxv8i32:
; CHECK: ld2w { z0.s, z1.s }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT: ret
%addr2 = getelementptr i32, i32 *  %addr, i64 %a
%res = call <vscale x 8 x i32> @llvm.aarch64.sve.ld2.nxv8i32.nxv4i1.p0i32(<vscale x 4 x i1> %Pg, i32 *%addr2)
ret <vscale x 8 x i32> %res
}

define <vscale x 8 x float> @ld2.nxv8f32(<vscale x 4 x i1> %Pg, float *%addr, i64 %a) {
; CHECK-LABEL: ld2.nxv8f32:
; CHECK: ld2w { z0.s, z1.s }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT: ret
%addr2 = getelementptr float, float *  %addr, i64 %a
%res = call <vscale x 8 x float> @llvm.aarch64.sve.ld2.nxv8f32.nxv4i1.p0f32(<vscale x 4 x i1> %Pg, float *%addr2)
ret <vscale x 8 x float> %res
}

; ld2d
define <vscale x 4 x i64> @ld2.nxv4i64(<vscale x 2 x i1> %Pg, i64 *%addr, i64 %a) {
; CHECK-LABEL: ld2.nxv4i64:
; CHECK: ld2d { z0.d, z1.d }, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT: ret
%addr2 = getelementptr i64, i64 *  %addr, i64 %a
%res = call <vscale x 4 x i64> @llvm.aarch64.sve.ld2.nxv4i64.nxv2i1.p0i64(<vscale x 2 x i1> %Pg, i64 *%addr2)
ret <vscale x 4 x i64> %res
}

define <vscale x 4 x double> @ld2.nxv4f64(<vscale x 2 x i1> %Pg, double *%addr, i64 %a) {
; CHECK-LABEL: ld2.nxv4f64:
; CHECK: ld2d { z0.d, z1.d }, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT: ret
%addr2 = getelementptr double, double *  %addr, i64 %a
%res = call <vscale x 4 x double> @llvm.aarch64.sve.ld2.nxv4f64.nxv2i1.p0f64(<vscale x 2 x i1> %Pg, double *%addr2)
ret <vscale x 4 x double> %res
}

; ld3b
define <vscale x 48 x i8> @ld3.nxv48i8(<vscale x 16 x i1> %Pg, i8 *%addr, i64 %a) {
; CHECK-LABEL: ld3.nxv48i8:
; CHECK: ld3b { z0.b, z1.b, z2.b }, p0/z, [x0, x1]
; CHECK-NEXT: ret
%addr2 = getelementptr i8, i8 *  %addr, i64 %a
%res = call <vscale x 48 x i8> @llvm.aarch64.sve.ld3.nxv48i8.nxv16i1.p0i8(<vscale x 16 x i1> %Pg, i8 *%addr2)
ret <vscale x 48 x i8> %res
}

; ld3h
define <vscale x 24 x i16> @ld3.nxv24i16(<vscale x 8 x i1> %Pg, i16 *%addr, i64 %a) {
; CHECK-LABEL: ld3.nxv24i16:
; CHECK: ld3h { z0.h, z1.h, z2.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr i16, i16 *  %addr, i64 %a
%res = call <vscale x 24 x i16> @llvm.aarch64.sve.ld3.nxv24i16.nxv8i1.p0i16(<vscale x 8 x i1> %Pg, i16 *%addr2)
ret <vscale x 24 x i16> %res
}

define <vscale x 24 x half> @ld3.nxv24f16(<vscale x 8 x i1> %Pg, half *%addr, i64 %a) {
; CHECK-LABEL: ld3.nxv24f16:
; CHECK: ld3h { z0.h, z1.h, z2.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr half, half *  %addr, i64 %a
%res = call <vscale x 24 x half> @llvm.aarch64.sve.ld3.nxv24f16.nxv8i1.p0f16(<vscale x 8 x i1> %Pg, half *%addr2)
ret <vscale x 24 x half> %res
}

define <vscale x 24 x bfloat> @ld3.nxv24bf16(<vscale x 8 x i1> %Pg, bfloat *%addr, i64 %a) #0 {
; CHECK-LABEL: ld3.nxv24bf16:
; CHECK: ld3h { z0.h, z1.h, z2.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr bfloat, bfloat *  %addr, i64 %a
%res = call <vscale x 24 x bfloat> @llvm.aarch64.sve.ld3.nxv24bf16.nxv8i1.p0bf16(<vscale x 8 x i1> %Pg, bfloat *%addr2)
ret <vscale x 24 x bfloat> %res
}

; ld3w
define <vscale x 12 x i32> @ld3.nxv12i32(<vscale x 4 x i1> %Pg, i32 *%addr, i64 %a) {
; CHECK-LABEL: ld3.nxv12i32:
; CHECK: ld3w { z0.s, z1.s, z2.s }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT: ret
%addr2 = getelementptr i32, i32 *  %addr, i64 %a
%res = call <vscale x 12 x i32> @llvm.aarch64.sve.ld3.nxv12i32.nxv4i1.p0i32(<vscale x 4 x i1> %Pg, i32 *%addr2)
ret <vscale x 12 x i32> %res
}

define <vscale x 12 x float> @ld3.nxv12f32(<vscale x 4 x i1> %Pg, float *%addr, i64 %a) {
; CHECK-LABEL: ld3.nxv12f32:
; CHECK: ld3w { z0.s, z1.s, z2.s }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT: ret
%addr2 = getelementptr float, float *  %addr, i64 %a
%res = call <vscale x 12 x float> @llvm.aarch64.sve.ld3.nxv12f32.nxv4i1.p0f32(<vscale x 4 x i1> %Pg, float *%addr2)
ret <vscale x 12 x float> %res
}

; ld3d
define <vscale x 6 x i64> @ld3.nxv6i64(<vscale x 2 x i1> %Pg, i64 *%addr, i64 %a) {
; CHECK-LABEL: ld3.nxv6i64:
; CHECK: ld3d { z0.d, z1.d, z2.d }, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT: ret
%addr2 = getelementptr i64, i64 *  %addr, i64 %a
%res = call <vscale x 6 x i64> @llvm.aarch64.sve.ld3.nxv6i64.nxv2i1.p0i64(<vscale x 2 x i1> %Pg, i64 *%addr2)
ret <vscale x 6 x i64> %res
}

define <vscale x 6 x double> @ld3.nxv6f64(<vscale x 2 x i1> %Pg, double *%addr, i64 %a) {
; CHECK-LABEL: ld3.nxv6f64:
; CHECK: ld3d { z0.d, z1.d, z2.d }, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT: ret
%addr2 = getelementptr double, double *  %addr, i64 %a
%res = call <vscale x 6 x double> @llvm.aarch64.sve.ld3.nxv6f64.nxv2i1.p0f64(<vscale x 2 x i1> %Pg, double *%addr2)
ret <vscale x 6 x double> %res
}

; ld4b
define <vscale x 64 x i8> @ld4.nxv64i8(<vscale x 16 x i1> %Pg, i8 *%addr, i64 %a) {
; CHECK-LABEL: ld4.nxv64i8:
; CHECK: ld4b { z0.b, z1.b, z2.b, z3.b }, p0/z, [x0, x1]
; CHECK-NEXT: ret
%addr2 = getelementptr i8, i8 *  %addr, i64 %a
%res = call <vscale x 64 x i8> @llvm.aarch64.sve.ld4.nxv64i8.nxv16i1.p0i8(<vscale x 16 x i1> %Pg, i8 *%addr2)
ret <vscale x 64 x i8> %res
}

; ld4h
define <vscale x 32 x i16> @ld4.nxv32i16(<vscale x 8 x i1> %Pg, i16 *%addr, i64 %a) {
; CHECK-LABEL: ld4.nxv32i16:
; CHECK: ld4h { z0.h, z1.h, z2.h, z3.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr i16, i16 *  %addr, i64 %a
%res = call <vscale x 32 x i16> @llvm.aarch64.sve.ld4.nxv32i16.nxv8i1.p0i16(<vscale x 8 x i1> %Pg, i16 *%addr2)
ret <vscale x 32 x i16> %res
}

define <vscale x 32 x half> @ld4.nxv32f16(<vscale x 8 x i1> %Pg, half *%addr, i64 %a) {
; CHECK-LABEL: ld4.nxv32f16:
; CHECK: ld4h { z0.h, z1.h, z2.h, z3.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr half, half *  %addr, i64 %a
%res = call <vscale x 32 x half> @llvm.aarch64.sve.ld4.nxv32f16.nxv8i1.p0f16(<vscale x 8 x i1> %Pg, half *%addr2)
ret <vscale x 32 x half> %res
}

define <vscale x 32 x bfloat> @ld4.nxv32bf16(<vscale x 8 x i1> %Pg, bfloat *%addr, i64 %a) #0 {
; CHECK-LABEL: ld4.nxv32bf16:
; CHECK: ld4h { z0.h, z1.h, z2.h, z3.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT: ret
%addr2 = getelementptr bfloat, bfloat *  %addr, i64 %a
%res = call <vscale x 32 x bfloat> @llvm.aarch64.sve.ld4.nxv32bf16.nxv8i1.p0bf16(<vscale x 8 x i1> %Pg, bfloat *%addr2)
ret <vscale x 32 x bfloat> %res
}

; ld4w
define <vscale x 16 x i32> @ld4.nxv16i32(<vscale x 4 x i1> %Pg, i32 *%addr, i64 %a) {
; CHECK-LABEL: ld4.nxv16i32:
; CHECK: ld4w { z0.s, z1.s, z2.s, z3.s }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT: ret
%addr2 = getelementptr i32, i32 *  %addr, i64 %a
%res = call <vscale x 16 x i32> @llvm.aarch64.sve.ld4.nxv16i32.nxv4i1.p0i32(<vscale x 4 x i1> %Pg, i32 *%addr2)
ret <vscale x 16 x i32> %res
}

define <vscale x 16 x float> @ld4.nxv16f32(<vscale x 4 x i1> %Pg, float *%addr, i64 %a) {
; CHECK-LABEL: ld4.nxv16f32:
; CHECK: ld4w { z0.s, z1.s, z2.s, z3.s }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT: ret
%addr2 = getelementptr float, float *  %addr, i64 %a
%res = call <vscale x 16 x float> @llvm.aarch64.sve.ld4.nxv16f32.nxv4i1.p0f32(<vscale x 4 x i1> %Pg, float *%addr2)
ret <vscale x 16 x float> %res
}

; ld4d
define <vscale x 8 x i64> @ld4.nxv8i64(<vscale x 2 x i1> %Pg, i64 *%addr, i64 %a) {
; CHECK-LABEL: ld4.nxv8i64:
; CHECK: ld4d { z0.d, z1.d, z2.d, z3.d }, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT: ret
%addr2 = getelementptr i64, i64 *  %addr, i64 %a
%res = call <vscale x 8 x i64> @llvm.aarch64.sve.ld4.nxv8i64.nxv2i1.p0i64(<vscale x 2 x i1> %Pg, i64 *%addr2)
ret <vscale x 8 x i64> %res
}

define <vscale x 8 x double> @ld4.nxv8f64(<vscale x 2 x i1> %Pg, double *%addr, i64 %a) {
; CHECK-LABEL: ld4.nxv8f64:
; CHECK: ld4d { z0.d, z1.d, z2.d, z3.d }, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT: ret
%addr2 = getelementptr double, double *  %addr, i64 %a
%res = call <vscale x 8 x double> @llvm.aarch64.sve.ld4.nxv8f64.nxv2i1.p0f64(<vscale x 2 x i1> %Pg, double *%addr2)
ret <vscale x 8 x double> %res
}

declare <vscale x 32 x i8> @llvm.aarch64.sve.ld2.nxv32i8.nxv16i1.p0i8(<vscale x 16 x i1>, i8*)
declare <vscale x 16 x i16> @llvm.aarch64.sve.ld2.nxv16i16.nxv8i1.p0i16(<vscale x 8 x i1>, i16*)
declare <vscale x 8 x i32> @llvm.aarch64.sve.ld2.nxv8i32.nxv4i1.p0i32(<vscale x 4 x i1>, i32*)
declare <vscale x 4 x i64> @llvm.aarch64.sve.ld2.nxv4i64.nxv2i1.p0i64(<vscale x 2 x i1>, i64*)
declare <vscale x 16 x half> @llvm.aarch64.sve.ld2.nxv16f16.nxv8i1.p0f16(<vscale x 8 x i1>, half*)
declare <vscale x 16 x bfloat> @llvm.aarch64.sve.ld2.nxv16bf16.nxv8i1.p0bf16(<vscale x 8 x i1>, bfloat*)
declare <vscale x 8 x float> @llvm.aarch64.sve.ld2.nxv8f32.nxv4i1.p0f32(<vscale x 4 x i1>, float*)
declare <vscale x 4 x double> @llvm.aarch64.sve.ld2.nxv4f64.nxv2i1.p0f64(<vscale x 2 x i1>, double*)

declare <vscale x 48 x i8> @llvm.aarch64.sve.ld3.nxv48i8.nxv16i1.p0i8(<vscale x 16 x i1>, i8*)
declare <vscale x 24 x i16> @llvm.aarch64.sve.ld3.nxv24i16.nxv8i1.p0i16(<vscale x 8 x i1>, i16*)
declare <vscale x 12 x i32> @llvm.aarch64.sve.ld3.nxv12i32.nxv4i1.p0i32(<vscale x 4 x i1>, i32*)
declare <vscale x 6 x i64> @llvm.aarch64.sve.ld3.nxv6i64.nxv2i1.p0i64(<vscale x 2 x i1>, i64*)
declare <vscale x 24 x half> @llvm.aarch64.sve.ld3.nxv24f16.nxv8i1.p0f16(<vscale x 8 x i1>, half*)
declare <vscale x 24 x bfloat> @llvm.aarch64.sve.ld3.nxv24bf16.nxv8i1.p0bf16(<vscale x 8 x i1>, bfloat*)
declare <vscale x 12 x float> @llvm.aarch64.sve.ld3.nxv12f32.nxv4i1.p0f32(<vscale x 4 x i1>, float*)
declare <vscale x 6 x double> @llvm.aarch64.sve.ld3.nxv6f64.nxv2i1.p0f64(<vscale x 2 x i1>, double*)

declare <vscale x 64 x i8> @llvm.aarch64.sve.ld4.nxv64i8.nxv16i1.p0i8(<vscale x 16 x i1>, i8*)
declare <vscale x 32 x i16> @llvm.aarch64.sve.ld4.nxv32i16.nxv8i1.p0i16(<vscale x 8 x i1>, i16*)
declare <vscale x 16 x i32> @llvm.aarch64.sve.ld4.nxv16i32.nxv4i1.p0i32(<vscale x 4 x i1>, i32*)
declare <vscale x 8 x i64> @llvm.aarch64.sve.ld4.nxv8i64.nxv2i1.p0i64(<vscale x 2 x i1>, i64*)
declare <vscale x 32 x half> @llvm.aarch64.sve.ld4.nxv32f16.nxv8i1.p0f16(<vscale x 8 x i1>, half*)
declare <vscale x 32 x bfloat> @llvm.aarch64.sve.ld4.nxv32bf16.nxv8i1.p0bf16(<vscale x 8 x i1>, bfloat*)
declare <vscale x 16 x float> @llvm.aarch64.sve.ld4.nxv16f32.nxv4i1.p0f32(<vscale x 4 x i1>, float*)
declare <vscale x 8 x double> @llvm.aarch64.sve.ld4.nxv8f64.nxv2i1.p0f64(<vscale x 2 x i1>, double*)

; +bf16 is required for the bfloat version.
attributes #0 = { "target-features"="+sve,+bf16" }

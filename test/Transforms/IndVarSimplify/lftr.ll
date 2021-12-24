; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -indvars -dce -S -indvars-predicate-loops=0 | FileCheck %s

; Provide legal integer types.
target datalayout = "n8:16:32:64"

@A = external global i32

;; Convert a pre-increment check on the latch into a post increment check
define i32 @pre_to_post_add() {
; CHECK-LABEL: @pre_to_post_add(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    store i32 [[I]], i32* @A, align 4
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[I_NEXT]], 1001
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    ret i32 1000
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %i.next = add i32 %i, 1
  store i32 %i, i32* @A
  %c = icmp slt i32 %i, 1000
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %i
}

; TODO: we should be able to convert the subtract into a post-decrement check
define i32 @pre_to_post_sub() {
; CHECK-LABEL: @pre_to_post_sub(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 1000, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = sub nsw i32 [[I]], 1
; CHECK-NEXT:    store i32 [[I]], i32* @A, align 4
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[I]], 0
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 1000, %entry ], [ %i.next, %loop ]
  %i.next = sub i32 %i, 1
  store i32 %i, i32* @A
  %c = icmp sgt i32 %i, 0
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %i
}



; LFTR should eliminate the need for the computation of i*i completely.  It
; is only used to compute the exit value.
define i32 @quadratic_slt() {
; CHECK-LABEL: @quadratic_slt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 7, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    store i32 [[I]], i32* @A, align 4
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[I_NEXT]], 33
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    ret i32 32
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 7, %entry ], [ %i.next, %loop ]
  %i.next = add i32 %i, 1
  store i32 %i, i32* @A
  %i2 = mul i32 %i, %i
  %c = icmp slt i32 %i2, 1000
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %i
}


; Same as previous but with sle test
define i32 @quadratic_sle() {
; CHECK-LABEL: @quadratic_sle(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 7, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    store i32 [[I]], i32* @A, align 4
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[I_NEXT]], 33
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    ret i32 32
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 7, %entry ], [ %i.next, %loop ]
  %i.next = add i32 %i, 1
  store i32 %i, i32* @A
  %i2 = mul i32 %i, %i
  %c = icmp sle i32 %i2, 1000
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %i
}

; Same as previous but with ule test
define i32 @quadratic_ule() {
; CHECK-LABEL: @quadratic_ule(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 7, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    store i32 [[I]], i32* @A, align 4
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[I_NEXT]], 33
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    ret i32 32
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 7, %entry ], [ %i.next, %loop ]
  %i.next = add i32 %i, 1
  store i32 %i, i32* @A
  %i2 = mul i32 %i, %i
  %c = icmp ule i32 %i2, 1000
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %i
}

define i32 @quadratic_sgt_loopdec() {
; CHECK-LABEL: @quadratic_sgt_loopdec(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 10, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = call i32 @llvm.loop.decrement.reg.i32(i32 [[I]], i32 1)
; CHECK-NEXT:    store i32 [[I]], i32* @A, align 4
; CHECK-NEXT:    [[I2:%.*]] = mul i32 [[I]], [[I]]
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[I2]], 0
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    ret i32 0
;

entry:
  br label %loop

loop:
  %i = phi i32 [ 10, %entry ], [ %i.next, %loop ]
  %i.next = call i32 @llvm.loop.decrement.reg.i32(i32 %i, i32 1)
  store i32 %i, i32* @A
  %i2 = mul i32 %i, %i
  %c = icmp sgt i32 %i2, 0
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %i
}

@data = common global [240 x i8] zeroinitializer, align 16

define void @test_zext(i8* %a) #0 {
; CHECK-LABEL: @test_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[P_0:%.*]] = phi i8* [ getelementptr inbounds ([240 x i8], [240 x i8]* @data, i64 0, i64 0), [[ENTRY:%.*]] ], [ [[TMP3:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[DOT0:%.*]] = phi i8* [ [[A:%.*]], [[ENTRY]] ], [ [[TMP:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP]] = getelementptr inbounds i8, i8* [[DOT0]], i64 1
; CHECK-NEXT:    [[TMP2:%.*]] = load i8, i8* [[DOT0]], align 1
; CHECK-NEXT:    [[TMP3]] = getelementptr inbounds i8, i8* [[P_0]], i64 1
; CHECK-NEXT:    store i8 [[TMP2]], i8* [[P_0]], align 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i8* [[P_0]], getelementptr inbounds ([240 x i8], [240 x i8]* @data, i64 0, i64 239)
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %i.0 = phi i8 [ 0, %entry ], [ %tmp4, %loop ]
  %p.0 = phi i8* [ getelementptr inbounds ([240 x i8], [240 x i8]* @data, i64 0, i64 0), %entry ], [ %tmp3, %loop ]
  %.0 = phi i8* [ %a, %entry ], [ %tmp, %loop ]
  %tmp = getelementptr inbounds i8, i8* %.0, i64 1
  %tmp2 = load i8, i8* %.0, align 1
  %tmp3 = getelementptr inbounds i8, i8* %p.0, i64 1
  store i8 %tmp2, i8* %p.0, align 1
  %tmp4 = add i8 %i.0, 1
  %tmp5 = icmp ult i8 %tmp4, -16
  br i1 %tmp5, label %loop, label %exit

exit:
  ret void
}

; It is okay to do LFTR on this loop even though the trip count is a
; division because in this case the division can be optimized to a
; shift.
define void @test_udiv_as_shift(i8* %a, i8 %n) nounwind uwtable ssp {
; CHECK-LABEL: @test_udiv_as_shift(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[E:%.*]] = icmp sgt i8 [[N:%.*]], 3
; CHECK-NEXT:    br i1 [[E]], label [[LOOP_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = add i8 [[N]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i8 [[TMP0]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i8 [[TMP1]], 1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I1:%.*]] = phi i8 [ [[I1_INC:%.*]], [[LOOP]] ], [ 0, [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[I1_INC]] = add nuw nsw i8 [[I1]], 1
; CHECK-NEXT:    store volatile i8 0, i8* [[A:%.*]], align 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i8 [[I1_INC]], [[TMP2]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[EXIT_LOOPEXIT:%.*]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %e = icmp sgt i8 %n, 3
  br i1 %e, label %loop, label %exit

loop:
  %i = phi i8 [ 0, %entry ], [ %i.inc, %loop ]
  %i1 = phi i8 [ 0, %entry ], [ %i1.inc, %loop ]
  %i.inc = add nsw i8 %i, 4
  %i1.inc = add i8 %i1, 1
  store volatile i8 0, i8* %a
  %c = icmp slt i8 %i, %n
  br i1 %c, label %loop, label %exit

exit:
  ret void
}

; Don't RAUW the loop's original comparison instruction if it has other uses
; which aren't dominated by the new comparison instruction (which we insert
; at the branch user).
define void @use_before_branch() {
; CHECK-LABEL: @use_before_branch(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOPENTRY_0:%.*]]
; CHECK:       loopentry.0:
; CHECK-NEXT:    [[MB_Y_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[TMP_152:%.*]], [[LOOPENTRY_1:%.*]] ]
; CHECK-NEXT:    [[TMP_14:%.*]] = icmp ule i32 [[MB_Y_0]], 3
; CHECK-NEXT:    br i1 [[TMP_14]], label [[LOOPENTRY_1]], label [[LOOPEXIT_0:%.*]]
; CHECK:       loopentry.1:
; CHECK-NEXT:    [[TMP_152]] = add nuw nsw i32 [[MB_Y_0]], 2
; CHECK-NEXT:    br label [[LOOPENTRY_0]]
; CHECK:       loopexit.0:
; CHECK-NEXT:    unreachable
;
entry:
  br label %loopentry.0

loopentry.0:
  %mb_y.0 = phi i32 [ 0, %entry ], [ %tmp.152, %loopentry.1 ]
  %tmp.14 = icmp sle i32 %mb_y.0, 3
  %tmp.15 = zext i1 %tmp.14 to i32
  br i1 %tmp.14, label %loopentry.1, label %loopexit.0

loopentry.1:
  %tmp.152 = add i32 %mb_y.0, 2
  br label %loopentry.0

loopexit.0:		; preds = %loopentry.0
  unreachable
}

@.str3 = private constant [6 x i8] c"%lld\0A\00", align 1
declare i32 @printf(i8* noalias nocapture, ...) nounwind

; PR13371: indvars pass incorrectly substitutes 'undef' values
;
; LFTR should not user %undef as the loop counter.
define i64 @no_undef_counter() nounwind {
; CHECK-LABEL: @no_undef_counter(
; CHECK-NEXT:  func_start:
; CHECK-NEXT:    br label [[BLOCK9:%.*]]
; CHECK:       block9:
; CHECK-NEXT:    [[UNDEF:%.*]] = phi i64 [ [[NEXT_UNDEF:%.*]], [[BLOCK9]] ], [ undef, [[FUNC_START:%.*]] ]
; CHECK-NEXT:    [[ITER:%.*]] = phi i64 [ [[NEXT_ITER:%.*]], [[BLOCK9]] ], [ 1, [[FUNC_START]] ]
; CHECK-NEXT:    [[NEXT_ITER]] = add nuw nsw i64 [[ITER]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 (i8*, ...) @printf(i8* noalias nocapture getelementptr inbounds ([6 x i8], [6 x i8]* @.str3, i64 0, i64 0), i64 [[NEXT_ITER]], i64 [[UNDEF]])
; CHECK-NEXT:    [[NEXT_UNDEF]] = add nsw i64 [[UNDEF]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[NEXT_ITER]], 100
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[BLOCK9]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 0
;
func_start:
  br label %block9
block9:                                           ; preds = %block9,%func_start
  %undef = phi i64 [ %next_undef, %block9 ], [ undef, %func_start ]
  %iter = phi i64 [ %next_iter, %block9 ], [ 1, %func_start ]
  %next_iter = add nsw i64 %iter, 1
  %0 = tail call i32 (i8*, ...) @printf(i8* noalias nocapture getelementptr inbounds ([6 x i8], [6 x i8]* @.str3, i64 0, i64 0), i64 %next_iter, i64 %undef)
  %next_undef = add nsw i64 %undef, 1
  %_tmp_3 = icmp slt i64 %next_iter, 100
  br i1 %_tmp_3, label %block9, label %exit
exit:                                             ; preds = %block9
  ret i64 0
}

define void @extend_const() #0 {
; CHECK-LABEL: @extend_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i32 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @bar(i32 [[INDVARS_IV]]) [[ATTR2:#.*]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i32 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[INDVARS_IV_NEXT]], 512
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.01 = phi i16 [ 0, %entry ], [ %inc, %for.body ]
  %conv2 = sext i16 %i.01 to i32
  call void @bar(i32 %conv2) #1
  %inc = add i16 %i.01, 1
  %cmp = icmp slt i16 %inc, 512
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}

; Check that post-incrementing the backedge taken count does not overflow.
define i32 @extend_const_postinc() #0 {
; CHECK-LABEL: @extend_const_postinc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[DO_BODY:%.*]]
; CHECK:       do.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i32 [ [[INDVARS_IV_NEXT:%.*]], [[DO_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @bar(i32 [[INDVARS_IV]]) [[ATTR2]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[INDVARS_IV]], 255
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i32 [[INDVARS_IV]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[DO_END:%.*]], label [[DO_BODY]]
; CHECK:       do.end:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %do.body

do.body:                                          ; preds = %do.body, %entry
  %first.0 = phi i8 [ 0, %entry ], [ %inc, %do.body ]
  %conv = zext i8 %first.0 to i32
  call void  @bar(i32 %conv) #1
  %inc = add i8 %first.0, 1
  %cmp = icmp eq i8 %first.0, -1
  br i1 %cmp, label %do.end, label %do.body

do.end:                                           ; preds = %do.body
  ret i32 0
}

declare void @bar(i32)

attributes #0 = { nounwind uwtable }
attributes #1 = { nounwind }

; With the given initial value for IV, it is not legal to widen
; trip count to IV size
define void @wide_trip_count_test1(float* %autoc,
; CHECK-LABEL: @wide_trip_count_test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[DATA_LEN:%.*]], [[SAMPLE:%.*]]
; CHECK-NEXT:    [[CMP4:%.*]] = icmp eq i32 [[DATA_LEN]], [[SAMPLE]]
; CHECK-NEXT:    br i1 [[CMP4]], label [[FOR_END:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ 68719476736, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[TEMP:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TEMP]], [[SAMPLE]]
; CHECK-NEXT:    [[IDXPROM:%.*]] = zext i32 [[ADD]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[DATA:%.*]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TEMP1:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[TEMP1]], [[D:%.*]]
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[AUTOC:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TEMP2:%.*]] = load float, float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[ADD3:%.*]] = fadd float [[TEMP2]], [[MUL]]
; CHECK-NEXT:    store float [[ADD3]], float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[LFTR_WIDEIV:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[LFTR_WIDEIV]], [[SUB]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
  float* %data,
  float %d, i32 %data_len, i32 %sample) nounwind {
entry:
  %sub = sub i32 %data_len, %sample
  %cmp4 = icmp eq i32 %data_len, %sample
  br i1 %cmp4, label %for.end, label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 68719476736, %entry ]
  %temp = trunc i64 %indvars.iv to i32
  %add = add i32 %temp, %sample
  %idxprom = zext i32 %add to i64
  %arrayidx = getelementptr inbounds float, float* %data, i64 %idxprom
  %temp1 = load float, float* %arrayidx, align 4
  %mul = fmul float %temp1, %d
  %arrayidx2 = getelementptr inbounds float, float* %autoc, i64 %indvars.iv
  %temp2 = load float, float* %arrayidx2, align 4
  %add3 = fadd float %temp2, %mul
  store float %add3, float* %arrayidx2, align 4
  %indvars.iv.next = add i64 %indvars.iv, 1
  %temp3 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp ult i32 %temp3, %sub
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Trip count should be widened and LFTR should canonicalize the condition
define float @wide_trip_count_test2(float* %a,
; CHECK-LABEL: @wide_trip_count_test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp ugt i32 [[M:%.*]], 500
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[M]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ 500, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[SUM_07:%.*]] = phi float [ [[ADD:%.*]], [[FOR_BODY]] ], [ 0.000000e+00, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TEMP:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TEMP1:%.*]] = load float, float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[TEMP]], [[TEMP1]]
; CHECK-NEXT:    [[ADD]] = fadd float [[SUM_07]], [[MUL]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi float [ [[ADD]], [[FOR_BODY]] ]
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_END_LOOPEXIT]] ]
; CHECK-NEXT:    ret float [[SUM_0_LCSSA]]
;
  float* %b,
  i32 zeroext %m) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp ugt i32 %m, 500
  br i1 %cmp5, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %sum.07 = phi float [ %add, %for.body ], [ 0.000000e+00, %for.body.preheader ]
  %i.06 = phi i32 [ %inc, %for.body ], [ 500, %for.body.preheader ]
  %idxprom = zext i32 %i.06 to i64
  %arrayidx = getelementptr inbounds float, float* %b, i64 %idxprom
  %temp = load float, float* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds float, float* %a, i64 %idxprom
  %temp1 = load float, float* %arrayidx2, align 4
  %mul = fmul float %temp, %temp1
  %add = fadd float %sum.07, %mul
  %inc = add i32 %i.06, 1
  %cmp = icmp ult i32 %inc, %m
  br i1 %cmp, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  %sum.0.lcssa = phi float [ 0.000000e+00, %entry ], [ %add, %for.end.loopexit ]
  ret float %sum.0.lcssa
}

; Trip count should be widened and LFTR should canonicalize the condition
define float @wide_trip_count_test3(float* %b,
; CHECK-LABEL: @wide_trip_count_test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[M:%.*]], -10
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = sext i32 [[M]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ -10, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[SUM_07:%.*]] = phi float [ [[ADD1:%.*]], [[FOR_BODY]] ], [ 0.000000e+00, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[INDVARS_IV]], 20
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TEMP:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP1]] to float
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[CONV]], [[TEMP]]
; CHECK-NEXT:    [[ADD1]] = fadd float [[SUM_07]], [[MUL]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    [[ADD1_LCSSA:%.*]] = phi float [ [[ADD1]], [[FOR_BODY]] ]
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[ADD1_LCSSA]], [[FOR_END_LOOPEXIT]] ]
; CHECK-NEXT:    ret float [[SUM_0_LCSSA]]
;
  i32 signext %m) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %m, -10
  br i1 %cmp5, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %sum.07 = phi float [ %add1, %for.body ], [ 0.000000e+00, %for.body.preheader ]
  %i.06 = phi i32 [ %inc, %for.body ], [ -10, %for.body.preheader ]
  %add = add nsw i32 %i.06, 20
  %idxprom = sext i32 %add to i64
  %arrayidx = getelementptr inbounds float, float* %b, i64 %idxprom
  %temp = load float, float* %arrayidx, align 4
  %conv = sitofp i32 %i.06 to float
  %mul = fmul float %conv, %temp
  %add1 = fadd float %sum.07, %mul
  %inc = add nsw i32 %i.06, 1
  %cmp = icmp slt i32 %inc, %m
  br i1 %cmp, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  %sum.0.lcssa = phi float [ 0.000000e+00, %entry ], [ %add1, %for.end.loopexit ]
  ret float %sum.0.lcssa
}

; Trip count should be widened and LFTR should canonicalize the condition
define float @wide_trip_count_test4(float* %b,
; CHECK-LABEL: @wide_trip_count_test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[M:%.*]], 10
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[M]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ 10, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[SUM_07:%.*]] = phi float [ [[ADD1:%.*]], [[FOR_BODY]] ], [ 0.000000e+00, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 20
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TEMP:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP1]] to float
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[CONV]], [[TEMP]]
; CHECK-NEXT:    [[ADD1]] = fadd float [[SUM_07]], [[MUL]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    [[ADD1_LCSSA:%.*]] = phi float [ [[ADD1]], [[FOR_BODY]] ]
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[ADD1_LCSSA]], [[FOR_END_LOOPEXIT]] ]
; CHECK-NEXT:    ret float [[SUM_0_LCSSA]]
;
  i32 signext %m) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %m, 10
  br i1 %cmp5, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %sum.07 = phi float [ %add1, %for.body ], [ 0.000000e+00, %for.body.preheader ]
  %i.06 = phi i32 [ %inc, %for.body ], [ 10, %for.body.preheader ]
  %add = add nsw i32 %i.06, 20
  %idxprom = sext i32 %add to i64
  %arrayidx = getelementptr inbounds float, float* %b, i64 %idxprom
  %temp = load float, float* %arrayidx, align 4
  %conv = sitofp i32 %i.06 to float
  %mul = fmul float %conv, %temp
  %add1 = fadd float %sum.07, %mul
  %inc = add nsw i32 %i.06, 1
  %cmp = icmp slt i32 %inc, %m
  br i1 %cmp, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  %add1.lcssa = phi float [ %add1, %for.body ]
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  %sum.0.lcssa = phi float [ 0.000000e+00, %entry ], [ %add1.lcssa, %for.end.loopexit ]
  ret float %sum.0.lcssa
}

define void @ptr_non_cmp_exit_test() {
; CHECK-LABEL: @ptr_non_cmp_exit_test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY29:%.*]]
; CHECK:       for.body29:
; CHECK-NEXT:    [[IV:%.*]] = phi i8* [ null, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY29]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = load volatile i8, i8* [[IV]], align 1
; CHECK-NEXT:    [[IV_NEXT]] = getelementptr inbounds i8, i8* [[IV]], i64 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i8* [[IV]], inttoptr (i64 10 to i8*)
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY29]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body29

for.body29:
  %iv = phi i8* [ null, %entry ], [ %iv.next, %for.body29 ]
  load volatile i8, i8* %iv, align 1
  %iv.next = getelementptr inbounds i8, i8* %iv, i64 1
  %cmp = icmp ne i8* %iv.next, inttoptr (i64 11 to i8*)
  %and = and i1 %cmp, %cmp
  br i1 %and, label %for.body29, label %exit

exit:
  ret void
}


declare i32 @llvm.loop.decrement.reg.i32(i32, i32)


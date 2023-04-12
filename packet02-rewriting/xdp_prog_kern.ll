; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.collect_vlans = type { [2 x i16] }
%struct.vlan_hdr = type { i16, i16 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.udphdr = type { i16, i16, i16, i16 }
%struct.tcphdr = type { i16, i16, i32, i32, i16, i16, i16, i16 }
%struct.icmp6hdr = type { i8, i8, i16, %union.anon.0 }
%union.anon.0 = type { [1 x i32] }
%struct.icmphdr = type { i8, i8, i16, %union.anon.1 }
%union.anon.1 = type { i32 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !53
@llvm.compiler.used = appending global [5 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_parser_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_port_rewrite_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_vlan_swap_func to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_port_rewrite_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_port_rewrite" !dbg !95 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !99, metadata !DIExpression()), !dbg !207
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !208
  %4 = load i32, i32* %3, align 4, !dbg !208, !tbaa !209
  %5 = zext i32 %4 to i64, !dbg !214
  %6 = inttoptr i64 %5 to i8*, !dbg !215
  call void @llvm.dbg.value(metadata i8* %6, metadata !100, metadata !DIExpression()), !dbg !207
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !216
  %8 = load i32, i32* %7, align 4, !dbg !216, !tbaa !217
  %9 = zext i32 %8 to i64, !dbg !218
  %10 = inttoptr i64 %9 to i8*, !dbg !219
  call void @llvm.dbg.value(metadata i8* %10, metadata !101, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.value(metadata i8* %10, metadata !198, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.value(metadata i32 2, metadata !203, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !102, metadata !DIExpression(DW_OP_deref)), !dbg !207
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !220, metadata !DIExpression()) #6, !dbg !229
  call void @llvm.dbg.value(metadata i8* %6, metadata !227, metadata !DIExpression()) #6, !dbg !229
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !228, metadata !DIExpression()) #6, !dbg !229
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !231, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata i8* %6, metadata !243, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !244, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !245, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata i8* %10, metadata !246, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata i32 14, metadata !247, metadata !DIExpression()) #6, !dbg !256
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !258
  %12 = icmp ugt i8* %11, %6, !dbg !260
  br i1 %12, label %102, label %13, !dbg !261

13:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !246, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata i8* %11, metadata !198, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.value(metadata i8* %11, metadata !248, metadata !DIExpression()) #6, !dbg !256
  %14 = getelementptr inbounds i8, i8* %10, i64 12, !dbg !262
  %15 = bitcast i8* %14 to i16*, !dbg !262
  call void @llvm.dbg.value(metadata i16 undef, metadata !254, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata i32 0, metadata !255, metadata !DIExpression()) #6, !dbg !256
  %16 = load i16, i16* %15, align 1, !dbg !256, !tbaa !263
  call void @llvm.dbg.value(metadata i16 %16, metadata !254, metadata !DIExpression()) #6, !dbg !256
  %17 = inttoptr i64 %5 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i16 %16, metadata !265, metadata !DIExpression()) #6, !dbg !270
  %18 = icmp eq i16 %16, 129, !dbg !276
  %19 = icmp eq i16 %16, -22392, !dbg !277
  %20 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %18) #6
  %21 = or i1 %19, %20, !dbg !277
  %22 = xor i1 %21, true, !dbg !278
  %23 = getelementptr i8, i8* %10, i64 18
  %24 = bitcast i8* %23 to %struct.vlan_hdr*
  %25 = icmp ugt %struct.vlan_hdr* %24, %17
  %26 = select i1 %22, i1 true, i1 %25, !dbg !279
  br i1 %26, label %44, label %27, !dbg !279

27:                                               ; preds = %13
  call void @llvm.dbg.value(metadata i16 undef, metadata !254, metadata !DIExpression()) #6, !dbg !256
  %28 = getelementptr i8, i8* %10, i64 16, !dbg !280
  %29 = bitcast i8* %28 to i16*, !dbg !280
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %24, metadata !248, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata i32 1, metadata !255, metadata !DIExpression()) #6, !dbg !256
  %30 = load i16, i16* %29, align 1, !dbg !256, !tbaa !263
  call void @llvm.dbg.value(metadata i16 %30, metadata !254, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata i16 %30, metadata !265, metadata !DIExpression()) #6, !dbg !270
  %31 = icmp eq i16 %30, 129, !dbg !276
  %32 = icmp eq i16 %30, -22392, !dbg !277
  %33 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %31) #6
  %34 = or i1 %32, %33, !dbg !277
  %35 = xor i1 %34, true, !dbg !278
  %36 = getelementptr i8, i8* %10, i64 22
  %37 = bitcast i8* %36 to %struct.vlan_hdr*
  %38 = icmp ugt %struct.vlan_hdr* %37, %17
  %39 = select i1 %35, i1 true, i1 %38, !dbg !279
  br i1 %39, label %44, label %40, !dbg !279

40:                                               ; preds = %27
  call void @llvm.dbg.value(metadata i16 undef, metadata !254, metadata !DIExpression()) #6, !dbg !256
  %41 = getelementptr i8, i8* %10, i64 20, !dbg !280
  %42 = bitcast i8* %41 to i16*, !dbg !280
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %37, metadata !248, metadata !DIExpression()) #6, !dbg !256
  call void @llvm.dbg.value(metadata i32 2, metadata !255, metadata !DIExpression()) #6, !dbg !256
  %43 = load i16, i16* %42, align 1, !dbg !256, !tbaa !263
  call void @llvm.dbg.value(metadata i16 %43, metadata !254, metadata !DIExpression()) #6, !dbg !256
  br label %44

44:                                               ; preds = %13, %27, %40
  %45 = phi i8* [ %11, %13 ], [ %23, %27 ], [ %36, %40 ], !dbg !256
  %46 = phi i16 [ %16, %13 ], [ %30, %27 ], [ %43, %40 ], !dbg !256
  call void @llvm.dbg.value(metadata i8* %45, metadata !198, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.value(metadata i16 %46, metadata !204, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !207
  switch i16 %46, label %102 [
    i16 -8826, label %47
    i16 8, label %52
  ], !dbg !281

47:                                               ; preds = %44
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !283, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i8* %6, metadata !289, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata %struct.ipv6hdr** undef, metadata !290, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i8* %45, metadata !291, metadata !DIExpression()), !dbg !292
  %48 = getelementptr inbounds i8, i8* %45, i64 40, !dbg !296
  %49 = bitcast i8* %48 to %struct.ipv6hdr*, !dbg !296
  %50 = inttoptr i64 %5 to %struct.ipv6hdr*, !dbg !298
  %51 = icmp ugt %struct.ipv6hdr* %49, %50, !dbg !299
  br i1 %51, label %102, label %64, !dbg !300

52:                                               ; preds = %44
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !150, metadata !DIExpression(DW_OP_deref)), !dbg !207
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !301, metadata !DIExpression()), !dbg !311
  call void @llvm.dbg.value(metadata i8* %6, metadata !307, metadata !DIExpression()), !dbg !311
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !308, metadata !DIExpression()), !dbg !311
  call void @llvm.dbg.value(metadata i8* %45, metadata !309, metadata !DIExpression()), !dbg !311
  %53 = getelementptr inbounds i8, i8* %45, i64 20, !dbg !315
  %54 = icmp ugt i8* %53, %6, !dbg !317
  br i1 %54, label %102, label %55, !dbg !318

55:                                               ; preds = %52
  %56 = load i8, i8* %45, align 4, !dbg !319
  %57 = shl i8 %56, 2, !dbg !320
  %58 = and i8 %57, 60, !dbg !320
  call void @llvm.dbg.value(metadata i8 %58, metadata !310, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !311
  %59 = icmp ult i8 %58, 20, !dbg !321
  br i1 %59, label %102, label %60, !dbg !323

60:                                               ; preds = %55
  %61 = zext i8 %58 to i64
  call void @llvm.dbg.value(metadata i64 %61, metadata !310, metadata !DIExpression()), !dbg !311
  %62 = getelementptr i8, i8* %45, i64 %61, !dbg !324
  %63 = icmp ugt i8* %62, %6, !dbg !326
  br i1 %63, label %102, label %64, !dbg !327

64:                                               ; preds = %60, %47
  %65 = phi i64 [ 6, %47 ], [ 9, %60 ]
  %66 = phi i8* [ %48, %47 ], [ %62, %60 ], !dbg !328
  %67 = getelementptr inbounds i8, i8* %45, i64 %65, !dbg !329
  %68 = load i8, i8* %67, align 1, !dbg !329, !tbaa !330
  call void @llvm.dbg.value(metadata i8* %66, metadata !198, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.value(metadata i8 %68, metadata !205, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !207
  switch i8 %68, label %102 [
    i8 17, label %69
    i8 6, label %80
  ], !dbg !331

69:                                               ; preds = %64
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !332, metadata !DIExpression()) #6, !dbg !342
  call void @llvm.dbg.value(metadata i8* %6, metadata !338, metadata !DIExpression()) #6, !dbg !342
  call void @llvm.dbg.value(metadata %struct.udphdr** undef, metadata !339, metadata !DIExpression()) #6, !dbg !342
  call void @llvm.dbg.value(metadata i8* %66, metadata !341, metadata !DIExpression()) #6, !dbg !342
  %70 = getelementptr inbounds i8, i8* %66, i64 8, !dbg !347
  %71 = bitcast i8* %70 to %struct.udphdr*, !dbg !347
  %72 = inttoptr i64 %5 to %struct.udphdr*, !dbg !349
  %73 = icmp ugt %struct.udphdr* %71, %72, !dbg !350
  br i1 %73, label %102, label %74, !dbg !351

74:                                               ; preds = %69
  call void @llvm.dbg.value(metadata %struct.udphdr* %71, metadata !198, metadata !DIExpression()), !dbg !207
  %75 = getelementptr inbounds i8, i8* %66, i64 4, !dbg !352
  %76 = bitcast i8* %75 to i16*, !dbg !352
  %77 = load i16, i16* %76, align 2, !dbg !352, !tbaa !353
  %78 = tail call i16 @llvm.bswap.i16(i16 %77) #6
  call void @llvm.dbg.value(metadata i16 %78, metadata !340, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #6, !dbg !342
  %79 = icmp ult i16 %78, 8, !dbg !355
  br i1 %79, label %102, label %94, !dbg !357

80:                                               ; preds = %64
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !358, metadata !DIExpression()), !dbg !368
  call void @llvm.dbg.value(metadata i8* %6, metadata !364, metadata !DIExpression()), !dbg !368
  call void @llvm.dbg.value(metadata %struct.tcphdr** undef, metadata !365, metadata !DIExpression()), !dbg !368
  call void @llvm.dbg.value(metadata i8* %66, metadata !367, metadata !DIExpression()), !dbg !368
  %81 = getelementptr inbounds i8, i8* %66, i64 20, !dbg !373
  %82 = icmp ugt i8* %81, %6, !dbg !375
  br i1 %82, label %102, label %83, !dbg !376

83:                                               ; preds = %80
  %84 = getelementptr inbounds i8, i8* %66, i64 12, !dbg !377
  %85 = bitcast i8* %84 to i16*, !dbg !377
  %86 = load i16, i16* %85, align 4, !dbg !377
  %87 = lshr i16 %86, 2, !dbg !378
  %88 = and i16 %87, 60, !dbg !378
  call void @llvm.dbg.value(metadata i16 %88, metadata !366, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !368
  %89 = icmp ult i16 %88, 20, !dbg !379
  br i1 %89, label %102, label %90, !dbg !381

90:                                               ; preds = %83
  %91 = zext i16 %88 to i64
  %92 = getelementptr i8, i8* %66, i64 %91, !dbg !382
  %93 = icmp ugt i8* %92, %6, !dbg !384
  br i1 %93, label %102, label %94, !dbg !385

94:                                               ; preds = %90, %74
  %95 = phi i16 [ -1, %74 ], [ 1, %90 ]
  %96 = getelementptr inbounds i8, i8* %66, i64 2, !dbg !386
  %97 = bitcast i8* %96 to i16*, !dbg !386
  %98 = load i16, i16* %97, align 2, !dbg !386, !tbaa !263
  %99 = tail call i16 @llvm.bswap.i16(i16 %98)
  %100 = add i16 %99, %95, !dbg !386
  %101 = tail call i16 @llvm.bswap.i16(i16 %100), !dbg !386
  store i16 %101, i16* %97, align 2, !dbg !386, !tbaa !263
  br label %102, !dbg !387

102:                                              ; preds = %94, %90, %83, %80, %74, %69, %60, %55, %52, %47, %1, %64, %44
  %103 = phi i32 [ 2, %44 ], [ 2, %64 ], [ 0, %1 ], [ 2, %47 ], [ 2, %52 ], [ 2, %55 ], [ 2, %60 ], [ 0, %69 ], [ 0, %74 ], [ 0, %80 ], [ 0, %83 ], [ 0, %90 ], [ 2, %94 ], !dbg !207
  call void @llvm.dbg.value(metadata i32 %103, metadata !203, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.label(metadata !206), !dbg !404
  %104 = bitcast i32* %2 to i8*, !dbg !387
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %104), !dbg !387
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !392, metadata !DIExpression()) #6, !dbg !387
  call void @llvm.dbg.value(metadata i32 %103, metadata !393, metadata !DIExpression()) #6, !dbg !387
  store i32 %103, i32* %2, align 4, !tbaa !405
  call void @llvm.dbg.value(metadata i32* %2, metadata !393, metadata !DIExpression(DW_OP_deref)) #6, !dbg !387
  %105 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %104) #6, !dbg !406
  call void @llvm.dbg.value(metadata i8* %105, metadata !394, metadata !DIExpression()) #6, !dbg !387
  %106 = icmp eq i8* %105, null, !dbg !407
  br i1 %106, label %120, label %107, !dbg !409

107:                                              ; preds = %102
  call void @llvm.dbg.value(metadata i8* %105, metadata !394, metadata !DIExpression()) #6, !dbg !387
  %108 = bitcast i8* %105 to i64*, !dbg !410
  %109 = load i64, i64* %108, align 8, !dbg !411, !tbaa !412
  %110 = add i64 %109, 1, !dbg !411
  store i64 %110, i64* %108, align 8, !dbg !411, !tbaa !412
  %111 = load i32, i32* %3, align 4, !dbg !415, !tbaa !209
  %112 = load i32, i32* %7, align 4, !dbg !416, !tbaa !217
  %113 = sub i32 %111, %112, !dbg !417
  %114 = zext i32 %113 to i64, !dbg !418
  %115 = getelementptr inbounds i8, i8* %105, i64 8, !dbg !419
  %116 = bitcast i8* %115 to i64*, !dbg !419
  %117 = load i64, i64* %116, align 8, !dbg !420, !tbaa !421
  %118 = add i64 %117, %114, !dbg !420
  store i64 %118, i64* %116, align 8, !dbg !420, !tbaa !421
  %119 = load i32, i32* %2, align 4, !dbg !422, !tbaa !405
  call void @llvm.dbg.value(metadata i32 %119, metadata !393, metadata !DIExpression()) #6, !dbg !387
  br label %120, !dbg !423

120:                                              ; preds = %102, %107
  %121 = phi i32 [ %119, %107 ], [ 0, %102 ], !dbg !387
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %104), !dbg !424
  ret i32 %121, !dbg !425
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind
define dso_local i32 @xdp_vlan_swap_func(%struct.xdp_md* noundef %0) #0 section "xdp_vlan_swap" !dbg !426 {
  %2 = alloca %struct.ethhdr, align 1
  %3 = alloca %struct.ethhdr, align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !428, metadata !DIExpression()), !dbg !434
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !435
  %5 = load i32, i32* %4, align 4, !dbg !435, !tbaa !209
  %6 = zext i32 %5 to i64, !dbg !436
  %7 = inttoptr i64 %6 to i8*, !dbg !437
  call void @llvm.dbg.value(metadata i8* %7, metadata !429, metadata !DIExpression()), !dbg !434
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !438
  %9 = load i32, i32* %8, align 4, !dbg !438, !tbaa !217
  %10 = zext i32 %9 to i64, !dbg !439
  %11 = inttoptr i64 %10 to i8*, !dbg !440
  call void @llvm.dbg.value(metadata i8* %11, metadata !430, metadata !DIExpression()), !dbg !434
  call void @llvm.dbg.value(metadata i8* %11, metadata !431, metadata !DIExpression()), !dbg !434
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !220, metadata !DIExpression()) #6, !dbg !441
  call void @llvm.dbg.value(metadata i8* %7, metadata !227, metadata !DIExpression()) #6, !dbg !441
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !228, metadata !DIExpression()) #6, !dbg !441
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !231, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata i8* %7, metadata !243, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !244, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !245, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata i8* %11, metadata !246, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata i32 14, metadata !247, metadata !DIExpression()) #6, !dbg !443
  %12 = getelementptr i8, i8* %11, i64 14, !dbg !445
  %13 = icmp ugt i8* %12, %7, !dbg !446
  br i1 %13, label %75, label %14, !dbg !447

14:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %11, metadata !246, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata i8* %12, metadata !431, metadata !DIExpression()), !dbg !434
  %15 = inttoptr i64 %10 to %struct.ethhdr*, !dbg !448
  call void @llvm.dbg.value(metadata i8* %12, metadata !248, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata i16 undef, metadata !254, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata i32 0, metadata !255, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata i16 undef, metadata !254, metadata !DIExpression()) #6, !dbg !443
  call void @llvm.dbg.value(metadata i16 undef, metadata !265, metadata !DIExpression()) #6, !dbg !449
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !431, metadata !DIExpression()), !dbg !434
  call void @llvm.dbg.value(metadata i16 undef, metadata !432, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !434
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !433, metadata !DIExpression()), !dbg !434
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 2, !dbg !451
  %17 = load i16, i16* %16, align 1, !dbg !451, !tbaa !453
  call void @llvm.dbg.value(metadata i16 %17, metadata !265, metadata !DIExpression()) #6, !dbg !455
  %18 = icmp eq i16 %17, 129, !dbg !457
  %19 = icmp eq i16 %17, -22392, !dbg !458
  %20 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %18) #6
  %21 = or i1 %19, %20, !dbg !458
  br i1 %21, label %22, label %48, !dbg !459

22:                                               ; preds = %14
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !460, metadata !DIExpression()) #6, !dbg !471
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !465, metadata !DIExpression()) #6, !dbg !471
  call void @llvm.dbg.value(metadata i32 %5, metadata !466, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)) #6, !dbg !471
  %23 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %3, i64 0, i32 0, i64 0, !dbg !473
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %23), !dbg !473
  call void @llvm.dbg.declare(metadata %struct.ethhdr* %3, metadata !467, metadata !DIExpression()) #6, !dbg !474
  call void @llvm.dbg.value(metadata i32 -1, metadata !470, metadata !DIExpression()) #6, !dbg !471
  call void @llvm.dbg.value(metadata i16 %17, metadata !265, metadata !DIExpression()) #6, !dbg !475
  %24 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 1, i32 0, i64 4
  %25 = bitcast i8* %24 to %struct.vlan_hdr*
  %26 = inttoptr i64 %6 to %struct.vlan_hdr*
  %27 = icmp ult %struct.vlan_hdr* %25, %26
  call void @llvm.dbg.value(metadata i64 %6, metadata !466, metadata !DIExpression()) #6, !dbg !471
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !468, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)) #6, !dbg !471
  br i1 %27, label %28, label %47, !dbg !478

28:                                               ; preds = %22
  call void @llvm.dbg.value(metadata i32 undef, metadata !470, metadata !DIExpression()) #6, !dbg !471
  %29 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 1, i32 0, i64 2, !dbg !479
  %30 = bitcast i8* %29 to i16*, !dbg !479
  %31 = load i16, i16* %30, align 2, !dbg !479, !tbaa !483
  call void @llvm.dbg.value(metadata i16 %31, metadata !469, metadata !DIExpression()) #6, !dbg !471
  %32 = getelementptr %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 0, i64 0, !dbg !485
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(14) %23, i8* noundef nonnull align 1 dereferenceable(14) %32, i64 14, i1 false) #6, !dbg !485
  %33 = tail call i32 inttoptr (i64 44 to i32 (%struct.xdp_md*, i32)*)(%struct.xdp_md* noundef nonnull %0, i32 noundef 4) #6, !dbg !486
  %34 = icmp eq i32 %33, 0, !dbg !486
  br i1 %34, label %35, label %47, !dbg !488

35:                                               ; preds = %28
  %36 = load i32, i32* %8, align 4, !dbg !489, !tbaa !217
  %37 = zext i32 %36 to i64, !dbg !490
  %38 = inttoptr i64 %37 to %struct.ethhdr*, !dbg !491
  call void @llvm.dbg.value(metadata %struct.ethhdr* %38, metadata !465, metadata !DIExpression()) #6, !dbg !471
  %39 = load i32, i32* %4, align 4, !dbg !492, !tbaa !209
  %40 = zext i32 %39 to i64, !dbg !493
  call void @llvm.dbg.value(metadata i64 %40, metadata !466, metadata !DIExpression()) #6, !dbg !471
  %41 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %38, i64 1, !dbg !494
  %42 = inttoptr i64 %40 to %struct.ethhdr*, !dbg !496
  %43 = icmp ugt %struct.ethhdr* %41, %42, !dbg !497
  br i1 %43, label %47, label %44, !dbg !498

44:                                               ; preds = %35
  %45 = inttoptr i64 %37 to i8*, !dbg !491
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(14) %45, i8* noundef nonnull align 1 dereferenceable(14) %23, i64 14, i1 false) #6, !dbg !499
  %46 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %38, i64 0, i32 2, !dbg !500
  store i16 %31, i16* %46, align 1, !dbg !501, !tbaa !453
  br label %47, !dbg !502

47:                                               ; preds = %22, %28, %35, %44
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %23), !dbg !503
  br label %75, !dbg !504

48:                                               ; preds = %14
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !505, metadata !DIExpression()) #6, !dbg !515
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !510, metadata !DIExpression()) #6, !dbg !515
  call void @llvm.dbg.value(metadata i32 1, metadata !511, metadata !DIExpression()) #6, !dbg !515
  call void @llvm.dbg.value(metadata i32 undef, metadata !512, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)) #6, !dbg !515
  %49 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %2, i64 0, i32 0, i64 0, !dbg !517
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %49), !dbg !517
  call void @llvm.dbg.declare(metadata %struct.ethhdr* %2, metadata !513, metadata !DIExpression()) #6, !dbg !518
  %50 = getelementptr %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 0, i64 0, !dbg !519
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(14) %49, i8* noundef nonnull align 1 dereferenceable(14) %50, i64 14, i1 false) #6, !dbg !519
  %51 = tail call i32 inttoptr (i64 44 to i32 (%struct.xdp_md*, i32)*)(%struct.xdp_md* noundef nonnull %0, i32 noundef -4) #6, !dbg !520
  %52 = icmp eq i32 %51, 0, !dbg !520
  br i1 %52, label %53, label %74, !dbg !522

53:                                               ; preds = %48
  %54 = load i32, i32* %4, align 4, !dbg !523, !tbaa !209
  %55 = zext i32 %54 to i64, !dbg !524
  call void @llvm.dbg.value(metadata i64 %55, metadata !512, metadata !DIExpression()) #6, !dbg !515
  %56 = load i32, i32* %8, align 4, !dbg !525, !tbaa !217
  %57 = zext i32 %56 to i64, !dbg !526
  %58 = inttoptr i64 %57 to %struct.ethhdr*, !dbg !527
  call void @llvm.dbg.value(metadata %struct.ethhdr* %58, metadata !510, metadata !DIExpression()) #6, !dbg !515
  %59 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %58, i64 1, !dbg !528
  %60 = inttoptr i64 %55 to %struct.ethhdr*, !dbg !530
  %61 = icmp ugt %struct.ethhdr* %59, %60, !dbg !531
  br i1 %61, label %74, label %62, !dbg !532

62:                                               ; preds = %53
  call void @llvm.dbg.value(metadata i64 %55, metadata !512, metadata !DIExpression()) #6, !dbg !515
  %63 = inttoptr i64 %57 to i8*, !dbg !527
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(14) %63, i8* noundef nonnull align 1 dereferenceable(14) %49, i64 14, i1 false) #6, !dbg !533
  call void @llvm.dbg.value(metadata %struct.ethhdr* %59, metadata !514, metadata !DIExpression()) #6, !dbg !515
  %64 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %58, i64 1, i32 0, i64 4, !dbg !534
  %65 = bitcast i8* %64 to %struct.vlan_hdr*, !dbg !534
  %66 = inttoptr i64 %55 to %struct.vlan_hdr*, !dbg !536
  %67 = icmp ugt %struct.vlan_hdr* %65, %66, !dbg !537
  br i1 %67, label %74, label %68, !dbg !538

68:                                               ; preds = %62
  %69 = bitcast %struct.ethhdr* %59 to i16*, !dbg !539
  store i16 256, i16* %69, align 2, !dbg !540, !tbaa !541
  %70 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %58, i64 0, i32 2, !dbg !542
  %71 = load i16, i16* %70, align 1, !dbg !542, !tbaa !453
  %72 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %58, i64 1, i32 0, i64 2, !dbg !543
  %73 = bitcast i8* %72 to i16*, !dbg !543
  store i16 %71, i16* %73, align 2, !dbg !544, !tbaa !483
  store i16 129, i16* %70, align 1, !dbg !545, !tbaa !453
  br label %74, !dbg !546

74:                                               ; preds = %48, %53, %62, %68
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %49), !dbg !547
  br label %75

75:                                               ; preds = %1, %47, %74
  ret i32 2, !dbg !548
}

; Function Attrs: nounwind
define dso_local i32 @xdp_parser_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_packet_parser" !dbg !549 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !551, metadata !DIExpression()), !dbg !630
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !631
  %4 = load i32, i32* %3, align 4, !dbg !631, !tbaa !209
  %5 = zext i32 %4 to i64, !dbg !632
  %6 = inttoptr i64 %5 to i8*, !dbg !633
  call void @llvm.dbg.value(metadata i8* %6, metadata !552, metadata !DIExpression()), !dbg !630
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !634
  %8 = load i32, i32* %7, align 4, !dbg !634, !tbaa !217
  %9 = zext i32 %8 to i64, !dbg !635
  %10 = inttoptr i64 %9 to i8*, !dbg !636
  call void @llvm.dbg.value(metadata i8* %10, metadata !553, metadata !DIExpression()), !dbg !630
  call void @llvm.dbg.value(metadata i32 2, metadata !554, metadata !DIExpression()), !dbg !630
  call void @llvm.dbg.value(metadata i8* %10, metadata !555, metadata !DIExpression()), !dbg !630
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !557, metadata !DIExpression(DW_OP_deref)), !dbg !630
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !220, metadata !DIExpression()) #6, !dbg !637
  call void @llvm.dbg.value(metadata i8* %6, metadata !227, metadata !DIExpression()) #6, !dbg !637
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !228, metadata !DIExpression()) #6, !dbg !637
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !231, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata i8* %6, metadata !243, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !244, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !245, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata i8* %10, metadata !246, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata i32 14, metadata !247, metadata !DIExpression()) #6, !dbg !639
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !641
  %12 = icmp ugt i8* %11, %6, !dbg !642
  br i1 %12, label %100, label %13, !dbg !643

13:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !246, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata i8* %11, metadata !555, metadata !DIExpression()), !dbg !630
  call void @llvm.dbg.value(metadata i8* %11, metadata !248, metadata !DIExpression()) #6, !dbg !639
  %14 = getelementptr inbounds i8, i8* %10, i64 12, !dbg !644
  %15 = bitcast i8* %14 to i16*, !dbg !644
  call void @llvm.dbg.value(metadata i16 undef, metadata !254, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata i32 0, metadata !255, metadata !DIExpression()) #6, !dbg !639
  %16 = load i16, i16* %15, align 1, !dbg !639, !tbaa !263
  call void @llvm.dbg.value(metadata i16 %16, metadata !254, metadata !DIExpression()) #6, !dbg !639
  %17 = inttoptr i64 %5 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i16 %16, metadata !265, metadata !DIExpression()) #6, !dbg !645
  %18 = icmp eq i16 %16, 129, !dbg !647
  %19 = icmp eq i16 %16, -22392, !dbg !648
  %20 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %18) #6
  %21 = or i1 %19, %20, !dbg !648
  %22 = xor i1 %21, true, !dbg !649
  %23 = getelementptr i8, i8* %10, i64 18
  %24 = bitcast i8* %23 to %struct.vlan_hdr*
  %25 = icmp ugt %struct.vlan_hdr* %24, %17
  %26 = select i1 %22, i1 true, i1 %25, !dbg !650
  br i1 %26, label %44, label %27, !dbg !650

27:                                               ; preds = %13
  call void @llvm.dbg.value(metadata i16 undef, metadata !254, metadata !DIExpression()) #6, !dbg !639
  %28 = getelementptr i8, i8* %10, i64 16, !dbg !651
  %29 = bitcast i8* %28 to i16*, !dbg !651
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %24, metadata !248, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata i32 1, metadata !255, metadata !DIExpression()) #6, !dbg !639
  %30 = load i16, i16* %29, align 1, !dbg !639, !tbaa !263
  call void @llvm.dbg.value(metadata i16 %30, metadata !254, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata i16 %30, metadata !265, metadata !DIExpression()) #6, !dbg !645
  %31 = icmp eq i16 %30, 129, !dbg !647
  %32 = icmp eq i16 %30, -22392, !dbg !648
  %33 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %31) #6
  %34 = or i1 %32, %33, !dbg !648
  %35 = xor i1 %34, true, !dbg !649
  %36 = getelementptr i8, i8* %10, i64 22
  %37 = bitcast i8* %36 to %struct.vlan_hdr*
  %38 = icmp ugt %struct.vlan_hdr* %37, %17
  %39 = select i1 %35, i1 true, i1 %38, !dbg !650
  br i1 %39, label %44, label %40, !dbg !650

40:                                               ; preds = %27
  call void @llvm.dbg.value(metadata i16 undef, metadata !254, metadata !DIExpression()) #6, !dbg !639
  %41 = getelementptr i8, i8* %10, i64 20, !dbg !651
  %42 = bitcast i8* %41 to i16*, !dbg !651
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %37, metadata !248, metadata !DIExpression()) #6, !dbg !639
  call void @llvm.dbg.value(metadata i32 2, metadata !255, metadata !DIExpression()) #6, !dbg !639
  %43 = load i16, i16* %42, align 1, !dbg !639, !tbaa !263
  call void @llvm.dbg.value(metadata i16 %43, metadata !254, metadata !DIExpression()) #6, !dbg !639
  br label %44

44:                                               ; preds = %13, %27, %40
  %45 = phi i8* [ %11, %13 ], [ %23, %27 ], [ %36, %40 ], !dbg !639
  %46 = phi i16 [ %16, %13 ], [ %30, %27 ], [ %43, %40 ], !dbg !639
  call void @llvm.dbg.value(metadata i8* %45, metadata !555, metadata !DIExpression()), !dbg !630
  call void @llvm.dbg.value(metadata i16 %46, metadata !556, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !630
  switch i16 %46, label %100 [
    i16 -8826, label %47
    i16 8, label %66
  ], !dbg !652

47:                                               ; preds = %44
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !283, metadata !DIExpression()), !dbg !653
  call void @llvm.dbg.value(metadata i8* %6, metadata !289, metadata !DIExpression()), !dbg !653
  call void @llvm.dbg.value(metadata %struct.ipv6hdr** undef, metadata !290, metadata !DIExpression()), !dbg !653
  call void @llvm.dbg.value(metadata i8* %45, metadata !291, metadata !DIExpression()), !dbg !653
  %48 = getelementptr inbounds i8, i8* %45, i64 40, !dbg !655
  %49 = bitcast i8* %48 to %struct.ipv6hdr*, !dbg !655
  %50 = inttoptr i64 %5 to %struct.ipv6hdr*, !dbg !656
  %51 = icmp ugt %struct.ipv6hdr* %49, %50, !dbg !657
  br i1 %51, label %100, label %52, !dbg !658

52:                                               ; preds = %47
  call void @llvm.dbg.value(metadata i8* %45, metadata !291, metadata !DIExpression()), !dbg !653
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %49, metadata !555, metadata !DIExpression()), !dbg !630
  %53 = getelementptr inbounds i8, i8* %45, i64 6, !dbg !659
  %54 = load i8, i8* %53, align 2, !dbg !659, !tbaa !660
  call void @llvm.dbg.value(metadata i8 %54, metadata !556, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !630
  %55 = icmp ne i8 %54, 58, !dbg !663
  %56 = getelementptr inbounds i8, i8* %45, i64 48
  %57 = bitcast i8* %56 to %struct.icmp6hdr*
  %58 = inttoptr i64 %5 to %struct.icmp6hdr*
  %59 = icmp ugt %struct.icmp6hdr* %57, %58
  %60 = select i1 %55, i1 true, i1 %59, !dbg !665
  call void @llvm.dbg.value(metadata i8* %48, metadata !555, metadata !DIExpression()), !dbg !630
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !666, metadata !DIExpression()), !dbg !675
  call void @llvm.dbg.value(metadata i8* %6, metadata !672, metadata !DIExpression()), !dbg !675
  call void @llvm.dbg.value(metadata %struct.icmp6hdr** undef, metadata !673, metadata !DIExpression()), !dbg !675
  call void @llvm.dbg.value(metadata i8* %48, metadata !674, metadata !DIExpression()), !dbg !675
  br i1 %60, label %100, label %61, !dbg !665

61:                                               ; preds = %52
  call void @llvm.dbg.value(metadata %struct.icmp6hdr* undef, metadata !555, metadata !DIExpression()), !dbg !630
  %62 = load i8, i8* %48, align 4, !dbg !677, !tbaa !678
  call void @llvm.dbg.value(metadata i8 %62, metadata !556, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !630
  %63 = icmp eq i8 %62, -128, !dbg !680
  br i1 %63, label %64, label %100, !dbg !682

64:                                               ; preds = %61
  call void @llvm.dbg.value(metadata i8* %48, metadata !561, metadata !DIExpression()), !dbg !683
  %65 = getelementptr inbounds i8, i8* %45, i64 46, !dbg !684
  call void @llvm.dbg.value(metadata i32 undef, metadata !554, metadata !DIExpression()), !dbg !630
  br label %93, !dbg !686

66:                                               ; preds = %44
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !603, metadata !DIExpression(DW_OP_deref)), !dbg !687
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !301, metadata !DIExpression()), !dbg !688
  call void @llvm.dbg.value(metadata i8* %6, metadata !307, metadata !DIExpression()), !dbg !688
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !308, metadata !DIExpression()), !dbg !688
  call void @llvm.dbg.value(metadata i8* %45, metadata !309, metadata !DIExpression()), !dbg !688
  %67 = getelementptr inbounds i8, i8* %45, i64 20, !dbg !690
  %68 = icmp ugt i8* %67, %6, !dbg !691
  br i1 %68, label %100, label %69, !dbg !692

69:                                               ; preds = %66
  %70 = load i8, i8* %45, align 4, !dbg !693
  %71 = shl i8 %70, 2, !dbg !694
  %72 = and i8 %71, 60, !dbg !694
  call void @llvm.dbg.value(metadata i8 %72, metadata !310, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !688
  %73 = icmp ult i8 %72, 20, !dbg !695
  br i1 %73, label %100, label %74, !dbg !696

74:                                               ; preds = %69
  %75 = zext i8 %72 to i64
  call void @llvm.dbg.value(metadata i64 %75, metadata !310, metadata !DIExpression()), !dbg !688
  %76 = getelementptr i8, i8* %45, i64 %75, !dbg !697
  %77 = icmp ugt i8* %76, %6, !dbg !698
  br i1 %77, label %100, label %78, !dbg !699

78:                                               ; preds = %74
  call void @llvm.dbg.value(metadata i8* %76, metadata !555, metadata !DIExpression()), !dbg !630
  %79 = getelementptr inbounds i8, i8* %45, i64 9, !dbg !700
  %80 = load i8, i8* %79, align 1, !dbg !700, !tbaa !701
  call void @llvm.dbg.value(metadata i8 %80, metadata !556, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !630
  %81 = icmp ne i8 %80, 1, !dbg !703
  %82 = getelementptr inbounds i8, i8* %76, i64 8
  %83 = bitcast i8* %82 to %struct.icmphdr*
  %84 = inttoptr i64 %5 to %struct.icmphdr*
  %85 = icmp ugt %struct.icmphdr* %83, %84
  %86 = select i1 %81, i1 true, i1 %85, !dbg !705
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !706, metadata !DIExpression()), !dbg !715
  call void @llvm.dbg.value(metadata i8* %6, metadata !712, metadata !DIExpression()), !dbg !715
  call void @llvm.dbg.value(metadata %struct.icmphdr** undef, metadata !713, metadata !DIExpression()), !dbg !715
  call void @llvm.dbg.value(metadata i8* %76, metadata !714, metadata !DIExpression()), !dbg !715
  br i1 %86, label %100, label %87, !dbg !705

87:                                               ; preds = %78
  call void @llvm.dbg.value(metadata %struct.icmphdr* undef, metadata !555, metadata !DIExpression()), !dbg !630
  %88 = load i8, i8* %76, align 4, !dbg !717, !tbaa !718
  call void @llvm.dbg.value(metadata i8 %88, metadata !556, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !630
  %89 = icmp eq i8 %88, 8, !dbg !720
  br i1 %89, label %90, label %100, !dbg !722

90:                                               ; preds = %87
  call void @llvm.dbg.value(metadata i8* %76, metadata !606, metadata !DIExpression()), !dbg !687
  %91 = getelementptr inbounds i8, i8* %76, i64 4, !dbg !723
  %92 = getelementptr inbounds i8, i8* %91, i64 2, !dbg !723
  call void @llvm.dbg.value(metadata i32 %99, metadata !554, metadata !DIExpression()), !dbg !630
  br label %93, !dbg !725

93:                                               ; preds = %64, %90
  %94 = phi i8* [ %92, %90 ], [ %65, %64 ]
  %95 = bitcast i8* %94 to i16*, !dbg !726
  %96 = load i16, i16* %95, align 2, !dbg !726, !tbaa !330
  %97 = and i16 %96, 256, !dbg !726
  %98 = icmp eq i16 %97, 0, !dbg !726
  %99 = select i1 %98, i32 1, i32 2, !dbg !726
  br label %100, !dbg !727

100:                                              ; preds = %93, %74, %69, %66, %47, %1, %78, %87, %52, %61, %44
  %101 = phi i32 [ 2, %44 ], [ 2, %52 ], [ 2, %61 ], [ 2, %78 ], [ 2, %87 ], [ 2, %1 ], [ 2, %47 ], [ 2, %66 ], [ 2, %69 ], [ 2, %74 ], [ %99, %93 ], !dbg !729
  call void @llvm.dbg.value(metadata i32 %101, metadata !554, metadata !DIExpression()), !dbg !630
  call void @llvm.dbg.label(metadata !629), !dbg !730
  %102 = bitcast i32* %2 to i8*, !dbg !727
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %102), !dbg !727
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !392, metadata !DIExpression()) #6, !dbg !727
  call void @llvm.dbg.value(metadata i32 %101, metadata !393, metadata !DIExpression()) #6, !dbg !727
  store i32 %101, i32* %2, align 4, !tbaa !405
  call void @llvm.dbg.value(metadata i32* %2, metadata !393, metadata !DIExpression(DW_OP_deref)) #6, !dbg !727
  %103 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %102) #6, !dbg !731
  call void @llvm.dbg.value(metadata i8* %103, metadata !394, metadata !DIExpression()) #6, !dbg !727
  %104 = icmp eq i8* %103, null, !dbg !732
  br i1 %104, label %118, label %105, !dbg !733

105:                                              ; preds = %100
  call void @llvm.dbg.value(metadata i8* %103, metadata !394, metadata !DIExpression()) #6, !dbg !727
  %106 = bitcast i8* %103 to i64*, !dbg !734
  %107 = load i64, i64* %106, align 8, !dbg !735, !tbaa !412
  %108 = add i64 %107, 1, !dbg !735
  store i64 %108, i64* %106, align 8, !dbg !735, !tbaa !412
  %109 = load i32, i32* %3, align 4, !dbg !736, !tbaa !209
  %110 = load i32, i32* %7, align 4, !dbg !737, !tbaa !217
  %111 = sub i32 %109, %110, !dbg !738
  %112 = zext i32 %111 to i64, !dbg !739
  %113 = getelementptr inbounds i8, i8* %103, i64 8, !dbg !740
  %114 = bitcast i8* %113 to i64*, !dbg !740
  %115 = load i64, i64* %114, align 8, !dbg !741, !tbaa !421
  %116 = add i64 %115, %112, !dbg !741
  store i64 %116, i64* %114, align 8, !dbg !741, !tbaa !421
  %117 = load i32, i32* %2, align 4, !dbg !742, !tbaa !405
  call void @llvm.dbg.value(metadata i32 %117, metadata !393, metadata !DIExpression()) #6, !dbg !727
  br label %118, !dbg !743

118:                                              ; preds = %100, %105
  %119 = phi i32 [ %117, %105 ], [ 0, %100 ], !dbg !727
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %102), !dbg !744
  ret i32 %119, !dbg !745
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

; Function Attrs: nounwind readnone
declare i1 @llvm.bpf.passthrough.i1.i1(i32, i1) #5

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nounwind readnone }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!90, !91, !92, !93}
!llvm.ident = !{!94}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !81, line: 16, type: !82, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !45, globals: !52, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet02-rewriting", checksumkind: CSK_MD5, checksum: "b1e35a780a400e427ee6e7153d7dec93")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet02-rewriting", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 28, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "9a7f04155c254fef1b7ada5eb82c984c")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!38 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!39 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!40 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!41 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!42 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!43 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!44 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!45 = !{!46, !47, !48, !51}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!47 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !49, line: 24, baseType: !50)
!49 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!50 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!51 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!52 = !{!0, !53, !59, !67}
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 237, type: !55, isLocal: false, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 32, elements: !57)
!56 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!57 = !{!58}
!58 = !DISubrange(count: 4)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !61, line: 33, type: !62, isLocal: true, isDefinition: true)
!61 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet02-rewriting", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DISubroutineType(types: !64)
!64 = !{!46, !46, !65}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "bpf_xdp_adjust_head", scope: !2, file: !61, line: 1100, type: !69, isLocal: true, isDefinition: true)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DISubroutineType(types: !71)
!71 = !{!51, !72, !51}
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !74)
!74 = !{!75, !77, !78, !79, !80}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !73, file: !6, line: 2857, baseType: !76, size: 32)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !49, line: 27, baseType: !7)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !73, file: !6, line: 2858, baseType: !76, size: 32, offset: 32)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !73, file: !6, line: 2859, baseType: !76, size: 32, offset: 64)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !73, file: !6, line: 2861, baseType: !76, size: 32, offset: 96)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !73, file: !6, line: 2862, baseType: !76, size: 32, offset: 128)
!81 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet02-rewriting", checksumkind: CSK_MD5, checksum: "0f65d57b07088eec24d5031993b90668")
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !83, line: 33, size: 160, elements: !84)
!83 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet02-rewriting", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!84 = !{!85, !86, !87, !88, !89}
!85 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !82, file: !83, line: 34, baseType: !7, size: 32)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !82, file: !83, line: 35, baseType: !7, size: 32, offset: 32)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !82, file: !83, line: 36, baseType: !7, size: 32, offset: 64)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !82, file: !83, line: 37, baseType: !7, size: 32, offset: 96)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !82, file: !83, line: 38, baseType: !7, size: 32, offset: 128)
!90 = !{i32 7, !"Dwarf Version", i32 5}
!91 = !{i32 2, !"Debug Info Version", i32 3}
!92 = !{i32 1, !"wchar_size", i32 4}
!93 = !{i32 7, !"frame-pointer", i32 2}
!94 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!95 = distinct !DISubprogram(name: "xdp_port_rewrite_func", scope: !3, file: !3, line: 101, type: !96, scopeLine: 102, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !98)
!96 = !DISubroutineType(types: !97)
!97 = !{!51, !72}
!98 = !{!99, !100, !101, !102, !116, !150, !167, !176, !198, !203, !204, !205, !206}
!99 = !DILocalVariable(name: "ctx", arg: 1, scope: !95, file: !3, line: 101, type: !72)
!100 = !DILocalVariable(name: "data_end", scope: !95, file: !3, line: 103, type: !46)
!101 = !DILocalVariable(name: "data", scope: !95, file: !3, line: 104, type: !46)
!102 = !DILocalVariable(name: "eth", scope: !95, file: !3, line: 105, type: !103)
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !105, line: 168, size: 112, elements: !106)
!105 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!106 = !{!107, !112, !113}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !104, file: !105, line: 169, baseType: !108, size: 48)
!108 = !DICompositeType(tag: DW_TAG_array_type, baseType: !109, size: 48, elements: !110)
!109 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!110 = !{!111}
!111 = !DISubrange(count: 6)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !104, file: !105, line: 170, baseType: !108, size: 48, offset: 48)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !104, file: !105, line: 171, baseType: !114, size: 16, offset: 96)
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !115, line: 25, baseType: !48)
!115 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!116 = !DILocalVariable(name: "ip6h", scope: !95, file: !3, line: 106, type: !117)
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !119, line: 117, size: 320, elements: !120)
!119 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "d13a9e1225644902b024ce986c8e059d")
!120 = !{!121, !123, !124, !128, !129, !130, !131, !149}
!121 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !118, file: !119, line: 119, baseType: !122, size: 4, flags: DIFlagBitField, extraData: i64 0)
!122 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !49, line: 21, baseType: !109)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !118, file: !119, line: 120, baseType: !122, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !118, file: !119, line: 127, baseType: !125, size: 24, offset: 8)
!125 = !DICompositeType(tag: DW_TAG_array_type, baseType: !122, size: 24, elements: !126)
!126 = !{!127}
!127 = !DISubrange(count: 3)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !118, file: !119, line: 129, baseType: !114, size: 16, offset: 32)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !118, file: !119, line: 130, baseType: !122, size: 8, offset: 48)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !118, file: !119, line: 131, baseType: !122, size: 8, offset: 56)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !118, file: !119, line: 133, baseType: !132, size: 128, offset: 64)
!132 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !133, line: 33, size: 128, elements: !134)
!133 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "", checksumkind: CSK_MD5, checksum: "8bebb780b45d3fe932cc1d934fa5f5fe")
!134 = !{!135}
!135 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !132, file: !133, line: 40, baseType: !136, size: 128)
!136 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !132, file: !133, line: 34, size: 128, elements: !137)
!137 = !{!138, !142, !146}
!138 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !136, file: !133, line: 35, baseType: !139, size: 128)
!139 = !DICompositeType(tag: DW_TAG_array_type, baseType: !122, size: 128, elements: !140)
!140 = !{!141}
!141 = !DISubrange(count: 16)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !136, file: !133, line: 37, baseType: !143, size: 128)
!143 = !DICompositeType(tag: DW_TAG_array_type, baseType: !114, size: 128, elements: !144)
!144 = !{!145}
!145 = !DISubrange(count: 8)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !136, file: !133, line: 38, baseType: !147, size: 128)
!147 = !DICompositeType(tag: DW_TAG_array_type, baseType: !148, size: 128, elements: !57)
!148 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !115, line: 27, baseType: !76)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !118, file: !119, line: 134, baseType: !132, size: 128, offset: 192)
!150 = !DILocalVariable(name: "iph", scope: !95, file: !3, line: 107, type: !151)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!152 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !153, line: 86, size: 160, elements: !154)
!153 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "8776158f5e307e9a8189f0dae4b43df4")
!154 = !{!155, !156, !157, !158, !159, !160, !161, !162, !163, !165, !166}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !152, file: !153, line: 88, baseType: !122, size: 4, flags: DIFlagBitField, extraData: i64 0)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !152, file: !153, line: 89, baseType: !122, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !152, file: !153, line: 96, baseType: !122, size: 8, offset: 8)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !152, file: !153, line: 97, baseType: !114, size: 16, offset: 16)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !152, file: !153, line: 98, baseType: !114, size: 16, offset: 32)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !152, file: !153, line: 99, baseType: !114, size: 16, offset: 48)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !152, file: !153, line: 100, baseType: !122, size: 8, offset: 64)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !152, file: !153, line: 101, baseType: !122, size: 8, offset: 72)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !152, file: !153, line: 102, baseType: !164, size: 16, offset: 80)
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !115, line: 31, baseType: !48)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !152, file: !153, line: 103, baseType: !148, size: 32, offset: 96)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !152, file: !153, line: 104, baseType: !148, size: 32, offset: 128)
!167 = !DILocalVariable(name: "udphdr", scope: !95, file: !3, line: 108, type: !168)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !170, line: 23, size: 64, elements: !171)
!170 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!171 = !{!172, !173, !174, !175}
!172 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !169, file: !170, line: 24, baseType: !114, size: 16)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !169, file: !170, line: 25, baseType: !114, size: 16, offset: 16)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !169, file: !170, line: 26, baseType: !114, size: 16, offset: 32)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !169, file: !170, line: 27, baseType: !164, size: 16, offset: 48)
!176 = !DILocalVariable(name: "tcphdr", scope: !95, file: !3, line: 109, type: !177)
!177 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !178, size: 64)
!178 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !179, line: 25, size: 160, elements: !180)
!179 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "", checksumkind: CSK_MD5, checksum: "8d74bf2133e7b3dab885994b9916aa13")
!180 = !{!181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195, !196, !197}
!181 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !178, file: !179, line: 26, baseType: !114, size: 16)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !178, file: !179, line: 27, baseType: !114, size: 16, offset: 16)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !178, file: !179, line: 28, baseType: !148, size: 32, offset: 32)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !178, file: !179, line: 29, baseType: !148, size: 32, offset: 64)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !178, file: !179, line: 31, baseType: !48, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !178, file: !179, line: 32, baseType: !48, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !178, file: !179, line: 33, baseType: !48, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !178, file: !179, line: 34, baseType: !48, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !178, file: !179, line: 35, baseType: !48, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !178, file: !179, line: 36, baseType: !48, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !178, file: !179, line: 37, baseType: !48, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !178, file: !179, line: 38, baseType: !48, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !178, file: !179, line: 39, baseType: !48, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !178, file: !179, line: 40, baseType: !48, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !178, file: !179, line: 55, baseType: !114, size: 16, offset: 112)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !178, file: !179, line: 56, baseType: !164, size: 16, offset: 128)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !178, file: !179, line: 57, baseType: !114, size: 16, offset: 144)
!198 = !DILocalVariable(name: "nh", scope: !95, file: !3, line: 110, type: !199)
!199 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !200, line: 33, size: 64, elements: !201)
!200 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet02-rewriting", checksumkind: CSK_MD5, checksum: "172efdd203783aed49c0ce78645261a8")
!201 = !{!202}
!202 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !199, file: !200, line: 34, baseType: !46, size: 64)
!203 = !DILocalVariable(name: "action", scope: !95, file: !3, line: 111, type: !51)
!204 = !DILocalVariable(name: "eth_type", scope: !95, file: !3, line: 112, type: !51)
!205 = !DILocalVariable(name: "ip_type", scope: !95, file: !3, line: 112, type: !51)
!206 = !DILabel(scope: !95, name: "out", file: !3, line: 143)
!207 = !DILocation(line: 0, scope: !95)
!208 = !DILocation(line: 103, column: 38, scope: !95)
!209 = !{!210, !211, i64 4}
!210 = !{!"xdp_md", !211, i64 0, !211, i64 4, !211, i64 8, !211, i64 12, !211, i64 16}
!211 = !{!"int", !212, i64 0}
!212 = !{!"omnipotent char", !213, i64 0}
!213 = !{!"Simple C/C++ TBAA"}
!214 = !DILocation(line: 103, column: 27, scope: !95)
!215 = !DILocation(line: 103, column: 19, scope: !95)
!216 = !DILocation(line: 104, column: 34, scope: !95)
!217 = !{!210, !211, i64 0}
!218 = !DILocation(line: 104, column: 23, scope: !95)
!219 = !DILocation(line: 104, column: 15, scope: !95)
!220 = !DILocalVariable(name: "nh", arg: 1, scope: !221, file: !200, line: 124, type: !224)
!221 = distinct !DISubprogram(name: "parse_ethhdr", scope: !200, file: !200, line: 124, type: !222, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !226)
!222 = !DISubroutineType(types: !223)
!223 = !{!51, !224, !46, !225}
!224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !199, size: 64)
!225 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!226 = !{!220, !227, !228}
!227 = !DILocalVariable(name: "data_end", arg: 2, scope: !221, file: !200, line: 125, type: !46)
!228 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !221, file: !200, line: 126, type: !225)
!229 = !DILocation(line: 0, scope: !221, inlinedAt: !230)
!230 = distinct !DILocation(line: 114, column: 13, scope: !95)
!231 = !DILocalVariable(name: "nh", arg: 1, scope: !232, file: !200, line: 79, type: !224)
!232 = distinct !DISubprogram(name: "parse_ethhdr_vlan", scope: !200, file: !200, line: 79, type: !233, scopeLine: 83, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !242)
!233 = !DISubroutineType(types: !234)
!234 = !{!51, !224, !46, !225, !235}
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !236, size: 64)
!236 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "collect_vlans", file: !200, line: 64, size: 32, elements: !237)
!237 = !{!238}
!238 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !236, file: !200, line: 65, baseType: !239, size: 32)
!239 = !DICompositeType(tag: DW_TAG_array_type, baseType: !48, size: 32, elements: !240)
!240 = !{!241}
!241 = !DISubrange(count: 2)
!242 = !{!231, !243, !244, !245, !246, !247, !248, !254, !255}
!243 = !DILocalVariable(name: "data_end", arg: 2, scope: !232, file: !200, line: 80, type: !46)
!244 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !232, file: !200, line: 81, type: !225)
!245 = !DILocalVariable(name: "vlans", arg: 4, scope: !232, file: !200, line: 82, type: !235)
!246 = !DILocalVariable(name: "eth", scope: !232, file: !200, line: 84, type: !103)
!247 = !DILocalVariable(name: "hdrsize", scope: !232, file: !200, line: 85, type: !51)
!248 = !DILocalVariable(name: "vlh", scope: !232, file: !200, line: 86, type: !249)
!249 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !250, size: 64)
!250 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !200, line: 42, size: 32, elements: !251)
!251 = !{!252, !253}
!252 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !250, file: !200, line: 43, baseType: !114, size: 16)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !250, file: !200, line: 44, baseType: !114, size: 16, offset: 16)
!254 = !DILocalVariable(name: "h_proto", scope: !232, file: !200, line: 87, type: !48)
!255 = !DILocalVariable(name: "i", scope: !232, file: !200, line: 88, type: !51)
!256 = !DILocation(line: 0, scope: !232, inlinedAt: !257)
!257 = distinct !DILocation(line: 129, column: 9, scope: !221, inlinedAt: !230)
!258 = !DILocation(line: 93, column: 14, scope: !259, inlinedAt: !257)
!259 = distinct !DILexicalBlock(scope: !232, file: !200, line: 93, column: 6)
!260 = !DILocation(line: 93, column: 24, scope: !259, inlinedAt: !257)
!261 = !DILocation(line: 93, column: 6, scope: !232, inlinedAt: !257)
!262 = !DILocation(line: 99, column: 17, scope: !232, inlinedAt: !257)
!263 = !{!264, !264, i64 0}
!264 = !{!"short", !212, i64 0}
!265 = !DILocalVariable(name: "h_proto", arg: 1, scope: !266, file: !200, line: 68, type: !48)
!266 = distinct !DISubprogram(name: "proto_is_vlan", scope: !200, file: !200, line: 68, type: !267, scopeLine: 69, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !269)
!267 = !DISubroutineType(types: !268)
!268 = !{!51, !48}
!269 = !{!265}
!270 = !DILocation(line: 0, scope: !266, inlinedAt: !271)
!271 = distinct !DILocation(line: 106, column: 8, scope: !272, inlinedAt: !257)
!272 = distinct !DILexicalBlock(scope: !273, file: !200, line: 106, column: 7)
!273 = distinct !DILexicalBlock(scope: !274, file: !200, line: 105, column: 39)
!274 = distinct !DILexicalBlock(scope: !275, file: !200, line: 105, column: 2)
!275 = distinct !DILexicalBlock(scope: !232, file: !200, line: 105, column: 2)
!276 = !DILocation(line: 70, column: 20, scope: !266, inlinedAt: !271)
!277 = !DILocation(line: 70, column: 46, scope: !266, inlinedAt: !271)
!278 = !DILocation(line: 106, column: 8, scope: !272, inlinedAt: !257)
!279 = !DILocation(line: 106, column: 7, scope: !273, inlinedAt: !257)
!280 = !DILocation(line: 112, column: 18, scope: !273, inlinedAt: !257)
!281 = !DILocation(line: 118, column: 12, scope: !282)
!282 = distinct !DILexicalBlock(scope: !95, file: !3, line: 115, column: 6)
!283 = !DILocalVariable(name: "nh", arg: 1, scope: !284, file: !200, line: 132, type: !224)
!284 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !200, file: !200, line: 132, type: !285, scopeLine: 135, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !288)
!285 = !DISubroutineType(types: !286)
!286 = !{!51, !224, !46, !287}
!287 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!288 = !{!283, !289, !290, !291}
!289 = !DILocalVariable(name: "data_end", arg: 2, scope: !284, file: !200, line: 133, type: !46)
!290 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !284, file: !200, line: 134, type: !287)
!291 = !DILocalVariable(name: "ip6h", scope: !284, file: !200, line: 136, type: !117)
!292 = !DILocation(line: 0, scope: !284, inlinedAt: !293)
!293 = distinct !DILocation(line: 119, column: 13, scope: !294)
!294 = distinct !DILexicalBlock(scope: !295, file: !3, line: 118, column: 47)
!295 = distinct !DILexicalBlock(scope: !282, file: !3, line: 118, column: 12)
!296 = !DILocation(line: 142, column: 11, scope: !297, inlinedAt: !293)
!297 = distinct !DILexicalBlock(scope: !284, file: !200, line: 142, column: 6)
!298 = !DILocation(line: 142, column: 17, scope: !297, inlinedAt: !293)
!299 = !DILocation(line: 142, column: 15, scope: !297, inlinedAt: !293)
!300 = !DILocation(line: 142, column: 6, scope: !284, inlinedAt: !293)
!301 = !DILocalVariable(name: "nh", arg: 1, scope: !302, file: !200, line: 151, type: !224)
!302 = distinct !DISubprogram(name: "parse_iphdr", scope: !200, file: !200, line: 151, type: !303, scopeLine: 154, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !306)
!303 = !DISubroutineType(types: !304)
!304 = !{!51, !224, !46, !305}
!305 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !151, size: 64)
!306 = !{!301, !307, !308, !309, !310}
!307 = !DILocalVariable(name: "data_end", arg: 2, scope: !302, file: !200, line: 152, type: !46)
!308 = !DILocalVariable(name: "iphdr", arg: 3, scope: !302, file: !200, line: 153, type: !305)
!309 = !DILocalVariable(name: "iph", scope: !302, file: !200, line: 155, type: !151)
!310 = !DILocalVariable(name: "hdrsize", scope: !302, file: !200, line: 156, type: !51)
!311 = !DILocation(line: 0, scope: !302, inlinedAt: !312)
!312 = distinct !DILocation(line: 121, column: 13, scope: !313)
!313 = distinct !DILexicalBlock(scope: !314, file: !3, line: 120, column: 45)
!314 = distinct !DILexicalBlock(scope: !295, file: !3, line: 120, column: 12)
!315 = !DILocation(line: 158, column: 10, scope: !316, inlinedAt: !312)
!316 = distinct !DILexicalBlock(scope: !302, file: !200, line: 158, column: 6)
!317 = !DILocation(line: 158, column: 14, scope: !316, inlinedAt: !312)
!318 = !DILocation(line: 158, column: 6, scope: !302, inlinedAt: !312)
!319 = !DILocation(line: 161, column: 17, scope: !302, inlinedAt: !312)
!320 = !DILocation(line: 161, column: 21, scope: !302, inlinedAt: !312)
!321 = !DILocation(line: 163, column: 13, scope: !322, inlinedAt: !312)
!322 = distinct !DILexicalBlock(scope: !302, file: !200, line: 163, column: 5)
!323 = !DILocation(line: 163, column: 5, scope: !302, inlinedAt: !312)
!324 = !DILocation(line: 167, column: 14, scope: !325, inlinedAt: !312)
!325 = distinct !DILexicalBlock(scope: !302, file: !200, line: 167, column: 6)
!326 = !DILocation(line: 167, column: 24, scope: !325, inlinedAt: !312)
!327 = !DILocation(line: 167, column: 6, scope: !302, inlinedAt: !312)
!328 = !DILocation(line: 110, column: 25, scope: !95)
!329 = !DILocation(line: 0, scope: !295)
!330 = !{!212, !212, i64 0}
!331 = !DILocation(line: 126, column: 7, scope: !95)
!332 = !DILocalVariable(name: "nh", arg: 1, scope: !333, file: !200, line: 224, type: !224)
!333 = distinct !DISubprogram(name: "parse_udphdr", scope: !200, file: !200, line: 224, type: !334, scopeLine: 227, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !337)
!334 = !DISubroutineType(types: !335)
!335 = !{!51, !224, !46, !336}
!336 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !168, size: 64)
!337 = !{!332, !338, !339, !340, !341}
!338 = !DILocalVariable(name: "data_end", arg: 2, scope: !333, file: !200, line: 225, type: !46)
!339 = !DILocalVariable(name: "udphdr", arg: 3, scope: !333, file: !200, line: 226, type: !336)
!340 = !DILocalVariable(name: "len", scope: !333, file: !200, line: 228, type: !51)
!341 = !DILocalVariable(name: "h", scope: !333, file: !200, line: 229, type: !168)
!342 = !DILocation(line: 0, scope: !333, inlinedAt: !343)
!343 = distinct !DILocation(line: 127, column: 7, scope: !344)
!344 = distinct !DILexicalBlock(scope: !345, file: !3, line: 127, column: 7)
!345 = distinct !DILexicalBlock(scope: !346, file: !3, line: 126, column: 31)
!346 = distinct !DILexicalBlock(scope: !95, file: !3, line: 126, column: 7)
!347 = !DILocation(line: 231, column: 8, scope: !348, inlinedAt: !343)
!348 = distinct !DILexicalBlock(scope: !333, file: !200, line: 231, column: 6)
!349 = !DILocation(line: 231, column: 14, scope: !348, inlinedAt: !343)
!350 = !DILocation(line: 231, column: 12, scope: !348, inlinedAt: !343)
!351 = !DILocation(line: 231, column: 6, scope: !333, inlinedAt: !343)
!352 = !DILocation(line: 237, column: 8, scope: !333, inlinedAt: !343)
!353 = !{!354, !264, i64 4}
!354 = !{!"udphdr", !264, i64 0, !264, i64 2, !264, i64 4, !264, i64 6}
!355 = !DILocation(line: 238, column: 10, scope: !356, inlinedAt: !343)
!356 = distinct !DILexicalBlock(scope: !333, file: !200, line: 238, column: 6)
!357 = !DILocation(line: 238, column: 6, scope: !333, inlinedAt: !343)
!358 = !DILocalVariable(name: "nh", arg: 1, scope: !359, file: !200, line: 247, type: !224)
!359 = distinct !DISubprogram(name: "parse_tcphdr", scope: !200, file: !200, line: 247, type: !360, scopeLine: 250, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !363)
!360 = !DISubroutineType(types: !361)
!361 = !{!51, !224, !46, !362}
!362 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!363 = !{!358, !364, !365, !366, !367}
!364 = !DILocalVariable(name: "data_end", arg: 2, scope: !359, file: !200, line: 248, type: !46)
!365 = !DILocalVariable(name: "tcphdr", arg: 3, scope: !359, file: !200, line: 249, type: !362)
!366 = !DILocalVariable(name: "len", scope: !359, file: !200, line: 251, type: !51)
!367 = !DILocalVariable(name: "h", scope: !359, file: !200, line: 252, type: !177)
!368 = !DILocation(line: 0, scope: !359, inlinedAt: !369)
!369 = distinct !DILocation(line: 133, column: 7, scope: !370)
!370 = distinct !DILexicalBlock(scope: !371, file: !3, line: 133, column: 7)
!371 = distinct !DILexicalBlock(scope: !372, file: !3, line: 132, column: 36)
!372 = distinct !DILexicalBlock(scope: !346, file: !3, line: 132, column: 12)
!373 = !DILocation(line: 254, column: 8, scope: !374, inlinedAt: !369)
!374 = distinct !DILexicalBlock(scope: !359, file: !200, line: 254, column: 6)
!375 = !DILocation(line: 254, column: 12, scope: !374, inlinedAt: !369)
!376 = !DILocation(line: 254, column: 6, scope: !359, inlinedAt: !369)
!377 = !DILocation(line: 257, column: 11, scope: !359, inlinedAt: !369)
!378 = !DILocation(line: 257, column: 16, scope: !359, inlinedAt: !369)
!379 = !DILocation(line: 259, column: 9, scope: !380, inlinedAt: !369)
!380 = distinct !DILexicalBlock(scope: !359, file: !200, line: 259, column: 5)
!381 = !DILocation(line: 259, column: 5, scope: !359, inlinedAt: !369)
!382 = !DILocation(line: 263, column: 14, scope: !383, inlinedAt: !369)
!383 = distinct !DILexicalBlock(scope: !359, file: !200, line: 263, column: 6)
!384 = !DILocation(line: 263, column: 20, scope: !383, inlinedAt: !369)
!385 = !DILocation(line: 263, column: 6, scope: !359, inlinedAt: !369)
!386 = !DILocation(line: 0, scope: !346)
!387 = !DILocation(line: 0, scope: !388, inlinedAt: !403)
!388 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !81, file: !81, line: 24, type: !389, scopeLine: 25, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !391)
!389 = !DISubroutineType(types: !390)
!390 = !{!76, !72, !76}
!391 = !{!392, !393, !394}
!392 = !DILocalVariable(name: "ctx", arg: 1, scope: !388, file: !81, line: 24, type: !72)
!393 = !DILocalVariable(name: "action", arg: 2, scope: !388, file: !81, line: 24, type: !76)
!394 = !DILocalVariable(name: "rec", scope: !388, file: !81, line: 30, type: !395)
!395 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !396, size: 64)
!396 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !397, line: 10, size: 128, elements: !398)
!397 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet02-rewriting", checksumkind: CSK_MD5, checksum: "96c2435685fa7da2d24f219444d8659d")
!398 = !{!399, !402}
!399 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !396, file: !397, line: 11, baseType: !400, size: 64)
!400 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !49, line: 31, baseType: !401)
!401 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!402 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !396, file: !397, line: 12, baseType: !400, size: 64, offset: 64)
!403 = distinct !DILocation(line: 144, column: 9, scope: !95)
!404 = !DILocation(line: 143, column: 1, scope: !95)
!405 = !{!211, !211, i64 0}
!406 = !DILocation(line: 30, column: 24, scope: !388, inlinedAt: !403)
!407 = !DILocation(line: 31, column: 7, scope: !408, inlinedAt: !403)
!408 = distinct !DILexicalBlock(scope: !388, file: !81, line: 31, column: 6)
!409 = !DILocation(line: 31, column: 6, scope: !388, inlinedAt: !403)
!410 = !DILocation(line: 38, column: 7, scope: !388, inlinedAt: !403)
!411 = !DILocation(line: 38, column: 17, scope: !388, inlinedAt: !403)
!412 = !{!413, !414, i64 0}
!413 = !{!"datarec", !414, i64 0, !414, i64 8}
!414 = !{!"long long", !212, i64 0}
!415 = !DILocation(line: 39, column: 25, scope: !388, inlinedAt: !403)
!416 = !DILocation(line: 39, column: 41, scope: !388, inlinedAt: !403)
!417 = !DILocation(line: 39, column: 34, scope: !388, inlinedAt: !403)
!418 = !DILocation(line: 39, column: 19, scope: !388, inlinedAt: !403)
!419 = !DILocation(line: 39, column: 7, scope: !388, inlinedAt: !403)
!420 = !DILocation(line: 39, column: 16, scope: !388, inlinedAt: !403)
!421 = !{!413, !414, i64 8}
!422 = !DILocation(line: 41, column: 9, scope: !388, inlinedAt: !403)
!423 = !DILocation(line: 41, column: 2, scope: !388, inlinedAt: !403)
!424 = !DILocation(line: 42, column: 1, scope: !388, inlinedAt: !403)
!425 = !DILocation(line: 144, column: 2, scope: !95)
!426 = distinct !DISubprogram(name: "xdp_vlan_swap_func", scope: !3, file: !3, line: 151, type: !96, scopeLine: 152, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !427)
!427 = !{!428, !429, !430, !431, !432, !433}
!428 = !DILocalVariable(name: "ctx", arg: 1, scope: !426, file: !3, line: 151, type: !72)
!429 = !DILocalVariable(name: "data_end", scope: !426, file: !3, line: 153, type: !46)
!430 = !DILocalVariable(name: "data", scope: !426, file: !3, line: 154, type: !46)
!431 = !DILocalVariable(name: "nh", scope: !426, file: !3, line: 157, type: !199)
!432 = !DILocalVariable(name: "nh_type", scope: !426, file: !3, line: 158, type: !51)
!433 = !DILocalVariable(name: "eth", scope: !426, file: !3, line: 161, type: !103)
!434 = !DILocation(line: 0, scope: !426)
!435 = !DILocation(line: 153, column: 38, scope: !426)
!436 = !DILocation(line: 153, column: 27, scope: !426)
!437 = !DILocation(line: 153, column: 19, scope: !426)
!438 = !DILocation(line: 154, column: 34, scope: !426)
!439 = !DILocation(line: 154, column: 23, scope: !426)
!440 = !DILocation(line: 154, column: 15, scope: !426)
!441 = !DILocation(line: 0, scope: !221, inlinedAt: !442)
!442 = distinct !DILocation(line: 162, column: 12, scope: !426)
!443 = !DILocation(line: 0, scope: !232, inlinedAt: !444)
!444 = distinct !DILocation(line: 129, column: 9, scope: !221, inlinedAt: !442)
!445 = !DILocation(line: 93, column: 14, scope: !259, inlinedAt: !444)
!446 = !DILocation(line: 93, column: 24, scope: !259, inlinedAt: !444)
!447 = !DILocation(line: 93, column: 6, scope: !232, inlinedAt: !444)
!448 = !DILocation(line: 97, column: 10, scope: !232, inlinedAt: !444)
!449 = !DILocation(line: 0, scope: !266, inlinedAt: !450)
!450 = distinct !DILocation(line: 106, column: 8, scope: !272, inlinedAt: !444)
!451 = !DILocation(line: 167, column: 25, scope: !452)
!452 = distinct !DILexicalBlock(scope: !426, file: !3, line: 167, column: 6)
!453 = !{!454, !264, i64 12}
!454 = !{!"ethhdr", !212, i64 0, !212, i64 6, !264, i64 12}
!455 = !DILocation(line: 0, scope: !266, inlinedAt: !456)
!456 = distinct !DILocation(line: 167, column: 6, scope: !452)
!457 = !DILocation(line: 70, column: 20, scope: !266, inlinedAt: !456)
!458 = !DILocation(line: 70, column: 46, scope: !266, inlinedAt: !456)
!459 = !DILocation(line: 167, column: 6, scope: !426)
!460 = !DILocalVariable(name: "ctx", arg: 1, scope: !461, file: !3, line: 17, type: !72)
!461 = distinct !DISubprogram(name: "vlan_tag_pop", scope: !3, file: !3, line: 17, type: !462, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !464)
!462 = !DISubroutineType(types: !463)
!463 = !{!51, !72, !103}
!464 = !{!460, !465, !466, !467, !468, !469, !470}
!465 = !DILocalVariable(name: "eth", arg: 2, scope: !461, file: !3, line: 17, type: !103)
!466 = !DILocalVariable(name: "data_end", scope: !461, file: !3, line: 20, type: !46)
!467 = !DILocalVariable(name: "eth_cpy", scope: !461, file: !3, line: 21, type: !104)
!468 = !DILocalVariable(name: "vlh", scope: !461, file: !3, line: 22, type: !249)
!469 = !DILocalVariable(name: "h_proto", scope: !461, file: !3, line: 23, type: !114)
!470 = !DILocalVariable(name: "vlid", scope: !461, file: !3, line: 25, type: !51)
!471 = !DILocation(line: 0, scope: !461, inlinedAt: !472)
!472 = distinct !DILocation(line: 168, column: 3, scope: !452)
!473 = !DILocation(line: 21, column: 2, scope: !461, inlinedAt: !472)
!474 = !DILocation(line: 21, column: 16, scope: !461, inlinedAt: !472)
!475 = !DILocation(line: 0, scope: !266, inlinedAt: !476)
!476 = distinct !DILocation(line: 29, column: 6, scope: !477, inlinedAt: !472)
!477 = distinct !DILexicalBlock(scope: !461, file: !3, line: 29, column: 6)
!478 = !DILocation(line: 29, column: 6, scope: !461, inlinedAt: !472)
!479 = !DILocation(line: 35, column: 19, scope: !480, inlinedAt: !472)
!480 = distinct !DILexicalBlock(scope: !481, file: !3, line: 32, column: 27)
!481 = distinct !DILexicalBlock(scope: !482, file: !3, line: 32, column: 7)
!482 = distinct !DILexicalBlock(scope: !477, file: !3, line: 29, column: 35)
!483 = !{!484, !264, i64 2}
!484 = !{!"vlan_hdr", !264, i64 0, !264, i64 2}
!485 = !DILocation(line: 37, column: 4, scope: !480, inlinedAt: !472)
!486 = !DILocation(line: 39, column: 7, scope: !487, inlinedAt: !472)
!487 = distinct !DILexicalBlock(scope: !480, file: !3, line: 39, column: 7)
!488 = !DILocation(line: 39, column: 7, scope: !480, inlinedAt: !472)
!489 = !DILocation(line: 44, column: 29, scope: !480, inlinedAt: !472)
!490 = !DILocation(line: 44, column: 18, scope: !480, inlinedAt: !472)
!491 = !DILocation(line: 44, column: 10, scope: !480, inlinedAt: !472)
!492 = !DILocation(line: 45, column: 34, scope: !480, inlinedAt: !472)
!493 = !DILocation(line: 45, column: 23, scope: !480, inlinedAt: !472)
!494 = !DILocation(line: 46, column: 12, scope: !495, inlinedAt: !472)
!495 = distinct !DILexicalBlock(scope: !480, file: !3, line: 46, column: 8)
!496 = !DILocation(line: 46, column: 18, scope: !495, inlinedAt: !472)
!497 = !DILocation(line: 46, column: 16, scope: !495, inlinedAt: !472)
!498 = !DILocation(line: 46, column: 8, scope: !480, inlinedAt: !472)
!499 = !DILocation(line: 49, column: 4, scope: !480, inlinedAt: !472)
!500 = !DILocation(line: 50, column: 9, scope: !480, inlinedAt: !472)
!501 = !DILocation(line: 50, column: 17, scope: !480, inlinedAt: !472)
!502 = !DILocation(line: 52, column: 3, scope: !480, inlinedAt: !472)
!503 = !DILocation(line: 55, column: 1, scope: !461, inlinedAt: !472)
!504 = !DILocation(line: 168, column: 3, scope: !452)
!505 = !DILocalVariable(name: "ctx", arg: 1, scope: !506, file: !3, line: 60, type: !72)
!506 = distinct !DISubprogram(name: "vlan_tag_push", scope: !3, file: !3, line: 60, type: !507, scopeLine: 62, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !509)
!507 = !DISubroutineType(types: !508)
!508 = !{!51, !72, !103, !51}
!509 = !{!505, !510, !511, !512, !513, !514}
!510 = !DILocalVariable(name: "eth", arg: 2, scope: !506, file: !3, line: 61, type: !103)
!511 = !DILocalVariable(name: "vlid", arg: 3, scope: !506, file: !3, line: 61, type: !51)
!512 = !DILocalVariable(name: "data_end", scope: !506, file: !3, line: 63, type: !46)
!513 = !DILocalVariable(name: "eth_cpy", scope: !506, file: !3, line: 64, type: !104)
!514 = !DILocalVariable(name: "vlh", scope: !506, file: !3, line: 65, type: !249)
!515 = !DILocation(line: 0, scope: !506, inlinedAt: !516)
!516 = distinct !DILocation(line: 170, column: 3, scope: !452)
!517 = !DILocation(line: 64, column: 2, scope: !506, inlinedAt: !516)
!518 = !DILocation(line: 64, column: 16, scope: !506, inlinedAt: !516)
!519 = !DILocation(line: 68, column: 2, scope: !506, inlinedAt: !516)
!520 = !DILocation(line: 70, column: 6, scope: !521, inlinedAt: !516)
!521 = distinct !DILexicalBlock(scope: !506, file: !3, line: 70, column: 6)
!522 = !DILocation(line: 70, column: 6, scope: !506, inlinedAt: !516)
!523 = !DILocation(line: 74, column: 32, scope: !506, inlinedAt: !516)
!524 = !DILocation(line: 74, column: 21, scope: !506, inlinedAt: !516)
!525 = !DILocation(line: 75, column: 27, scope: !506, inlinedAt: !516)
!526 = !DILocation(line: 75, column: 16, scope: !506, inlinedAt: !516)
!527 = !DILocation(line: 75, column: 8, scope: !506, inlinedAt: !516)
!528 = !DILocation(line: 77, column: 10, scope: !529, inlinedAt: !516)
!529 = distinct !DILexicalBlock(scope: !506, file: !3, line: 77, column: 6)
!530 = !DILocation(line: 77, column: 16, scope: !529, inlinedAt: !516)
!531 = !DILocation(line: 77, column: 14, scope: !529, inlinedAt: !516)
!532 = !DILocation(line: 77, column: 6, scope: !506, inlinedAt: !516)
!533 = !DILocation(line: 81, column: 2, scope: !506, inlinedAt: !516)
!534 = !DILocation(line: 86, column: 10, scope: !535, inlinedAt: !516)
!535 = distinct !DILexicalBlock(scope: !506, file: !3, line: 86, column: 6)
!536 = !DILocation(line: 86, column: 16, scope: !535, inlinedAt: !516)
!537 = !DILocation(line: 86, column: 14, scope: !535, inlinedAt: !516)
!538 = !DILocation(line: 86, column: 6, scope: !506, inlinedAt: !516)
!539 = !DILocation(line: 90, column: 7, scope: !506, inlinedAt: !516)
!540 = !DILocation(line: 90, column: 18, scope: !506, inlinedAt: !516)
!541 = !{!484, !264, i64 0}
!542 = !DILocation(line: 92, column: 40, scope: !506, inlinedAt: !516)
!543 = !DILocation(line: 92, column: 7, scope: !506, inlinedAt: !516)
!544 = !DILocation(line: 92, column: 33, scope: !506, inlinedAt: !516)
!545 = !DILocation(line: 94, column: 15, scope: !506, inlinedAt: !516)
!546 = !DILocation(line: 96, column: 2, scope: !506, inlinedAt: !516)
!547 = !DILocation(line: 97, column: 1, scope: !506, inlinedAt: !516)
!548 = !DILocation(line: 173, column: 1, scope: !426)
!549 = distinct !DISubprogram(name: "xdp_parser_func", scope: !3, file: !3, line: 179, type: !96, scopeLine: 180, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !550)
!550 = !{!551, !552, !553, !554, !555, !556, !557, !558, !561, !603, !606, !629}
!551 = !DILocalVariable(name: "ctx", arg: 1, scope: !549, file: !3, line: 179, type: !72)
!552 = !DILocalVariable(name: "data_end", scope: !549, file: !3, line: 181, type: !46)
!553 = !DILocalVariable(name: "data", scope: !549, file: !3, line: 182, type: !46)
!554 = !DILocalVariable(name: "action", scope: !549, file: !3, line: 188, type: !76)
!555 = !DILocalVariable(name: "nh", scope: !549, file: !3, line: 191, type: !199)
!556 = !DILocalVariable(name: "nh_type", scope: !549, file: !3, line: 192, type: !51)
!557 = !DILocalVariable(name: "eth", scope: !549, file: !3, line: 195, type: !103)
!558 = !DILocalVariable(name: "ip6h", scope: !559, file: !3, line: 204, type: !117)
!559 = distinct !DILexicalBlock(scope: !560, file: !3, line: 203, column: 40)
!560 = distinct !DILexicalBlock(scope: !549, file: !3, line: 203, column: 6)
!561 = !DILocalVariable(name: "icmp6h", scope: !559, file: !3, line: 205, type: !562)
!562 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !563, size: 64)
!563 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmp6hdr", file: !564, line: 8, size: 64, elements: !565)
!564 = !DIFile(filename: "/usr/include/linux/icmpv6.h", directory: "", checksumkind: CSK_MD5, checksum: "0310ca5584e6f44f6eea6cf040ee84b9")
!565 = !{!566, !567, !568, !569}
!566 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_type", scope: !563, file: !564, line: 10, baseType: !122, size: 8)
!567 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_code", scope: !563, file: !564, line: 11, baseType: !122, size: 8, offset: 8)
!568 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_cksum", scope: !563, file: !564, line: 12, baseType: !164, size: 16, offset: 16)
!569 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_dataun", scope: !563, file: !564, line: 63, baseType: !570, size: 32, offset: 32)
!570 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !563, file: !564, line: 15, size: 32, elements: !571)
!571 = !{!572, !576, !578, !580, !585, !593}
!572 = !DIDerivedType(tag: DW_TAG_member, name: "un_data32", scope: !570, file: !564, line: 16, baseType: !573, size: 32)
!573 = !DICompositeType(tag: DW_TAG_array_type, baseType: !148, size: 32, elements: !574)
!574 = !{!575}
!575 = !DISubrange(count: 1)
!576 = !DIDerivedType(tag: DW_TAG_member, name: "un_data16", scope: !570, file: !564, line: 17, baseType: !577, size: 32)
!577 = !DICompositeType(tag: DW_TAG_array_type, baseType: !114, size: 32, elements: !240)
!578 = !DIDerivedType(tag: DW_TAG_member, name: "un_data8", scope: !570, file: !564, line: 18, baseType: !579, size: 32)
!579 = !DICompositeType(tag: DW_TAG_array_type, baseType: !122, size: 32, elements: !57)
!580 = !DIDerivedType(tag: DW_TAG_member, name: "u_echo", scope: !570, file: !564, line: 23, baseType: !581, size: 32)
!581 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_echo", file: !564, line: 20, size: 32, elements: !582)
!582 = !{!583, !584}
!583 = !DIDerivedType(tag: DW_TAG_member, name: "identifier", scope: !581, file: !564, line: 21, baseType: !114, size: 16)
!584 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !581, file: !564, line: 22, baseType: !114, size: 16, offset: 16)
!585 = !DIDerivedType(tag: DW_TAG_member, name: "u_nd_advt", scope: !570, file: !564, line: 40, baseType: !586, size: 32)
!586 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_nd_advt", file: !564, line: 25, size: 32, elements: !587)
!587 = !{!588, !589, !590, !591, !592}
!588 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !586, file: !564, line: 27, baseType: !76, size: 5, flags: DIFlagBitField, extraData: i64 0)
!589 = !DIDerivedType(tag: DW_TAG_member, name: "override", scope: !586, file: !564, line: 28, baseType: !76, size: 1, offset: 5, flags: DIFlagBitField, extraData: i64 0)
!590 = !DIDerivedType(tag: DW_TAG_member, name: "solicited", scope: !586, file: !564, line: 29, baseType: !76, size: 1, offset: 6, flags: DIFlagBitField, extraData: i64 0)
!591 = !DIDerivedType(tag: DW_TAG_member, name: "router", scope: !586, file: !564, line: 30, baseType: !76, size: 1, offset: 7, flags: DIFlagBitField, extraData: i64 0)
!592 = !DIDerivedType(tag: DW_TAG_member, name: "reserved2", scope: !586, file: !564, line: 31, baseType: !76, size: 24, offset: 8, flags: DIFlagBitField, extraData: i64 0)
!593 = !DIDerivedType(tag: DW_TAG_member, name: "u_nd_ra", scope: !570, file: !564, line: 61, baseType: !594, size: 32)
!594 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_nd_ra", file: !564, line: 42, size: 32, elements: !595)
!595 = !{!596, !597, !598, !599, !600, !601, !602}
!596 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !594, file: !564, line: 43, baseType: !122, size: 8)
!597 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !594, file: !564, line: 45, baseType: !122, size: 3, offset: 8, flags: DIFlagBitField, extraData: i64 8)
!598 = !DIDerivedType(tag: DW_TAG_member, name: "router_pref", scope: !594, file: !564, line: 46, baseType: !122, size: 2, offset: 11, flags: DIFlagBitField, extraData: i64 8)
!599 = !DIDerivedType(tag: DW_TAG_member, name: "home_agent", scope: !594, file: !564, line: 47, baseType: !122, size: 1, offset: 13, flags: DIFlagBitField, extraData: i64 8)
!600 = !DIDerivedType(tag: DW_TAG_member, name: "other", scope: !594, file: !564, line: 48, baseType: !122, size: 1, offset: 14, flags: DIFlagBitField, extraData: i64 8)
!601 = !DIDerivedType(tag: DW_TAG_member, name: "managed", scope: !594, file: !564, line: 49, baseType: !122, size: 1, offset: 15, flags: DIFlagBitField, extraData: i64 8)
!602 = !DIDerivedType(tag: DW_TAG_member, name: "rt_lifetime", scope: !594, file: !564, line: 60, baseType: !114, size: 16, offset: 16)
!603 = !DILocalVariable(name: "iph", scope: !604, file: !3, line: 219, type: !151)
!604 = distinct !DILexicalBlock(scope: !605, file: !3, line: 218, column: 45)
!605 = distinct !DILexicalBlock(scope: !560, file: !3, line: 218, column: 13)
!606 = !DILocalVariable(name: "icmph", scope: !604, file: !3, line: 220, type: !607)
!607 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !608, size: 64)
!608 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr", file: !609, line: 89, size: 64, elements: !610)
!609 = !DIFile(filename: "/usr/include/linux/icmp.h", directory: "", checksumkind: CSK_MD5, checksum: "a505632898dce546638b3344627d334b")
!610 = !{!611, !612, !613, !614}
!611 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !608, file: !609, line: 90, baseType: !122, size: 8)
!612 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !608, file: !609, line: 91, baseType: !122, size: 8, offset: 8)
!613 = !DIDerivedType(tag: DW_TAG_member, name: "checksum", scope: !608, file: !609, line: 92, baseType: !164, size: 16, offset: 16)
!614 = !DIDerivedType(tag: DW_TAG_member, name: "un", scope: !608, file: !609, line: 104, baseType: !615, size: 32, offset: 32)
!615 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !608, file: !609, line: 93, size: 32, elements: !616)
!616 = !{!617, !622, !623, !628}
!617 = !DIDerivedType(tag: DW_TAG_member, name: "echo", scope: !615, file: !609, line: 97, baseType: !618, size: 32)
!618 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !615, file: !609, line: 94, size: 32, elements: !619)
!619 = !{!620, !621}
!620 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !618, file: !609, line: 95, baseType: !114, size: 16)
!621 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !618, file: !609, line: 96, baseType: !114, size: 16, offset: 16)
!622 = !DIDerivedType(tag: DW_TAG_member, name: "gateway", scope: !615, file: !609, line: 98, baseType: !148, size: 32)
!623 = !DIDerivedType(tag: DW_TAG_member, name: "frag", scope: !615, file: !609, line: 102, baseType: !624, size: 32)
!624 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !615, file: !609, line: 99, size: 32, elements: !625)
!625 = !{!626, !627}
!626 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !624, file: !609, line: 100, baseType: !114, size: 16)
!627 = !DIDerivedType(tag: DW_TAG_member, name: "mtu", scope: !624, file: !609, line: 101, baseType: !114, size: 16, offset: 16)
!628 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !615, file: !609, line: 103, baseType: !579, size: 32)
!629 = !DILabel(scope: !549, name: "out", file: !3, line: 233)
!630 = !DILocation(line: 0, scope: !549)
!631 = !DILocation(line: 181, column: 38, scope: !549)
!632 = !DILocation(line: 181, column: 27, scope: !549)
!633 = !DILocation(line: 181, column: 19, scope: !549)
!634 = !DILocation(line: 182, column: 34, scope: !549)
!635 = !DILocation(line: 182, column: 23, scope: !549)
!636 = !DILocation(line: 182, column: 15, scope: !549)
!637 = !DILocation(line: 0, scope: !221, inlinedAt: !638)
!638 = distinct !DILocation(line: 201, column: 12, scope: !549)
!639 = !DILocation(line: 0, scope: !232, inlinedAt: !640)
!640 = distinct !DILocation(line: 129, column: 9, scope: !221, inlinedAt: !638)
!641 = !DILocation(line: 93, column: 14, scope: !259, inlinedAt: !640)
!642 = !DILocation(line: 93, column: 24, scope: !259, inlinedAt: !640)
!643 = !DILocation(line: 93, column: 6, scope: !232, inlinedAt: !640)
!644 = !DILocation(line: 99, column: 17, scope: !232, inlinedAt: !640)
!645 = !DILocation(line: 0, scope: !266, inlinedAt: !646)
!646 = distinct !DILocation(line: 106, column: 8, scope: !272, inlinedAt: !640)
!647 = !DILocation(line: 70, column: 20, scope: !266, inlinedAt: !646)
!648 = !DILocation(line: 70, column: 46, scope: !266, inlinedAt: !646)
!649 = !DILocation(line: 106, column: 8, scope: !272, inlinedAt: !640)
!650 = !DILocation(line: 106, column: 7, scope: !273, inlinedAt: !640)
!651 = !DILocation(line: 112, column: 18, scope: !273, inlinedAt: !640)
!652 = !DILocation(line: 203, column: 6, scope: !549)
!653 = !DILocation(line: 0, scope: !284, inlinedAt: !654)
!654 = distinct !DILocation(line: 207, column: 13, scope: !559)
!655 = !DILocation(line: 142, column: 11, scope: !297, inlinedAt: !654)
!656 = !DILocation(line: 142, column: 17, scope: !297, inlinedAt: !654)
!657 = !DILocation(line: 142, column: 15, scope: !297, inlinedAt: !654)
!658 = !DILocation(line: 142, column: 6, scope: !284, inlinedAt: !654)
!659 = !DILocation(line: 148, column: 15, scope: !284, inlinedAt: !654)
!660 = !{!661, !212, i64 6}
!661 = !{!"ipv6hdr", !212, i64 0, !212, i64 0, !212, i64 1, !264, i64 4, !212, i64 6, !212, i64 7, !662, i64 8, !662, i64 24}
!662 = !{!"in6_addr", !212, i64 0}
!663 = !DILocation(line: 208, column: 15, scope: !664)
!664 = distinct !DILexicalBlock(scope: !559, file: !3, line: 208, column: 7)
!665 = !DILocation(line: 208, column: 7, scope: !559)
!666 = !DILocalVariable(name: "nh", arg: 1, scope: !667, file: !200, line: 176, type: !224)
!667 = distinct !DISubprogram(name: "parse_icmp6hdr", scope: !200, file: !200, line: 176, type: !668, scopeLine: 179, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !671)
!668 = !DISubroutineType(types: !669)
!669 = !{!51, !224, !46, !670}
!670 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !562, size: 64)
!671 = !{!666, !672, !673, !674}
!672 = !DILocalVariable(name: "data_end", arg: 2, scope: !667, file: !200, line: 177, type: !46)
!673 = !DILocalVariable(name: "icmp6hdr", arg: 3, scope: !667, file: !200, line: 178, type: !670)
!674 = !DILocalVariable(name: "icmp6h", scope: !667, file: !200, line: 180, type: !562)
!675 = !DILocation(line: 0, scope: !667, inlinedAt: !676)
!676 = distinct !DILocation(line: 211, column: 13, scope: !559)
!677 = !DILocation(line: 188, column: 17, scope: !667, inlinedAt: !676)
!678 = !{!679, !212, i64 0}
!679 = !{!"icmp6hdr", !212, i64 0, !212, i64 1, !264, i64 2, !212, i64 4}
!680 = !DILocation(line: 212, column: 15, scope: !681)
!681 = distinct !DILexicalBlock(scope: !559, file: !3, line: 212, column: 7)
!682 = !DILocation(line: 212, column: 7, scope: !559)
!683 = !DILocation(line: 0, scope: !559)
!684 = !DILocation(line: 215, column: 7, scope: !685)
!685 = distinct !DILexicalBlock(scope: !559, file: !3, line: 215, column: 7)
!686 = !DILocation(line: 218, column: 2, scope: !560)
!687 = !DILocation(line: 0, scope: !604)
!688 = !DILocation(line: 0, scope: !302, inlinedAt: !689)
!689 = distinct !DILocation(line: 222, column: 13, scope: !604)
!690 = !DILocation(line: 158, column: 10, scope: !316, inlinedAt: !689)
!691 = !DILocation(line: 158, column: 14, scope: !316, inlinedAt: !689)
!692 = !DILocation(line: 158, column: 6, scope: !302, inlinedAt: !689)
!693 = !DILocation(line: 161, column: 17, scope: !302, inlinedAt: !689)
!694 = !DILocation(line: 161, column: 21, scope: !302, inlinedAt: !689)
!695 = !DILocation(line: 163, column: 13, scope: !322, inlinedAt: !689)
!696 = !DILocation(line: 163, column: 5, scope: !302, inlinedAt: !689)
!697 = !DILocation(line: 167, column: 14, scope: !325, inlinedAt: !689)
!698 = !DILocation(line: 167, column: 24, scope: !325, inlinedAt: !689)
!699 = !DILocation(line: 167, column: 6, scope: !302, inlinedAt: !689)
!700 = !DILocation(line: 173, column: 14, scope: !302, inlinedAt: !689)
!701 = !{!702, !212, i64 9}
!702 = !{!"iphdr", !212, i64 0, !212, i64 0, !212, i64 1, !264, i64 2, !264, i64 4, !264, i64 6, !212, i64 8, !212, i64 9, !264, i64 10, !211, i64 12, !211, i64 16}
!703 = !DILocation(line: 223, column: 15, scope: !704)
!704 = distinct !DILexicalBlock(scope: !604, file: !3, line: 223, column: 7)
!705 = !DILocation(line: 223, column: 7, scope: !604)
!706 = !DILocalVariable(name: "nh", arg: 1, scope: !707, file: !200, line: 191, type: !224)
!707 = distinct !DISubprogram(name: "parse_icmphdr", scope: !200, file: !200, line: 191, type: !708, scopeLine: 194, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !711)
!708 = !DISubroutineType(types: !709)
!709 = !{!51, !224, !46, !710}
!710 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !607, size: 64)
!711 = !{!706, !712, !713, !714}
!712 = !DILocalVariable(name: "data_end", arg: 2, scope: !707, file: !200, line: 192, type: !46)
!713 = !DILocalVariable(name: "icmphdr", arg: 3, scope: !707, file: !200, line: 193, type: !710)
!714 = !DILocalVariable(name: "icmph", scope: !707, file: !200, line: 195, type: !607)
!715 = !DILocation(line: 0, scope: !707, inlinedAt: !716)
!716 = distinct !DILocation(line: 226, column: 13, scope: !604)
!717 = !DILocation(line: 203, column: 16, scope: !707, inlinedAt: !716)
!718 = !{!719, !212, i64 0}
!719 = !{!"icmphdr", !212, i64 0, !212, i64 1, !264, i64 2, !212, i64 4}
!720 = !DILocation(line: 227, column: 15, scope: !721)
!721 = distinct !DILexicalBlock(scope: !604, file: !3, line: 227, column: 7)
!722 = !DILocation(line: 227, column: 7, scope: !604)
!723 = !DILocation(line: 230, column: 7, scope: !724)
!724 = distinct !DILexicalBlock(scope: !604, file: !3, line: 230, column: 7)
!725 = !DILocation(line: 232, column: 2, scope: !605)
!726 = !DILocation(line: 0, scope: !560)
!727 = !DILocation(line: 0, scope: !388, inlinedAt: !728)
!728 = distinct !DILocation(line: 234, column: 9, scope: !549)
!729 = !DILocation(line: 188, column: 8, scope: !549)
!730 = !DILocation(line: 233, column: 2, scope: !549)
!731 = !DILocation(line: 30, column: 24, scope: !388, inlinedAt: !728)
!732 = !DILocation(line: 31, column: 7, scope: !408, inlinedAt: !728)
!733 = !DILocation(line: 31, column: 6, scope: !388, inlinedAt: !728)
!734 = !DILocation(line: 38, column: 7, scope: !388, inlinedAt: !728)
!735 = !DILocation(line: 38, column: 17, scope: !388, inlinedAt: !728)
!736 = !DILocation(line: 39, column: 25, scope: !388, inlinedAt: !728)
!737 = !DILocation(line: 39, column: 41, scope: !388, inlinedAt: !728)
!738 = !DILocation(line: 39, column: 34, scope: !388, inlinedAt: !728)
!739 = !DILocation(line: 39, column: 19, scope: !388, inlinedAt: !728)
!740 = !DILocation(line: 39, column: 7, scope: !388, inlinedAt: !728)
!741 = !DILocation(line: 39, column: 16, scope: !388, inlinedAt: !728)
!742 = !DILocation(line: 41, column: 9, scope: !388, inlinedAt: !728)
!743 = !DILocation(line: 41, column: 2, scope: !388, inlinedAt: !728)
!744 = !DILocation(line: 42, column: 1, scope: !388, inlinedAt: !728)
!745 = !DILocation(line: 235, column: 1, scope: !549)

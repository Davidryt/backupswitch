; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.vlan_hdr = type { i16, i16 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.icmp6hdr = type { i8, i8, i16, %union.anon.0 }
%union.anon.0 = type { [1 x i32] }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !52
@llvm.compiler.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_parser_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_parser_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_packet_parser" !dbg !80 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !94, metadata !DIExpression()), !dbg !236
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !237
  %4 = load i32, i32* %3, align 4, !dbg !237, !tbaa !238
  %5 = zext i32 %4 to i64, !dbg !243
  %6 = inttoptr i64 %5 to i8*, !dbg !244
  call void @llvm.dbg.value(metadata i8* %6, metadata !95, metadata !DIExpression()), !dbg !236
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !245
  %8 = load i32, i32* %7, align 4, !dbg !245, !tbaa !246
  %9 = zext i32 %8 to i64, !dbg !247
  %10 = inttoptr i64 %9 to i8*, !dbg !248
  call void @llvm.dbg.value(metadata i8* %10, metadata !96, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.value(metadata i32 2, metadata !229, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.value(metadata i8* %10, metadata !230, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !97, metadata !DIExpression(DW_OP_deref)), !dbg !236
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !249, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata i8* %6, metadata !256, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !257, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata i8* %10, metadata !258, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata i32 14, metadata !259, metadata !DIExpression()) #5, !dbg !268
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !270
  %12 = icmp ugt i8* %11, %6, !dbg !272
  br i1 %12, label %88, label %13, !dbg !273

13:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !258, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata i8* %11, metadata !230, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.value(metadata i8* %11, metadata !261, metadata !DIExpression()) #5, !dbg !268
  %14 = getelementptr inbounds i8, i8* %10, i64 12, !dbg !274
  %15 = bitcast i8* %14 to i16*, !dbg !274
  call void @llvm.dbg.value(metadata i16 undef, metadata !260, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata i32 0, metadata !267, metadata !DIExpression()) #5, !dbg !268
  %16 = load i16, i16* %15, align 1, !dbg !268, !tbaa !275
  call void @llvm.dbg.value(metadata i16 %16, metadata !260, metadata !DIExpression()) #5, !dbg !268
  %17 = inttoptr i64 %5 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i16 %16, metadata !277, metadata !DIExpression()) #5, !dbg !282
  %18 = icmp eq i16 %16, 129, !dbg !288
  %19 = icmp eq i16 %16, -22392, !dbg !289
  %20 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %18) #5
  %21 = or i1 %19, %20, !dbg !289
  %22 = xor i1 %21, true, !dbg !290
  %23 = getelementptr i8, i8* %10, i64 18
  %24 = bitcast i8* %23 to %struct.vlan_hdr*
  %25 = icmp ugt %struct.vlan_hdr* %24, %17
  %26 = select i1 %22, i1 true, i1 %25, !dbg !291
  br i1 %26, label %44, label %27, !dbg !291

27:                                               ; preds = %13
  %28 = getelementptr i8, i8* %10, i64 16, !dbg !292
  %29 = bitcast i8* %28 to i16*, !dbg !292
  call void @llvm.dbg.value(metadata i16 undef, metadata !260, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %24, metadata !261, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata i32 1, metadata !267, metadata !DIExpression()) #5, !dbg !268
  %30 = load i16, i16* %29, align 1, !dbg !268, !tbaa !275
  call void @llvm.dbg.value(metadata i16 %30, metadata !260, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata i16 %30, metadata !277, metadata !DIExpression()) #5, !dbg !282
  %31 = icmp eq i16 %30, 129, !dbg !288
  %32 = icmp eq i16 %30, -22392, !dbg !289
  %33 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %31) #5
  %34 = or i1 %32, %33, !dbg !289
  %35 = xor i1 %34, true, !dbg !290
  %36 = getelementptr i8, i8* %10, i64 22
  %37 = bitcast i8* %36 to %struct.vlan_hdr*
  %38 = icmp ugt %struct.vlan_hdr* %37, %17
  %39 = select i1 %35, i1 true, i1 %38, !dbg !291
  br i1 %39, label %44, label %40, !dbg !291

40:                                               ; preds = %27
  %41 = getelementptr i8, i8* %10, i64 20, !dbg !292
  %42 = bitcast i8* %41 to i16*, !dbg !292
  call void @llvm.dbg.value(metadata i16 undef, metadata !260, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %37, metadata !261, metadata !DIExpression()) #5, !dbg !268
  call void @llvm.dbg.value(metadata i32 2, metadata !267, metadata !DIExpression()) #5, !dbg !268
  %43 = load i16, i16* %42, align 1, !dbg !268, !tbaa !275
  call void @llvm.dbg.value(metadata i16 %43, metadata !260, metadata !DIExpression()) #5, !dbg !268
  br label %44

44:                                               ; preds = %13, %27, %40
  %45 = phi i8* [ %11, %13 ], [ %23, %27 ], [ %36, %40 ], !dbg !268
  %46 = phi i16 [ %16, %13 ], [ %30, %27 ], [ %43, %40 ], !dbg !268
  call void @llvm.dbg.value(metadata i8* %45, metadata !230, metadata !DIExpression()), !dbg !236
  %47 = zext i16 %46 to i32, !dbg !293
  call void @llvm.dbg.value(metadata i32 %47, metadata !234, metadata !DIExpression()), !dbg !236
  %48 = icmp eq i16 %46, -8826, !dbg !294
  br i1 %48, label %49, label %67, !dbg !296

49:                                               ; preds = %44
  call void @llvm.dbg.value(metadata %struct.ipv6hdr** undef, metadata !111, metadata !DIExpression(DW_OP_deref)), !dbg !236
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !297, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata i8* %6, metadata !303, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata %struct.ipv6hdr** undef, metadata !304, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata i8* %45, metadata !305, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata i32 40, metadata !306, metadata !DIExpression()), !dbg !307
  %50 = getelementptr i8, i8* %45, i64 40, !dbg !310
  %51 = icmp ugt i8* %50, %6, !dbg !312
  br i1 %51, label %88, label %52, !dbg !313

52:                                               ; preds = %49
  call void @llvm.dbg.value(metadata i8* %45, metadata !305, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata i8* %50, metadata !230, metadata !DIExpression()), !dbg !236
  %53 = getelementptr inbounds i8, i8* %45, i64 6, !dbg !314
  %54 = load i8, i8* %53, align 2, !dbg !314, !tbaa !315
  call void @llvm.dbg.value(metadata i8 %54, metadata !234, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !236
  %55 = icmp eq i8 %54, 58, !dbg !318
  br i1 %55, label %56, label %88, !dbg !320

56:                                               ; preds = %52
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !321, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.value(metadata i8* %6, metadata !327, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.value(metadata %struct.icmp6hdr** undef, metadata !328, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.value(metadata i8* %50, metadata !329, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.value(metadata i32 8, metadata !330, metadata !DIExpression()), !dbg !331
  %57 = getelementptr i8, i8* %45, i64 48, !dbg !333
  %58 = icmp ugt i8* %57, %6, !dbg !335
  br i1 %58, label %88, label %59, !dbg !336

59:                                               ; preds = %56
  call void @llvm.dbg.value(metadata i8* %50, metadata !329, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.value(metadata i8* %57, metadata !230, metadata !DIExpression()), !dbg !236
  %60 = load i8, i8* %50, align 4, !dbg !337, !tbaa !338
  %61 = zext i8 %60 to i32, !dbg !340
  call void @llvm.dbg.value(metadata i32 %61, metadata !234, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.value(metadata i8* %50, metadata !145, metadata !DIExpression()), !dbg !236
  %62 = getelementptr i8, i8* %45, i64 46, !dbg !341
  %63 = bitcast i8* %62 to i16*, !dbg !341
  %64 = load i16, i16* %63, align 2, !dbg !341, !tbaa !343
  %65 = and i16 %64, 256, !dbg !344
  %66 = icmp eq i16 %65, 0, !dbg !344
  br i1 %66, label %88, label %67, !dbg !345

67:                                               ; preds = %59, %44
  %68 = phi i8* [ %57, %59 ], [ %45, %44 ], !dbg !346
  %69 = phi i32 [ %61, %59 ], [ %47, %44 ], !dbg !236
  call void @llvm.dbg.value(metadata i8* %68, metadata !230, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.value(metadata i32 %69, metadata !234, metadata !DIExpression()), !dbg !236
  %70 = icmp ne i32 %69, 8, !dbg !347
  %71 = getelementptr i8, i8* %68, i64 20
  %72 = icmp ugt i8* %71, %6
  %73 = select i1 %70, i1 true, i1 %72, !dbg !349
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !190, metadata !DIExpression(DW_OP_deref)), !dbg !236
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !350, metadata !DIExpression()), !dbg !360
  call void @llvm.dbg.value(metadata i8* %6, metadata !356, metadata !DIExpression()), !dbg !360
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !357, metadata !DIExpression()), !dbg !360
  call void @llvm.dbg.value(metadata i8* %68, metadata !358, metadata !DIExpression()), !dbg !360
  call void @llvm.dbg.value(metadata i32 20, metadata !359, metadata !DIExpression()), !dbg !360
  br i1 %73, label %88, label %74, !dbg !349

74:                                               ; preds = %67
  call void @llvm.dbg.value(metadata i8* %68, metadata !358, metadata !DIExpression()), !dbg !360
  call void @llvm.dbg.value(metadata i8* undef, metadata !230, metadata !DIExpression()), !dbg !236
  %75 = getelementptr inbounds i8, i8* %68, i64 9, !dbg !363
  %76 = load i8, i8* %75, align 1, !dbg !363, !tbaa !364
  call void @llvm.dbg.value(metadata i8 %76, metadata !234, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !236
  %77 = icmp ne i8 %76, 1, !dbg !366
  %78 = getelementptr i8, i8* %68, i64 28
  %79 = icmp ugt i8* %78, %6
  %80 = select i1 %77, i1 true, i1 %79, !dbg !368
  br i1 %80, label %88, label %81, !dbg !368

81:                                               ; preds = %74
  call void @llvm.dbg.value(metadata i8* undef, metadata !230, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.value(metadata i8 undef, metadata !234, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !236
  call void @llvm.dbg.value(metadata i8* undef, metadata !206, metadata !DIExpression()), !dbg !236
  %82 = getelementptr i8, i8* %68, i64 26, !dbg !369
  %83 = bitcast i8* %82 to i16*, !dbg !369
  %84 = load i16, i16* %83, align 2, !dbg !369, !tbaa !343
  %85 = and i16 %84, 256, !dbg !371
  %86 = icmp eq i16 %85, 0, !dbg !371
  br i1 %86, label %88, label %87, !dbg !372

87:                                               ; preds = %81
  call void @llvm.dbg.value(metadata i32 1, metadata !229, metadata !DIExpression()), !dbg !236
  br label %88, !dbg !373

88:                                               ; preds = %56, %49, %1, %59, %67, %81, %74, %52, %87
  %89 = phi i32 [ 2, %52 ], [ 2, %74 ], [ 2, %81 ], [ 1, %87 ], [ 2, %67 ], [ 1, %59 ], [ 2, %1 ], [ 2, %49 ], [ 2, %56 ], !dbg !236
  call void @llvm.dbg.value(metadata i32 %89, metadata !229, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.label(metadata !235), !dbg !375
  %90 = bitcast i32* %2 to i8*, !dbg !376
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %90), !dbg !376
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !381, metadata !DIExpression()) #5, !dbg !376
  call void @llvm.dbg.value(metadata i32 %89, metadata !382, metadata !DIExpression()) #5, !dbg !376
  store i32 %89, i32* %2, align 4, !tbaa !393
  call void @llvm.dbg.value(metadata i32* %2, metadata !382, metadata !DIExpression(DW_OP_deref)) #5, !dbg !376
  %91 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %90) #5, !dbg !394
  call void @llvm.dbg.value(metadata i8* %91, metadata !383, metadata !DIExpression()) #5, !dbg !376
  %92 = icmp eq i8* %91, null, !dbg !395
  br i1 %92, label %106, label %93, !dbg !397

93:                                               ; preds = %88
  call void @llvm.dbg.value(metadata i8* %91, metadata !383, metadata !DIExpression()) #5, !dbg !376
  %94 = bitcast i8* %91 to i64*, !dbg !398
  %95 = load i64, i64* %94, align 8, !dbg !399, !tbaa !400
  %96 = add i64 %95, 1, !dbg !399
  store i64 %96, i64* %94, align 8, !dbg !399, !tbaa !400
  %97 = load i32, i32* %3, align 4, !dbg !403, !tbaa !238
  %98 = load i32, i32* %7, align 4, !dbg !404, !tbaa !246
  %99 = sub i32 %97, %98, !dbg !405
  %100 = zext i32 %99 to i64, !dbg !406
  %101 = getelementptr inbounds i8, i8* %91, i64 8, !dbg !407
  %102 = bitcast i8* %101 to i64*, !dbg !407
  %103 = load i64, i64* %102, align 8, !dbg !408, !tbaa !409
  %104 = add i64 %103, %100, !dbg !408
  store i64 %104, i64* %102, align 8, !dbg !408, !tbaa !409
  %105 = load i32, i32* %2, align 4, !dbg !410, !tbaa !393
  call void @llvm.dbg.value(metadata i32 %105, metadata !382, metadata !DIExpression()) #5, !dbg !376
  br label %106, !dbg !411

106:                                              ; preds = %88, %93
  %107 = phi i32 [ %105, %93 ], [ 0, %88 ], !dbg !376
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %90), !dbg !412
  ret i32 %107, !dbg !413
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

; Function Attrs: nounwind readnone
declare i1 @llvm.bpf.passthrough.i1.i1(i32, i1) #4

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { nounwind readnone }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!75, !76, !77, !78}
!llvm.ident = !{!79}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !66, line: 16, type: !67, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !45, globals: !51, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet01-parsing", checksumkind: CSK_MD5, checksum: "503820b42c6b860c2dba21d55b95a2e9")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet01-parsing", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
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
!45 = !{!46, !47, !48}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!47 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !49, line: 24, baseType: !50)
!49 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!50 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!51 = !{!0, !52, !58}
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 252, type: !54, isLocal: false, isDefinition: true)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !55, size: 32, elements: !56)
!55 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!56 = !{!57}
!57 = !DISubrange(count: 4)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !60, line: 33, type: !61, isLocal: true, isDefinition: true)
!60 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet01-parsing", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DISubroutineType(types: !63)
!63 = !{!46, !46, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!66 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet01-parsing", checksumkind: CSK_MD5, checksum: "0f65d57b07088eec24d5031993b90668")
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !68, line: 33, size: 160, elements: !69)
!68 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet01-parsing", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!69 = !{!70, !71, !72, !73, !74}
!70 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !67, file: !68, line: 34, baseType: !7, size: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !67, file: !68, line: 35, baseType: !7, size: 32, offset: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !67, file: !68, line: 36, baseType: !7, size: 32, offset: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !67, file: !68, line: 37, baseType: !7, size: 32, offset: 96)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !67, file: !68, line: 38, baseType: !7, size: 32, offset: 128)
!75 = !{i32 7, !"Dwarf Version", i32 5}
!76 = !{i32 2, !"Debug Info Version", i32 3}
!77 = !{i32 1, !"wchar_size", i32 4}
!78 = !{i32 7, !"frame-pointer", i32 2}
!79 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!80 = distinct !DISubprogram(name: "xdp_parser_func", scope: !3, file: !3, line: 174, type: !81, scopeLine: 175, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !93)
!81 = !DISubroutineType(types: !82)
!82 = !{!83, !84}
!83 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !86)
!86 = !{!87, !89, !90, !91, !92}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !85, file: !6, line: 2857, baseType: !88, size: 32)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !49, line: 27, baseType: !7)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !85, file: !6, line: 2858, baseType: !88, size: 32, offset: 32)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !85, file: !6, line: 2859, baseType: !88, size: 32, offset: 64)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !85, file: !6, line: 2861, baseType: !88, size: 32, offset: 96)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !85, file: !6, line: 2862, baseType: !88, size: 32, offset: 128)
!93 = !{!94, !95, !96, !97, !111, !145, !190, !206, !229, !230, !234, !235}
!94 = !DILocalVariable(name: "ctx", arg: 1, scope: !80, file: !3, line: 174, type: !84)
!95 = !DILocalVariable(name: "data_end", scope: !80, file: !3, line: 176, type: !46)
!96 = !DILocalVariable(name: "data", scope: !80, file: !3, line: 177, type: !46)
!97 = !DILocalVariable(name: "eth", scope: !80, file: !3, line: 178, type: !98)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !100, line: 168, size: 112, elements: !101)
!100 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!101 = !{!102, !107, !108}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !99, file: !100, line: 169, baseType: !103, size: 48)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 48, elements: !105)
!104 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!105 = !{!106}
!106 = !DISubrange(count: 6)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !99, file: !100, line: 170, baseType: !103, size: 48, offset: 48)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !99, file: !100, line: 171, baseType: !109, size: 16, offset: 96)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !110, line: 25, baseType: !48)
!110 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!111 = !DILocalVariable(name: "ip6h", scope: !80, file: !3, line: 179, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !114, line: 117, size: 320, elements: !115)
!114 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "d13a9e1225644902b024ce986c8e059d")
!115 = !{!116, !118, !119, !123, !124, !125, !126, !144}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !113, file: !114, line: 119, baseType: !117, size: 4, flags: DIFlagBitField, extraData: i64 0)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !49, line: 21, baseType: !104)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !113, file: !114, line: 120, baseType: !117, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !113, file: !114, line: 127, baseType: !120, size: 24, offset: 8)
!120 = !DICompositeType(tag: DW_TAG_array_type, baseType: !117, size: 24, elements: !121)
!121 = !{!122}
!122 = !DISubrange(count: 3)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !113, file: !114, line: 129, baseType: !109, size: 16, offset: 32)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !113, file: !114, line: 130, baseType: !117, size: 8, offset: 48)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !113, file: !114, line: 131, baseType: !117, size: 8, offset: 56)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !113, file: !114, line: 133, baseType: !127, size: 128, offset: 64)
!127 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !128, line: 33, size: 128, elements: !129)
!128 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "", checksumkind: CSK_MD5, checksum: "8bebb780b45d3fe932cc1d934fa5f5fe")
!129 = !{!130}
!130 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !127, file: !128, line: 40, baseType: !131, size: 128)
!131 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !127, file: !128, line: 34, size: 128, elements: !132)
!132 = !{!133, !137, !141}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !131, file: !128, line: 35, baseType: !134, size: 128)
!134 = !DICompositeType(tag: DW_TAG_array_type, baseType: !117, size: 128, elements: !135)
!135 = !{!136}
!136 = !DISubrange(count: 16)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !131, file: !128, line: 37, baseType: !138, size: 128)
!138 = !DICompositeType(tag: DW_TAG_array_type, baseType: !109, size: 128, elements: !139)
!139 = !{!140}
!140 = !DISubrange(count: 8)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !131, file: !128, line: 38, baseType: !142, size: 128)
!142 = !DICompositeType(tag: DW_TAG_array_type, baseType: !143, size: 128, elements: !56)
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !110, line: 27, baseType: !88)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !113, file: !114, line: 134, baseType: !127, size: 128, offset: 192)
!145 = !DILocalVariable(name: "icmp6h", scope: !80, file: !3, line: 180, type: !146)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64)
!147 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmp6hdr", file: !148, line: 8, size: 64, elements: !149)
!148 = !DIFile(filename: "/usr/include/linux/icmpv6.h", directory: "", checksumkind: CSK_MD5, checksum: "0310ca5584e6f44f6eea6cf040ee84b9")
!149 = !{!150, !151, !152, !154}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_type", scope: !147, file: !148, line: 10, baseType: !117, size: 8)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_code", scope: !147, file: !148, line: 11, baseType: !117, size: 8, offset: 8)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_cksum", scope: !147, file: !148, line: 12, baseType: !153, size: 16, offset: 16)
!153 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !110, line: 31, baseType: !48)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_dataun", scope: !147, file: !148, line: 63, baseType: !155, size: 32, offset: 32)
!155 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !147, file: !148, line: 15, size: 32, elements: !156)
!156 = !{!157, !161, !165, !167, !172, !180}
!157 = !DIDerivedType(tag: DW_TAG_member, name: "un_data32", scope: !155, file: !148, line: 16, baseType: !158, size: 32)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !143, size: 32, elements: !159)
!159 = !{!160}
!160 = !DISubrange(count: 1)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "un_data16", scope: !155, file: !148, line: 17, baseType: !162, size: 32)
!162 = !DICompositeType(tag: DW_TAG_array_type, baseType: !109, size: 32, elements: !163)
!163 = !{!164}
!164 = !DISubrange(count: 2)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "un_data8", scope: !155, file: !148, line: 18, baseType: !166, size: 32)
!166 = !DICompositeType(tag: DW_TAG_array_type, baseType: !117, size: 32, elements: !56)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "u_echo", scope: !155, file: !148, line: 23, baseType: !168, size: 32)
!168 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_echo", file: !148, line: 20, size: 32, elements: !169)
!169 = !{!170, !171}
!170 = !DIDerivedType(tag: DW_TAG_member, name: "identifier", scope: !168, file: !148, line: 21, baseType: !109, size: 16)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !168, file: !148, line: 22, baseType: !109, size: 16, offset: 16)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "u_nd_advt", scope: !155, file: !148, line: 40, baseType: !173, size: 32)
!173 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_nd_advt", file: !148, line: 25, size: 32, elements: !174)
!174 = !{!175, !176, !177, !178, !179}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !173, file: !148, line: 27, baseType: !88, size: 5, flags: DIFlagBitField, extraData: i64 0)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "override", scope: !173, file: !148, line: 28, baseType: !88, size: 1, offset: 5, flags: DIFlagBitField, extraData: i64 0)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "solicited", scope: !173, file: !148, line: 29, baseType: !88, size: 1, offset: 6, flags: DIFlagBitField, extraData: i64 0)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "router", scope: !173, file: !148, line: 30, baseType: !88, size: 1, offset: 7, flags: DIFlagBitField, extraData: i64 0)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "reserved2", scope: !173, file: !148, line: 31, baseType: !88, size: 24, offset: 8, flags: DIFlagBitField, extraData: i64 0)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "u_nd_ra", scope: !155, file: !148, line: 61, baseType: !181, size: 32)
!181 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_nd_ra", file: !148, line: 42, size: 32, elements: !182)
!182 = !{!183, !184, !185, !186, !187, !188, !189}
!183 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !181, file: !148, line: 43, baseType: !117, size: 8)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !181, file: !148, line: 45, baseType: !117, size: 3, offset: 8, flags: DIFlagBitField, extraData: i64 8)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "router_pref", scope: !181, file: !148, line: 46, baseType: !117, size: 2, offset: 11, flags: DIFlagBitField, extraData: i64 8)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "home_agent", scope: !181, file: !148, line: 47, baseType: !117, size: 1, offset: 13, flags: DIFlagBitField, extraData: i64 8)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "other", scope: !181, file: !148, line: 48, baseType: !117, size: 1, offset: 14, flags: DIFlagBitField, extraData: i64 8)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "managed", scope: !181, file: !148, line: 49, baseType: !117, size: 1, offset: 15, flags: DIFlagBitField, extraData: i64 8)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "rt_lifetime", scope: !181, file: !148, line: 60, baseType: !109, size: 16, offset: 16)
!190 = !DILocalVariable(name: "iph", scope: !80, file: !3, line: 181, type: !191)
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 64)
!192 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !193, line: 86, size: 160, elements: !194)
!193 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "8776158f5e307e9a8189f0dae4b43df4")
!194 = !{!195, !196, !197, !198, !199, !200, !201, !202, !203, !204, !205}
!195 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !192, file: !193, line: 88, baseType: !117, size: 4, flags: DIFlagBitField, extraData: i64 0)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !192, file: !193, line: 89, baseType: !117, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !192, file: !193, line: 96, baseType: !117, size: 8, offset: 8)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !192, file: !193, line: 97, baseType: !109, size: 16, offset: 16)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !192, file: !193, line: 98, baseType: !109, size: 16, offset: 32)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !192, file: !193, line: 99, baseType: !109, size: 16, offset: 48)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !192, file: !193, line: 100, baseType: !117, size: 8, offset: 64)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !192, file: !193, line: 101, baseType: !117, size: 8, offset: 72)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !192, file: !193, line: 102, baseType: !153, size: 16, offset: 80)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !192, file: !193, line: 103, baseType: !143, size: 32, offset: 96)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !192, file: !193, line: 104, baseType: !143, size: 32, offset: 128)
!206 = !DILocalVariable(name: "icmph", scope: !80, file: !3, line: 182, type: !207)
!207 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !208, size: 64)
!208 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr", file: !209, line: 89, size: 64, elements: !210)
!209 = !DIFile(filename: "/usr/include/linux/icmp.h", directory: "", checksumkind: CSK_MD5, checksum: "a505632898dce546638b3344627d334b")
!210 = !{!211, !212, !213, !214}
!211 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !208, file: !209, line: 90, baseType: !117, size: 8)
!212 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !208, file: !209, line: 91, baseType: !117, size: 8, offset: 8)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "checksum", scope: !208, file: !209, line: 92, baseType: !153, size: 16, offset: 16)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "un", scope: !208, file: !209, line: 104, baseType: !215, size: 32, offset: 32)
!215 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !208, file: !209, line: 93, size: 32, elements: !216)
!216 = !{!217, !222, !223, !228}
!217 = !DIDerivedType(tag: DW_TAG_member, name: "echo", scope: !215, file: !209, line: 97, baseType: !218, size: 32)
!218 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !215, file: !209, line: 94, size: 32, elements: !219)
!219 = !{!220, !221}
!220 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !218, file: !209, line: 95, baseType: !109, size: 16)
!221 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !218, file: !209, line: 96, baseType: !109, size: 16, offset: 16)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "gateway", scope: !215, file: !209, line: 98, baseType: !143, size: 32)
!223 = !DIDerivedType(tag: DW_TAG_member, name: "frag", scope: !215, file: !209, line: 102, baseType: !224, size: 32)
!224 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !215, file: !209, line: 99, size: 32, elements: !225)
!225 = !{!226, !227}
!226 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !224, file: !209, line: 100, baseType: !109, size: 16)
!227 = !DIDerivedType(tag: DW_TAG_member, name: "mtu", scope: !224, file: !209, line: 101, baseType: !109, size: 16, offset: 16)
!228 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !215, file: !209, line: 103, baseType: !166, size: 32)
!229 = !DILocalVariable(name: "action", scope: !80, file: !3, line: 189, type: !88)
!230 = !DILocalVariable(name: "nh", scope: !80, file: !3, line: 192, type: !231)
!231 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !3, line: 26, size: 64, elements: !232)
!232 = !{!233}
!233 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !231, file: !3, line: 27, baseType: !46, size: 64)
!234 = !DILocalVariable(name: "nh_type", scope: !80, file: !3, line: 193, type: !83)
!235 = !DILabel(scope: !80, name: "out", file: !3, line: 248)
!236 = !DILocation(line: 0, scope: !80)
!237 = !DILocation(line: 176, column: 38, scope: !80)
!238 = !{!239, !240, i64 4}
!239 = !{!"xdp_md", !240, i64 0, !240, i64 4, !240, i64 8, !240, i64 12, !240, i64 16}
!240 = !{!"int", !241, i64 0}
!241 = !{!"omnipotent char", !242, i64 0}
!242 = !{!"Simple C/C++ TBAA"}
!243 = !DILocation(line: 176, column: 27, scope: !80)
!244 = !DILocation(line: 176, column: 19, scope: !80)
!245 = !DILocation(line: 177, column: 34, scope: !80)
!246 = !{!239, !240, i64 0}
!247 = !DILocation(line: 177, column: 23, scope: !80)
!248 = !DILocation(line: 177, column: 15, scope: !80)
!249 = !DILocalVariable(name: "nh", arg: 1, scope: !250, file: !3, line: 54, type: !253)
!250 = distinct !DISubprogram(name: "parse_ethhdr", scope: !3, file: !3, line: 54, type: !251, scopeLine: 57, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !255)
!251 = !DISubroutineType(types: !252)
!252 = !{!83, !253, !46, !254}
!253 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !231, size: 64)
!254 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!255 = !{!249, !256, !257, !258, !259, !260, !261, !267}
!256 = !DILocalVariable(name: "data_end", arg: 2, scope: !250, file: !3, line: 55, type: !46)
!257 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !250, file: !3, line: 56, type: !254)
!258 = !DILocalVariable(name: "eth", scope: !250, file: !3, line: 58, type: !98)
!259 = !DILocalVariable(name: "hdrsize", scope: !250, file: !3, line: 59, type: !83)
!260 = !DILocalVariable(name: "h_proto", scope: !250, file: !3, line: 60, type: !48)
!261 = !DILocalVariable(name: "vlh", scope: !250, file: !3, line: 61, type: !262)
!262 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !263, size: 64)
!263 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !3, line: 31, size: 32, elements: !264)
!264 = !{!265, !266}
!265 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !263, file: !3, line: 32, baseType: !109, size: 16)
!266 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !263, file: !3, line: 33, baseType: !109, size: 16, offset: 16)
!267 = !DILocalVariable(name: "i", scope: !250, file: !3, line: 62, type: !83)
!268 = !DILocation(line: 0, scope: !250, inlinedAt: !269)
!269 = distinct !DILocation(line: 202, column: 12, scope: !80)
!270 = !DILocation(line: 67, column: 14, scope: !271, inlinedAt: !269)
!271 = distinct !DILexicalBlock(scope: !250, file: !3, line: 67, column: 6)
!272 = !DILocation(line: 67, column: 24, scope: !271, inlinedAt: !269)
!273 = !DILocation(line: 67, column: 6, scope: !250, inlinedAt: !269)
!274 = !DILocation(line: 74, column: 17, scope: !250, inlinedAt: !269)
!275 = !{!276, !276, i64 0}
!276 = !{!"short", !241, i64 0}
!277 = !DILocalVariable(name: "h_proto", arg: 1, scope: !278, file: !3, line: 37, type: !48)
!278 = distinct !DISubprogram(name: "proto_is_vlan", scope: !3, file: !3, line: 37, type: !279, scopeLine: 38, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !281)
!279 = !DISubroutineType(types: !280)
!280 = !{!83, !48}
!281 = !{!277}
!282 = !DILocation(line: 0, scope: !278, inlinedAt: !283)
!283 = distinct !DILocation(line: 78, column: 8, scope: !284, inlinedAt: !269)
!284 = distinct !DILexicalBlock(scope: !285, file: !3, line: 78, column: 7)
!285 = distinct !DILexicalBlock(scope: !286, file: !3, line: 77, column: 39)
!286 = distinct !DILexicalBlock(scope: !287, file: !3, line: 77, column: 2)
!287 = distinct !DILexicalBlock(scope: !250, file: !3, line: 77, column: 2)
!288 = !DILocation(line: 39, column: 27, scope: !278, inlinedAt: !283)
!289 = !DILocation(line: 39, column: 53, scope: !278, inlinedAt: !283)
!290 = !DILocation(line: 78, column: 8, scope: !284, inlinedAt: !269)
!291 = !DILocation(line: 78, column: 7, scope: !285, inlinedAt: !269)
!292 = !DILocation(line: 84, column: 18, scope: !285, inlinedAt: !269)
!293 = !DILocation(line: 90, column: 9, scope: !250, inlinedAt: !269)
!294 = !DILocation(line: 206, column: 13, scope: !295)
!295 = distinct !DILexicalBlock(scope: !80, file: !3, line: 206, column: 6)
!296 = !DILocation(line: 206, column: 6, scope: !80)
!297 = !DILocalVariable(name: "nh", arg: 1, scope: !298, file: !3, line: 94, type: !253)
!298 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !3, file: !3, line: 94, type: !299, scopeLine: 97, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !302)
!299 = !DISubroutineType(types: !300)
!300 = !{!83, !253, !46, !301}
!301 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!302 = !{!297, !303, !304, !305, !306}
!303 = !DILocalVariable(name: "data_end", arg: 2, scope: !298, file: !3, line: 95, type: !46)
!304 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !298, file: !3, line: 96, type: !301)
!305 = !DILocalVariable(name: "ip6h", scope: !298, file: !3, line: 98, type: !112)
!306 = !DILocalVariable(name: "hdrsize", scope: !298, file: !3, line: 99, type: !83)
!307 = !DILocation(line: 0, scope: !298, inlinedAt: !308)
!308 = distinct !DILocation(line: 207, column: 13, scope: !309)
!309 = distinct !DILexicalBlock(scope: !295, file: !3, line: 206, column: 39)
!310 = !DILocation(line: 101, column: 14, scope: !311, inlinedAt: !308)
!311 = distinct !DILexicalBlock(scope: !298, file: !3, line: 101, column: 6)
!312 = !DILocation(line: 101, column: 24, scope: !311, inlinedAt: !308)
!313 = !DILocation(line: 101, column: 6, scope: !298, inlinedAt: !308)
!314 = !DILocation(line: 107, column: 15, scope: !298, inlinedAt: !308)
!315 = !{!316, !241, i64 6}
!316 = !{!"ipv6hdr", !241, i64 0, !241, i64 0, !241, i64 1, !276, i64 4, !241, i64 6, !241, i64 7, !317, i64 8, !317, i64 24}
!317 = !{!"in6_addr", !241, i64 0}
!318 = !DILocation(line: 209, column: 15, scope: !319)
!319 = distinct !DILexicalBlock(scope: !309, file: !3, line: 209, column: 7)
!320 = !DILocation(line: 209, column: 7, scope: !309)
!321 = !DILocalVariable(name: "nh", arg: 1, scope: !322, file: !3, line: 132, type: !253)
!322 = distinct !DISubprogram(name: "parse_icmp6hdr", scope: !3, file: !3, line: 132, type: !323, scopeLine: 135, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !326)
!323 = !DISubroutineType(types: !324)
!324 = !{!83, !253, !46, !325}
!325 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!326 = !{!321, !327, !328, !329, !330}
!327 = !DILocalVariable(name: "data_end", arg: 2, scope: !322, file: !3, line: 133, type: !46)
!328 = !DILocalVariable(name: "icmp6hdr", arg: 3, scope: !322, file: !3, line: 134, type: !325)
!329 = !DILocalVariable(name: "icmp6h", scope: !322, file: !3, line: 137, type: !146)
!330 = !DILocalVariable(name: "hdrsize", scope: !322, file: !3, line: 138, type: !83)
!331 = !DILocation(line: 0, scope: !322, inlinedAt: !332)
!332 = distinct !DILocation(line: 214, column: 13, scope: !309)
!333 = !DILocation(line: 140, column: 14, scope: !334, inlinedAt: !332)
!334 = distinct !DILexicalBlock(scope: !322, file: !3, line: 140, column: 6)
!335 = !DILocation(line: 140, column: 24, scope: !334, inlinedAt: !332)
!336 = !DILocation(line: 140, column: 6, scope: !322, inlinedAt: !332)
!337 = !DILocation(line: 146, column: 17, scope: !322, inlinedAt: !332)
!338 = !{!339, !241, i64 0}
!339 = !{!"icmp6hdr", !241, i64 0, !241, i64 1, !276, i64 2, !241, i64 4}
!340 = !DILocation(line: 146, column: 9, scope: !322, inlinedAt: !332)
!341 = !DILocation(line: 221, column: 7, scope: !342)
!342 = distinct !DILexicalBlock(scope: !309, file: !3, line: 221, column: 7)
!343 = !{!241, !241, i64 0}
!344 = !DILocation(line: 221, column: 45, scope: !342)
!345 = !DILocation(line: 221, column: 7, scope: !309)
!346 = !DILocation(line: 196, column: 9, scope: !80)
!347 = !DILocation(line: 227, column: 14, scope: !348)
!348 = distinct !DILexicalBlock(scope: !80, file: !3, line: 227, column: 6)
!349 = !DILocation(line: 227, column: 6, scope: !80)
!350 = !DILocalVariable(name: "nh", arg: 1, scope: !351, file: !3, line: 112, type: !253)
!351 = distinct !DISubprogram(name: "parse_iphdr", scope: !3, file: !3, line: 112, type: !352, scopeLine: 115, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !355)
!352 = !DISubroutineType(types: !353)
!353 = !{!83, !253, !46, !354}
!354 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !191, size: 64)
!355 = !{!350, !356, !357, !358, !359}
!356 = !DILocalVariable(name: "data_end", arg: 2, scope: !351, file: !3, line: 113, type: !46)
!357 = !DILocalVariable(name: "iphdr", arg: 3, scope: !351, file: !3, line: 114, type: !354)
!358 = !DILocalVariable(name: "iph", scope: !351, file: !3, line: 116, type: !191)
!359 = !DILocalVariable(name: "hdrsize", scope: !351, file: !3, line: 117, type: !83)
!360 = !DILocation(line: 0, scope: !351, inlinedAt: !361)
!361 = distinct !DILocation(line: 228, column: 13, scope: !362)
!362 = distinct !DILexicalBlock(scope: !348, file: !3, line: 227, column: 38)
!363 = !DILocation(line: 126, column: 14, scope: !351, inlinedAt: !361)
!364 = !{!365, !241, i64 9}
!365 = !{!"iphdr", !241, i64 0, !241, i64 0, !241, i64 1, !276, i64 2, !276, i64 4, !276, i64 6, !241, i64 8, !241, i64 9, !276, i64 10, !240, i64 12, !240, i64 16}
!366 = !DILocation(line: 229, column: 15, scope: !367)
!367 = distinct !DILexicalBlock(scope: !362, file: !3, line: 229, column: 7)
!368 = !DILocation(line: 229, column: 7, scope: !362)
!369 = !DILocation(line: 240, column: 9, scope: !370)
!370 = distinct !DILexicalBlock(scope: !362, file: !3, line: 240, column: 7)
!371 = !DILocation(line: 240, column: 48, scope: !370)
!372 = !DILocation(line: 240, column: 7, scope: !362)
!373 = !DILocation(line: 242, column: 4, scope: !374)
!374 = distinct !DILexicalBlock(scope: !370, file: !3, line: 240, column: 54)
!375 = !DILocation(line: 248, column: 1, scope: !80)
!376 = !DILocation(line: 0, scope: !377, inlinedAt: !392)
!377 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !66, file: !66, line: 24, type: !378, scopeLine: 25, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !380)
!378 = !DISubroutineType(types: !379)
!379 = !{!88, !84, !88}
!380 = !{!381, !382, !383}
!381 = !DILocalVariable(name: "ctx", arg: 1, scope: !377, file: !66, line: 24, type: !84)
!382 = !DILocalVariable(name: "action", arg: 2, scope: !377, file: !66, line: 24, type: !88)
!383 = !DILocalVariable(name: "rec", scope: !377, file: !66, line: 30, type: !384)
!384 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !385, size: 64)
!385 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !386, line: 10, size: 128, elements: !387)
!386 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet01-parsing", checksumkind: CSK_MD5, checksum: "96c2435685fa7da2d24f219444d8659d")
!387 = !{!388, !391}
!388 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !385, file: !386, line: 11, baseType: !389, size: 64)
!389 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !49, line: 31, baseType: !390)
!390 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!391 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !385, file: !386, line: 12, baseType: !389, size: 64, offset: 64)
!392 = distinct !DILocation(line: 249, column: 9, scope: !80)
!393 = !{!240, !240, i64 0}
!394 = !DILocation(line: 30, column: 24, scope: !377, inlinedAt: !392)
!395 = !DILocation(line: 31, column: 7, scope: !396, inlinedAt: !392)
!396 = distinct !DILexicalBlock(scope: !377, file: !66, line: 31, column: 6)
!397 = !DILocation(line: 31, column: 6, scope: !377, inlinedAt: !392)
!398 = !DILocation(line: 38, column: 7, scope: !377, inlinedAt: !392)
!399 = !DILocation(line: 38, column: 17, scope: !377, inlinedAt: !392)
!400 = !{!401, !402, i64 0}
!401 = !{!"datarec", !402, i64 0, !402, i64 8}
!402 = !{!"long long", !241, i64 0}
!403 = !DILocation(line: 39, column: 25, scope: !377, inlinedAt: !392)
!404 = !DILocation(line: 39, column: 41, scope: !377, inlinedAt: !392)
!405 = !DILocation(line: 39, column: 34, scope: !377, inlinedAt: !392)
!406 = !DILocation(line: 39, column: 19, scope: !377, inlinedAt: !392)
!407 = !DILocation(line: 39, column: 7, scope: !377, inlinedAt: !392)
!408 = !DILocation(line: 39, column: 16, scope: !377, inlinedAt: !392)
!409 = !{!401, !402, i64 8}
!410 = !DILocation(line: 41, column: 9, scope: !377, inlinedAt: !392)
!411 = !DILocation(line: 41, column: 2, scope: !377, inlinedAt: !392)
!412 = !DILocation(line: 42, column: 1, scope: !377, inlinedAt: !392)
!413 = !DILocation(line: 249, column: 2, scope: !80)

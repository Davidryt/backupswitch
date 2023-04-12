; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !18
@llvm.compiler.used = appending global [5 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_abort_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_drop_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_pass" !dbg !45 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !60, metadata !DIExpression()), !dbg !62
  call void @llvm.dbg.value(metadata i32 2, metadata !61, metadata !DIExpression()), !dbg !62
  %3 = bitcast i32* %2 to i8*, !dbg !63
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3), !dbg !63
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !68, metadata !DIExpression()) #3, !dbg !63
  call void @llvm.dbg.value(metadata i32 2, metadata !69, metadata !DIExpression()) #3, !dbg !63
  store i32 2, i32* %2, align 4, !tbaa !83
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !87
  %5 = load i32, i32* %4, align 4, !dbg !87, !tbaa !88
  call void @llvm.dbg.value(metadata i32 %5, metadata !70, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)) #3, !dbg !63
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !90
  %7 = load i32, i32* %6, align 4, !dbg !90, !tbaa !91
  call void @llvm.dbg.value(metadata i32 %7, metadata !71, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)) #3, !dbg !63
  call void @llvm.dbg.value(metadata i32* %2, metadata !69, metadata !DIExpression(DW_OP_deref)) #3, !dbg !63
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %3) #3, !dbg !92
  call void @llvm.dbg.value(metadata i8* %8, metadata !72, metadata !DIExpression()) #3, !dbg !63
  %9 = icmp eq i8* %8, null, !dbg !93
  br i1 %9, label %22, label %10, !dbg !95

10:                                               ; preds = %1
  %11 = zext i32 %7 to i64, !dbg !96
  call void @llvm.dbg.value(metadata i64 %11, metadata !71, metadata !DIExpression()) #3, !dbg !63
  %12 = zext i32 %5 to i64, !dbg !97
  call void @llvm.dbg.value(metadata i64 %12, metadata !70, metadata !DIExpression()) #3, !dbg !63
  call void @llvm.dbg.value(metadata i8* %8, metadata !72, metadata !DIExpression()) #3, !dbg !63
  %13 = sub nsw i64 %12, %11, !dbg !98
  call void @llvm.dbg.value(metadata i64 %13, metadata !81, metadata !DIExpression()) #3, !dbg !63
  %14 = bitcast i8* %8 to i64*, !dbg !99
  %15 = load i64, i64* %14, align 8, !dbg !100, !tbaa !101
  %16 = add i64 %15, 1, !dbg !100
  store i64 %16, i64* %14, align 8, !dbg !100, !tbaa !101
  %17 = getelementptr inbounds i8, i8* %8, i64 8, !dbg !104
  %18 = bitcast i8* %17 to i64*, !dbg !104
  %19 = load i64, i64* %18, align 8, !dbg !105, !tbaa !106
  %20 = add i64 %13, %19, !dbg !105
  store i64 %20, i64* %18, align 8, !dbg !105, !tbaa !106
  %21 = load i32, i32* %2, align 4, !dbg !107, !tbaa !83
  call void @llvm.dbg.value(metadata i32 %21, metadata !69, metadata !DIExpression()) #3, !dbg !63
  br label %22

22:                                               ; preds = %1, %10
  %23 = phi i32 [ %21, %10 ], [ 0, %1 ], !dbg !63
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3), !dbg !108
  ret i32 %23, !dbg !109
}

; Function Attrs: nounwind
define dso_local i32 @xdp_drop_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_drop" !dbg !110 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !112, metadata !DIExpression()), !dbg !114
  call void @llvm.dbg.value(metadata i32 1, metadata !113, metadata !DIExpression()), !dbg !114
  %3 = bitcast i32* %2 to i8*, !dbg !115
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3), !dbg !115
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !68, metadata !DIExpression()) #3, !dbg !115
  call void @llvm.dbg.value(metadata i32 1, metadata !69, metadata !DIExpression()) #3, !dbg !115
  store i32 1, i32* %2, align 4, !tbaa !83
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !117
  %5 = load i32, i32* %4, align 4, !dbg !117, !tbaa !88
  call void @llvm.dbg.value(metadata i32 %5, metadata !70, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)) #3, !dbg !115
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !118
  %7 = load i32, i32* %6, align 4, !dbg !118, !tbaa !91
  call void @llvm.dbg.value(metadata i32 %7, metadata !71, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)) #3, !dbg !115
  call void @llvm.dbg.value(metadata i32* %2, metadata !69, metadata !DIExpression(DW_OP_deref)) #3, !dbg !115
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %3) #3, !dbg !119
  call void @llvm.dbg.value(metadata i8* %8, metadata !72, metadata !DIExpression()) #3, !dbg !115
  %9 = icmp eq i8* %8, null, !dbg !120
  br i1 %9, label %22, label %10, !dbg !121

10:                                               ; preds = %1
  %11 = zext i32 %7 to i64, !dbg !122
  call void @llvm.dbg.value(metadata i64 %11, metadata !71, metadata !DIExpression()) #3, !dbg !115
  %12 = zext i32 %5 to i64, !dbg !123
  call void @llvm.dbg.value(metadata i64 %12, metadata !70, metadata !DIExpression()) #3, !dbg !115
  call void @llvm.dbg.value(metadata i8* %8, metadata !72, metadata !DIExpression()) #3, !dbg !115
  %13 = sub nsw i64 %12, %11, !dbg !124
  call void @llvm.dbg.value(metadata i64 %13, metadata !81, metadata !DIExpression()) #3, !dbg !115
  %14 = bitcast i8* %8 to i64*, !dbg !125
  %15 = load i64, i64* %14, align 8, !dbg !126, !tbaa !101
  %16 = add i64 %15, 1, !dbg !126
  store i64 %16, i64* %14, align 8, !dbg !126, !tbaa !101
  %17 = getelementptr inbounds i8, i8* %8, i64 8, !dbg !127
  %18 = bitcast i8* %17 to i64*, !dbg !127
  %19 = load i64, i64* %18, align 8, !dbg !128, !tbaa !106
  %20 = add i64 %13, %19, !dbg !128
  store i64 %20, i64* %18, align 8, !dbg !128, !tbaa !106
  %21 = load i32, i32* %2, align 4, !dbg !129, !tbaa !83
  call void @llvm.dbg.value(metadata i32 %21, metadata !69, metadata !DIExpression()) #3, !dbg !115
  br label %22

22:                                               ; preds = %1, %10
  %23 = phi i32 [ %21, %10 ], [ 0, %1 ], !dbg !115
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3), !dbg !130
  ret i32 %23, !dbg !131
}

; Function Attrs: nounwind
define dso_local i32 @xdp_abort_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_abort" !dbg !132 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !134, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.value(metadata i32 0, metadata !135, metadata !DIExpression()), !dbg !136
  %3 = bitcast i32* %2 to i8*, !dbg !137
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3), !dbg !137
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !68, metadata !DIExpression()) #3, !dbg !137
  call void @llvm.dbg.value(metadata i32 0, metadata !69, metadata !DIExpression()) #3, !dbg !137
  store i32 0, i32* %2, align 4, !tbaa !83
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !139
  %5 = load i32, i32* %4, align 4, !dbg !139, !tbaa !88
  call void @llvm.dbg.value(metadata i32 %5, metadata !70, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)) #3, !dbg !137
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !140
  %7 = load i32, i32* %6, align 4, !dbg !140, !tbaa !91
  call void @llvm.dbg.value(metadata i32 %7, metadata !71, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)) #3, !dbg !137
  call void @llvm.dbg.value(metadata i32* %2, metadata !69, metadata !DIExpression(DW_OP_deref)) #3, !dbg !137
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %3) #3, !dbg !141
  call void @llvm.dbg.value(metadata i8* %8, metadata !72, metadata !DIExpression()) #3, !dbg !137
  %9 = icmp eq i8* %8, null, !dbg !142
  br i1 %9, label %22, label %10, !dbg !143

10:                                               ; preds = %1
  %11 = zext i32 %7 to i64, !dbg !144
  call void @llvm.dbg.value(metadata i64 %11, metadata !71, metadata !DIExpression()) #3, !dbg !137
  %12 = zext i32 %5 to i64, !dbg !145
  call void @llvm.dbg.value(metadata i64 %12, metadata !70, metadata !DIExpression()) #3, !dbg !137
  call void @llvm.dbg.value(metadata i8* %8, metadata !72, metadata !DIExpression()) #3, !dbg !137
  %13 = sub nsw i64 %12, %11, !dbg !146
  call void @llvm.dbg.value(metadata i64 %13, metadata !81, metadata !DIExpression()) #3, !dbg !137
  %14 = bitcast i8* %8 to i64*, !dbg !147
  %15 = load i64, i64* %14, align 8, !dbg !148, !tbaa !101
  %16 = add i64 %15, 1, !dbg !148
  store i64 %16, i64* %14, align 8, !dbg !148, !tbaa !101
  %17 = getelementptr inbounds i8, i8* %8, i64 8, !dbg !149
  %18 = bitcast i8* %17 to i64*, !dbg !149
  %19 = load i64, i64* %18, align 8, !dbg !150, !tbaa !106
  %20 = add i64 %13, %19, !dbg !150
  store i64 %20, i64* %18, align 8, !dbg !150, !tbaa !106
  %21 = load i32, i32* %2, align 4, !dbg !151, !tbaa !83
  call void @llvm.dbg.value(metadata i32 %21, metadata !69, metadata !DIExpression()) #3, !dbg !137
  br label %22

22:                                               ; preds = %1, %10
  %23 = phi i32 [ %21, %10 ], [ 0, %1 ], !dbg !137
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3), !dbg !152
  ret i32 %23, !dbg !153
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nosync nounwind willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!40, !41, !42, !43}
!llvm.ident = !{!44}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 11, type: !32, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic04-pinning-maps", checksumkind: CSK_MD5, checksum: "34e85aa4854310fba5468497e7997aab")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic04-pinning-maps", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!15, !16}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!17 = !{!0, !18, !24}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 76, type: !20, isLocal: false, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 32, elements: !22)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!22 = !{!23}
!23 = !DISubrange(count: 4)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !26, line: 33, type: !27, isLocal: true, isDefinition: true)
!26 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic04-pinning-maps", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!28 = !DISubroutineType(types: !29)
!29 = !{!15, !15, !30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !33, line: 33, size: 160, elements: !34)
!33 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic04-pinning-maps", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!34 = !{!35, !36, !37, !38, !39}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !32, file: !33, line: 34, baseType: !7, size: 32)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !32, file: !33, line: 35, baseType: !7, size: 32, offset: 32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !32, file: !33, line: 36, baseType: !7, size: 32, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !32, file: !33, line: 37, baseType: !7, size: 32, offset: 96)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !32, file: !33, line: 38, baseType: !7, size: 32, offset: 128)
!40 = !{i32 7, !"Dwarf Version", i32 5}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{i32 7, !"frame-pointer", i32 2}
!44 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!45 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 53, type: !46, scopeLine: 54, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !59)
!46 = !DISubroutineType(types: !47)
!47 = !{!48, !49}
!48 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !51)
!51 = !{!52, !55, !56, !57, !58}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !50, file: !6, line: 2857, baseType: !53, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !54, line: 27, baseType: !7)
!54 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!55 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !50, file: !6, line: 2858, baseType: !53, size: 32, offset: 32)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !50, file: !6, line: 2859, baseType: !53, size: 32, offset: 64)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !50, file: !6, line: 2861, baseType: !53, size: 32, offset: 96)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !50, file: !6, line: 2862, baseType: !53, size: 32, offset: 128)
!59 = !{!60, !61}
!60 = !DILocalVariable(name: "ctx", arg: 1, scope: !45, file: !3, line: 53, type: !49)
!61 = !DILocalVariable(name: "action", scope: !45, file: !3, line: 55, type: !53)
!62 = !DILocation(line: 0, scope: !45)
!63 = !DILocation(line: 0, scope: !64, inlinedAt: !82)
!64 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !3, file: !3, line: 26, type: !65, scopeLine: 27, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{!53, !49, !53}
!67 = !{!68, !69, !70, !71, !72, !81}
!68 = !DILocalVariable(name: "ctx", arg: 1, scope: !64, file: !3, line: 26, type: !49)
!69 = !DILocalVariable(name: "action", arg: 2, scope: !64, file: !3, line: 26, type: !53)
!70 = !DILocalVariable(name: "data_end", scope: !64, file: !3, line: 28, type: !15)
!71 = !DILocalVariable(name: "data", scope: !64, file: !3, line: 29, type: !15)
!72 = !DILocalVariable(name: "rec", scope: !64, file: !3, line: 35, type: !73)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !75, line: 8, size: 128, elements: !76)
!75 = !DIFile(filename: "./common_kern_user.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic04-pinning-maps", checksumkind: CSK_MD5, checksum: "af04273c734158c41bba4bd0b2216829")
!76 = !{!77, !80}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !74, file: !75, line: 9, baseType: !78, size: 64)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !54, line: 31, baseType: !79)
!79 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !74, file: !75, line: 10, baseType: !78, size: 64, offset: 64)
!81 = !DILocalVariable(name: "bytes", scope: !64, file: !3, line: 40, type: !78)
!82 = distinct !DILocation(line: 57, column: 9, scope: !45)
!83 = !{!84, !84, i64 0}
!84 = !{!"int", !85, i64 0}
!85 = !{!"omnipotent char", !86, i64 0}
!86 = !{!"Simple C/C++ TBAA"}
!87 = !DILocation(line: 28, column: 38, scope: !64, inlinedAt: !82)
!88 = !{!89, !84, i64 4}
!89 = !{!"xdp_md", !84, i64 0, !84, i64 4, !84, i64 8, !84, i64 12, !84, i64 16}
!90 = !DILocation(line: 29, column: 38, scope: !64, inlinedAt: !82)
!91 = !{!89, !84, i64 0}
!92 = !DILocation(line: 35, column: 24, scope: !64, inlinedAt: !82)
!93 = !DILocation(line: 36, column: 7, scope: !94, inlinedAt: !82)
!94 = distinct !DILexicalBlock(scope: !64, file: !3, line: 36, column: 6)
!95 = !DILocation(line: 36, column: 6, scope: !64, inlinedAt: !82)
!96 = !DILocation(line: 29, column: 27, scope: !64, inlinedAt: !82)
!97 = !DILocation(line: 28, column: 27, scope: !64, inlinedAt: !82)
!98 = !DILocation(line: 40, column: 25, scope: !64, inlinedAt: !82)
!99 = !DILocation(line: 46, column: 7, scope: !64, inlinedAt: !82)
!100 = !DILocation(line: 46, column: 17, scope: !64, inlinedAt: !82)
!101 = !{!102, !103, i64 0}
!102 = !{!"datarec", !103, i64 0, !103, i64 8}
!103 = !{!"long long", !85, i64 0}
!104 = !DILocation(line: 47, column: 7, scope: !64, inlinedAt: !82)
!105 = !DILocation(line: 47, column: 16, scope: !64, inlinedAt: !82)
!106 = !{!102, !103, i64 8}
!107 = !DILocation(line: 49, column: 9, scope: !64, inlinedAt: !82)
!108 = !DILocation(line: 50, column: 1, scope: !64, inlinedAt: !82)
!109 = !DILocation(line: 57, column: 2, scope: !45)
!110 = distinct !DISubprogram(name: "xdp_drop_func", scope: !3, file: !3, line: 61, type: !46, scopeLine: 62, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !111)
!111 = !{!112, !113}
!112 = !DILocalVariable(name: "ctx", arg: 1, scope: !110, file: !3, line: 61, type: !49)
!113 = !DILocalVariable(name: "action", scope: !110, file: !3, line: 63, type: !53)
!114 = !DILocation(line: 0, scope: !110)
!115 = !DILocation(line: 0, scope: !64, inlinedAt: !116)
!116 = distinct !DILocation(line: 65, column: 9, scope: !110)
!117 = !DILocation(line: 28, column: 38, scope: !64, inlinedAt: !116)
!118 = !DILocation(line: 29, column: 38, scope: !64, inlinedAt: !116)
!119 = !DILocation(line: 35, column: 24, scope: !64, inlinedAt: !116)
!120 = !DILocation(line: 36, column: 7, scope: !94, inlinedAt: !116)
!121 = !DILocation(line: 36, column: 6, scope: !64, inlinedAt: !116)
!122 = !DILocation(line: 29, column: 27, scope: !64, inlinedAt: !116)
!123 = !DILocation(line: 28, column: 27, scope: !64, inlinedAt: !116)
!124 = !DILocation(line: 40, column: 25, scope: !64, inlinedAt: !116)
!125 = !DILocation(line: 46, column: 7, scope: !64, inlinedAt: !116)
!126 = !DILocation(line: 46, column: 17, scope: !64, inlinedAt: !116)
!127 = !DILocation(line: 47, column: 7, scope: !64, inlinedAt: !116)
!128 = !DILocation(line: 47, column: 16, scope: !64, inlinedAt: !116)
!129 = !DILocation(line: 49, column: 9, scope: !64, inlinedAt: !116)
!130 = !DILocation(line: 50, column: 1, scope: !64, inlinedAt: !116)
!131 = !DILocation(line: 65, column: 2, scope: !110)
!132 = distinct !DISubprogram(name: "xdp_abort_func", scope: !3, file: !3, line: 69, type: !46, scopeLine: 70, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !133)
!133 = !{!134, !135}
!134 = !DILocalVariable(name: "ctx", arg: 1, scope: !132, file: !3, line: 69, type: !49)
!135 = !DILocalVariable(name: "action", scope: !132, file: !3, line: 71, type: !53)
!136 = !DILocation(line: 0, scope: !132)
!137 = !DILocation(line: 0, scope: !64, inlinedAt: !138)
!138 = distinct !DILocation(line: 73, column: 9, scope: !132)
!139 = !DILocation(line: 28, column: 38, scope: !64, inlinedAt: !138)
!140 = !DILocation(line: 29, column: 38, scope: !64, inlinedAt: !138)
!141 = !DILocation(line: 35, column: 24, scope: !64, inlinedAt: !138)
!142 = !DILocation(line: 36, column: 7, scope: !94, inlinedAt: !138)
!143 = !DILocation(line: 36, column: 6, scope: !64, inlinedAt: !138)
!144 = !DILocation(line: 29, column: 27, scope: !64, inlinedAt: !138)
!145 = !DILocation(line: 28, column: 27, scope: !64, inlinedAt: !138)
!146 = !DILocation(line: 40, column: 25, scope: !64, inlinedAt: !138)
!147 = !DILocation(line: 46, column: 7, scope: !64, inlinedAt: !138)
!148 = !DILocation(line: 46, column: 17, scope: !64, inlinedAt: !138)
!149 = !DILocation(line: 47, column: 7, scope: !64, inlinedAt: !138)
!150 = !DILocation(line: 47, column: 16, scope: !64, inlinedAt: !138)
!151 = !DILocation(line: 49, column: 9, scope: !64, inlinedAt: !138)
!152 = !DILocation(line: 50, column: 1, scope: !64, inlinedAt: !138)
!153 = !DILocation(line: 73, column: 2, scope: !132)

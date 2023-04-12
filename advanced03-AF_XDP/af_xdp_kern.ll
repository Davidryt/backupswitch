; ModuleID = 'af_xdp_kern.c'
source_filename = "af_xdp_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xsks_map = dso_local global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 256, i32 0 }, section "maps", align 4, !dbg !0
@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !15
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !25
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_sock_prog(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_sock" !dbg !60 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !72, metadata !DIExpression()), !dbg !76
  %3 = bitcast i32* %2 to i8*, !dbg !77
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !77
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !78
  %5 = load i32, i32* %4, align 4, !dbg !78, !tbaa !79
  call void @llvm.dbg.value(metadata i32 %5, metadata !73, metadata !DIExpression()), !dbg !76
  store i32 %5, i32* %2, align 4, !dbg !84, !tbaa !85
  call void @llvm.dbg.value(metadata i32* %2, metadata !73, metadata !DIExpression(DW_OP_deref)), !dbg !76
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %3) #3, !dbg !86
  %7 = bitcast i8* %6 to i32*, !dbg !86
  call void @llvm.dbg.value(metadata i32* %7, metadata !74, metadata !DIExpression()), !dbg !76
  %8 = icmp eq i8* %6, null, !dbg !87
  br i1 %8, label %16, label %9, !dbg !89

9:                                                ; preds = %1
  %10 = load i32, i32* %7, align 4, !dbg !90, !tbaa !85
  %11 = add i32 %10, 1, !dbg !90
  store i32 %11, i32* %7, align 4, !dbg !90, !tbaa !85
  %12 = and i32 %10, 1, !dbg !93
  %13 = icmp eq i32 %12, 0, !dbg !93
  br i1 %13, label %16, label %14, !dbg !94

14:                                               ; preds = %9
  %15 = call i32 inttoptr (i64 23 to i32 (i32, i64)*)(i32 noundef 9, i64 noundef 0) #3, !dbg !95
  br label %22, !dbg !96

16:                                               ; preds = %9, %1
  call void @llvm.dbg.value(metadata i32* %2, metadata !73, metadata !DIExpression(DW_OP_deref)), !dbg !76
  %17 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* noundef nonnull %3) #3, !dbg !97
  %18 = icmp eq i8* %17, null, !dbg !97
  br i1 %18, label %22, label %19, !dbg !99

19:                                               ; preds = %16
  %20 = load i32, i32* %2, align 4, !dbg !100, !tbaa !85
  call void @llvm.dbg.value(metadata i32 %20, metadata !73, metadata !DIExpression()), !dbg !76
  %21 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i64)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 noundef %20, i64 noundef 0) #3, !dbg !101
  br label %22, !dbg !102

22:                                               ; preds = %16, %19, %14
  %23 = phi i32 [ %15, %14 ], [ %21, %19 ], [ 2, %16 ], !dbg !76
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !103
  ret i32 %23, !dbg !103
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 20, type: !17, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "af_xdp_kern.c", directory: "/home/david/Escritorio/TSN/xdp-tutorial/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "08bf72501f7c7f2cf573c893bd989569")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!0, !15, !25, !31, !40, !50}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 34, type: !17, isLocal: false, isDefinition: true)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !18, line: 33, size: 160, elements: !19)
!18 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!19 = !{!20, !21, !22, !23, !24}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !17, file: !18, line: 34, baseType: !7, size: 32)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !17, file: !18, line: 35, baseType: !7, size: 32, offset: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !17, file: !18, line: 36, baseType: !7, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !17, file: !18, line: 37, baseType: !7, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !17, file: !18, line: 38, baseType: !7, size: 32, offset: 128)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 142, type: !27, isLocal: false, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 32, elements: !29)
!28 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!29 = !{!30}
!30 = !DISubrange(count: 4)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !33, line: 33, type: !34, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/advanced03-AF_XDP", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DISubroutineType(types: !36)
!36 = !{!37, !37, !38}
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "bpf_redirect", scope: !2, file: !33, line: 589, type: !42, isLocal: true, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DISubroutineType(types: !44)
!44 = !{!45, !46, !48}
!45 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!47 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !49)
!49 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !33, line: 1254, type: !52, isLocal: true, isDefinition: true)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = !DISubroutineType(types: !54)
!54 = !{!45, !37, !46, !48}
!55 = !{i32 7, !"Dwarf Version", i32 5}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = !{i32 1, !"wchar_size", i32 4}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!60 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 42, type: !61, scopeLine: 43, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !71)
!61 = !DISubroutineType(types: !62)
!62 = !{!45, !63}
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !65)
!65 = !{!66, !67, !68, !69, !70}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !64, file: !6, line: 2857, baseType: !46, size: 32)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !64, file: !6, line: 2858, baseType: !46, size: 32, offset: 32)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !64, file: !6, line: 2859, baseType: !46, size: 32, offset: 64)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !64, file: !6, line: 2861, baseType: !46, size: 32, offset: 96)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !64, file: !6, line: 2862, baseType: !46, size: 32, offset: 128)
!71 = !{!72, !73, !74}
!72 = !DILocalVariable(name: "ctx", arg: 1, scope: !60, file: !3, line: 42, type: !63)
!73 = !DILocalVariable(name: "index", scope: !60, file: !3, line: 44, type: !45)
!74 = !DILocalVariable(name: "pkt_count", scope: !60, file: !3, line: 45, type: !75)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!76 = !DILocation(line: 0, scope: !60)
!77 = !DILocation(line: 44, column: 5, scope: !60)
!78 = !DILocation(line: 44, column: 22, scope: !60)
!79 = !{!80, !81, i64 16}
!80 = !{!"xdp_md", !81, i64 0, !81, i64 4, !81, i64 8, !81, i64 12, !81, i64 16}
!81 = !{!"int", !82, i64 0}
!82 = !{!"omnipotent char", !83, i64 0}
!83 = !{!"Simple C/C++ TBAA"}
!84 = !DILocation(line: 44, column: 9, scope: !60)
!85 = !{!81, !81, i64 0}
!86 = !DILocation(line: 47, column: 17, scope: !60)
!87 = !DILocation(line: 48, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !60, file: !3, line: 48, column: 9)
!89 = !DILocation(line: 48, column: 9, scope: !60)
!90 = !DILocation(line: 51, column: 25, scope: !91)
!91 = distinct !DILexicalBlock(scope: !92, file: !3, line: 51, column: 13)
!92 = distinct !DILexicalBlock(scope: !88, file: !3, line: 48, column: 20)
!93 = !DILocation(line: 51, column: 28, scope: !91)
!94 = !DILocation(line: 51, column: 13, scope: !92)
!95 = !DILocation(line: 52, column: 20, scope: !91)
!96 = !DILocation(line: 52, column: 13, scope: !91)
!97 = !DILocation(line: 57, column: 9, scope: !98)
!98 = distinct !DILexicalBlock(scope: !60, file: !3, line: 57, column: 9)
!99 = !DILocation(line: 57, column: 9, scope: !60)
!100 = !DILocation(line: 58, column: 44, scope: !98)
!101 = !DILocation(line: 58, column: 16, scope: !98)
!102 = !DILocation(line: 58, column: 9, scope: !98)
!103 = !DILocation(line: 61, column: 1, scope: !60)

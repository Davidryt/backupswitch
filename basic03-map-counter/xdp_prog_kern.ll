; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !18
@llvm.compiler.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_stats1_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_stats1_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_stats1" !dbg !45 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !60, metadata !DIExpression()), !dbg !74
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !75
  %4 = load i32, i32* %3, align 4, !dbg !75, !tbaa !76
  call void @llvm.dbg.value(metadata i32 %4, metadata !61, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !74
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !81
  %6 = load i32, i32* %5, align 4, !dbg !81, !tbaa !82
  call void @llvm.dbg.value(metadata i32 %6, metadata !62, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !74
  %7 = bitcast i32* %2 to i8*, !dbg !83
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %7) #3, !dbg !83
  call void @llvm.dbg.value(metadata i32 2, metadata !72, metadata !DIExpression()), !dbg !74
  store i32 2, i32* %2, align 4, !dbg !84, !tbaa !85
  call void @llvm.dbg.value(metadata i32* %2, metadata !72, metadata !DIExpression(DW_OP_deref)), !dbg !74
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %7) #3, !dbg !86
  call void @llvm.dbg.value(metadata i8* %8, metadata !63, metadata !DIExpression()), !dbg !74
  %9 = icmp eq i8* %8, null, !dbg !87
  br i1 %9, label %19, label %10, !dbg !89

10:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %8, metadata !63, metadata !DIExpression()), !dbg !74
  %11 = zext i32 %6 to i64, !dbg !90
  call void @llvm.dbg.value(metadata i64 %11, metadata !62, metadata !DIExpression()), !dbg !74
  %12 = zext i32 %4 to i64, !dbg !91
  call void @llvm.dbg.value(metadata i64 %12, metadata !61, metadata !DIExpression()), !dbg !74
  %13 = bitcast i8* %8 to i64*, !dbg !92
  %14 = atomicrmw add i64* %13, i64 1 seq_cst, align 8, !dbg !92
  %15 = sub nsw i64 %12, %11, !dbg !93
  call void @llvm.dbg.value(metadata i64 %15, metadata !73, metadata !DIExpression()), !dbg !74
  %16 = getelementptr inbounds i8, i8* %8, i64 8, !dbg !94
  %17 = bitcast i8* %16 to i64*, !dbg !94
  %18 = atomicrmw add i64* %17, i64 %15 seq_cst, align 8, !dbg !94
  br label %19

19:                                               ; preds = %1, %10
  %20 = phi i32 [ 2, %10 ], [ 0, %1 ], !dbg !74
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %7) #3, !dbg !95
  ret i32 %20, !dbg !95
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
!llvm.module.flags = !{!40, !41, !42, !43}
!llvm.ident = !{!44}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 11, type: !32, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic03-map-counter", checksumkind: CSK_MD5, checksum: "6ea9073dd42f3820f25ac7f38a1ee37b")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic03-map-counter", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
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
!19 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 60, type: !20, isLocal: false, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 32, elements: !22)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!22 = !{!23}
!23 = !DISubrange(count: 4)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !26, line: 33, type: !27, isLocal: true, isDefinition: true)
!26 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic03-map-counter", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!28 = !DISubroutineType(types: !29)
!29 = !{!15, !15, !30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !33, line: 33, size: 160, elements: !34)
!33 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic03-map-counter", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
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
!45 = distinct !DISubprogram(name: "xdp_stats1_func", scope: !3, file: !3, line: 27, type: !46, scopeLine: 28, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !59)
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
!59 = !{!60, !61, !62, !63, !72, !73}
!60 = !DILocalVariable(name: "ctx", arg: 1, scope: !45, file: !3, line: 27, type: !49)
!61 = !DILocalVariable(name: "data_end", scope: !45, file: !3, line: 29, type: !15)
!62 = !DILocalVariable(name: "data", scope: !45, file: !3, line: 30, type: !15)
!63 = !DILocalVariable(name: "rec", scope: !45, file: !3, line: 31, type: !64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !66, line: 8, size: 128, elements: !67)
!66 = !DIFile(filename: "./common_kern_user.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic03-map-counter", checksumkind: CSK_MD5, checksum: "304373711f8ffaafd973b84a115f3a3e")
!67 = !{!68, !71}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !65, file: !66, line: 9, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !54, line: 31, baseType: !70)
!70 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !65, file: !66, line: 11, baseType: !69, size: 64, offset: 64)
!72 = !DILocalVariable(name: "key", scope: !45, file: !3, line: 32, type: !53)
!73 = !DILocalVariable(name: "bytes", scope: !45, file: !3, line: 50, type: !69)
!74 = !DILocation(line: 0, scope: !45)
!75 = !DILocation(line: 29, column: 38, scope: !45)
!76 = !{!77, !78, i64 4}
!77 = !{!"xdp_md", !78, i64 0, !78, i64 4, !78, i64 8, !78, i64 12, !78, i64 16}
!78 = !{!"int", !79, i64 0}
!79 = !{!"omnipotent char", !80, i64 0}
!80 = !{!"Simple C/C++ TBAA"}
!81 = !DILocation(line: 30, column: 38, scope: !45)
!82 = !{!77, !78, i64 0}
!83 = !DILocation(line: 32, column: 2, scope: !45)
!84 = !DILocation(line: 32, column: 8, scope: !45)
!85 = !{!78, !78, i64 0}
!86 = !DILocation(line: 35, column: 8, scope: !45)
!87 = !DILocation(line: 40, column: 7, scope: !88)
!88 = distinct !DILexicalBlock(scope: !45, file: !3, line: 40, column: 6)
!89 = !DILocation(line: 40, column: 6, scope: !45)
!90 = !DILocation(line: 30, column: 27, scope: !45)
!91 = !DILocation(line: 29, column: 27, scope: !45)
!92 = !DILocation(line: 46, column: 2, scope: !45)
!93 = !DILocation(line: 50, column: 32, scope: !45)
!94 = !DILocation(line: 51, column: 2, scope: !45)
!95 = !DILocation(line: 58, column: 1, scope: !45)

; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_abort_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_drop_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*)], section "llvm.metadata"

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readnone %0) #0 section "xdp_pass" !dbg !24 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !39, metadata !DIExpression()), !dbg !40
  ret i32 2, !dbg !41
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define dso_local i32 @xdp_drop_func(%struct.xdp_md* nocapture readnone %0) #0 section "xdp_drop" !dbg !42 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !44, metadata !DIExpression()), !dbg !45
  ret i32 1, !dbg !46
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define dso_local i32 @xdp_abort_func(%struct.xdp_md* nocapture readnone %0) #0 section "xdp_abort" !dbg !47 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !49, metadata !DIExpression()), !dbg !50
  ret i32 0, !dbg !51
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { mustprogress nofree norecurse nosync nounwind readnone willreturn "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!19, !20, !21, !22}
!llvm.ident = !{!23}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 37, type: !15, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic02-prog-by-name", checksumkind: CSK_MD5, checksum: "63f4c18f46e8b38b54a6cd43d88416a0")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/basic02-prog-by-name", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!0}
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 32, elements: !17)
!16 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!17 = !{!18}
!18 = !DISubrange(count: 4)
!19 = !{i32 7, !"Dwarf Version", i32 5}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{i32 7, !"frame-pointer", i32 2}
!23 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!24 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 18, type: !25, scopeLine: 19, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !38)
!25 = !DISubroutineType(types: !26)
!26 = !{!27, !28}
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !30)
!30 = !{!31, !34, !35, !36, !37}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !29, file: !6, line: 2857, baseType: !32, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !33, line: 27, baseType: !7)
!33 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!34 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !29, file: !6, line: 2858, baseType: !32, size: 32, offset: 32)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !29, file: !6, line: 2859, baseType: !32, size: 32, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !29, file: !6, line: 2861, baseType: !32, size: 32, offset: 96)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !29, file: !6, line: 2862, baseType: !32, size: 32, offset: 128)
!38 = !{!39}
!39 = !DILocalVariable(name: "ctx", arg: 1, scope: !24, file: !3, line: 18, type: !28)
!40 = !DILocation(line: 0, scope: !24)
!41 = !DILocation(line: 20, column: 2, scope: !24)
!42 = distinct !DISubprogram(name: "xdp_drop_func", scope: !3, file: !3, line: 24, type: !25, scopeLine: 25, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !43)
!43 = !{!44}
!44 = !DILocalVariable(name: "ctx", arg: 1, scope: !42, file: !3, line: 24, type: !28)
!45 = !DILocation(line: 0, scope: !42)
!46 = !DILocation(line: 26, column: 2, scope: !42)
!47 = distinct !DISubprogram(name: "xdp_abort_func", scope: !3, file: !3, line: 32, type: !25, scopeLine: 33, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !48)
!48 = !{!49}
!49 = !DILocalVariable(name: "ctx", arg: 1, scope: !47, file: !3, line: 32, type: !28)
!50 = !DILocation(line: 0, scope: !47)
!51 = !DILocation(line: 34, column: 2, scope: !47)

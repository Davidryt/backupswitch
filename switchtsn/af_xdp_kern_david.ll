; ModuleID = 'af_xdp_kern_david.c'
source_filename = "af_xdp_kern_david.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xsks_map = dso_local global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !0
@qidconf_map = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !15
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !25
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @qidconf_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_vxlan_redirect to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define dso_local i32 @xdp_vxlan_redirect(%struct.xdp_md* nocapture readnone %0) #0 section "xdp_sock" !dbg !105 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !119, metadata !DIExpression()), !dbg !120
  ret i32 1, !dbg !121
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { mustprogress nofree norecurse nosync nounwind readnone willreturn "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!100, !101, !102, !103}
!llvm.ident = !{!104}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 29, type: !17, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "af_xdp_kern_david.c", directory: "/home/david/Escritorio/TSN/xdp-david/switchtsn", checksumkind: CSK_MD5, checksum: "053aa3177b4df128e7baffbfd52f9703")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/david/Escritorio/TSN/xdp-david/switchtsn", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!0, !15, !25, !31, !98}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "qidconf_map", scope: !2, file: !3, line: 36, type: !17, isLocal: false, isDefinition: true)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !18, line: 33, size: 160, elements: !19)
!18 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-david/switchtsn", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!19 = !{!20, !21, !22, !23, !24}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !17, file: !18, line: 34, baseType: !7, size: 32)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !17, file: !18, line: 35, baseType: !7, size: 32, offset: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !17, file: !18, line: 36, baseType: !7, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !17, file: !18, line: 37, baseType: !7, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !17, file: !18, line: 38, baseType: !7, size: 32, offset: 128)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 158, type: !27, isLocal: false, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 32, elements: !29)
!28 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!29 = !{!30}
!30 = !DISubrange(count: 4)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "stdin", scope: !2, file: !33, line: 143, type: !34, isLocal: false, isDefinition: false)
!33 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "f31eefcc3f15835fc5a4023a625cf609")
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !36, line: 7, baseType: !37)
!36 = !DIFile(filename: "/usr/include/bits/types/FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "571f9fb6223c42439075fdde11a0de5d")
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !38, line: 49, size: 1728, elements: !39)
!38 = !DIFile(filename: "/usr/include/bits/types/struct_FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "1bad07471b7974df4ecc1d1c2ca207e6")
!39 = !{!40, !42, !44, !45, !46, !47, !48, !49, !50, !51, !52, !53, !54, !57, !59, !60, !61, !65, !67, !69, !73, !76, !80, !83, !86, !87, !89, !93, !94}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !37, file: !38, line: 51, baseType: !41, size: 32)
!41 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !37, file: !38, line: 54, baseType: !43, size: 64, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !37, file: !38, line: 55, baseType: !43, size: 64, offset: 128)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !37, file: !38, line: 56, baseType: !43, size: 64, offset: 192)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !37, file: !38, line: 57, baseType: !43, size: 64, offset: 256)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !37, file: !38, line: 58, baseType: !43, size: 64, offset: 320)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !37, file: !38, line: 59, baseType: !43, size: 64, offset: 384)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !37, file: !38, line: 60, baseType: !43, size: 64, offset: 448)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !37, file: !38, line: 61, baseType: !43, size: 64, offset: 512)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !37, file: !38, line: 64, baseType: !43, size: 64, offset: 576)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !37, file: !38, line: 65, baseType: !43, size: 64, offset: 640)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !37, file: !38, line: 66, baseType: !43, size: 64, offset: 704)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !37, file: !38, line: 68, baseType: !55, size: 64, offset: 768)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !38, line: 36, flags: DIFlagFwdDecl)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !37, file: !38, line: 70, baseType: !58, size: 64, offset: 832)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !37, file: !38, line: 72, baseType: !41, size: 32, offset: 896)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !37, file: !38, line: 73, baseType: !41, size: 32, offset: 928)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !37, file: !38, line: 74, baseType: !62, size: 64, offset: 960)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !63, line: 152, baseType: !64)
!63 = !DIFile(filename: "/usr/include/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!64 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !37, file: !38, line: 77, baseType: !66, size: 16, offset: 1024)
!66 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !37, file: !38, line: 78, baseType: !68, size: 8, offset: 1040)
!68 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !37, file: !38, line: 79, baseType: !70, size: 8, offset: 1048)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 8, elements: !71)
!71 = !{!72}
!72 = !DISubrange(count: 1)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !37, file: !38, line: 81, baseType: !74, size: 64, offset: 1088)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !38, line: 43, baseType: null)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !37, file: !38, line: 89, baseType: !77, size: 64, offset: 1152)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !63, line: 153, baseType: !78)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !63, line: 47, baseType: !79)
!79 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !37, file: !38, line: 91, baseType: !81, size: 64, offset: 1216)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !38, line: 37, flags: DIFlagFwdDecl)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !37, file: !38, line: 92, baseType: !84, size: 64, offset: 1280)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !38, line: 38, flags: DIFlagFwdDecl)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !37, file: !38, line: 93, baseType: !58, size: 64, offset: 1344)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !37, file: !38, line: 94, baseType: !88, size: 64, offset: 1408)
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !37, file: !38, line: 95, baseType: !90, size: 64, offset: 1472)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !91, line: 46, baseType: !92)
!91 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!92 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !37, file: !38, line: 96, baseType: !41, size: 32, offset: 1536)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !37, file: !38, line: 98, baseType: !95, size: 160, offset: 1568)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 160, elements: !96)
!96 = !{!97}
!97 = !DISubrange(count: 20)
!98 = !DIGlobalVariableExpression(var: !99, expr: !DIExpression())
!99 = distinct !DIGlobalVariable(name: "stdout", scope: !2, file: !33, line: 144, type: !34, isLocal: false, isDefinition: false)
!100 = !{i32 7, !"Dwarf Version", i32 5}
!101 = !{i32 2, !"Debug Info Version", i32 3}
!102 = !{i32 1, !"wchar_size", i32 4}
!103 = !{i32 7, !"frame-pointer", i32 2}
!104 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!105 = distinct !DISubprogram(name: "xdp_vxlan_redirect", scope: !3, file: !3, line: 51, type: !106, scopeLine: 52, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !118)
!106 = !DISubroutineType(types: !107)
!107 = !{!41, !108}
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !110)
!110 = !{!111, !114, !115, !116, !117}
!111 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !109, file: !6, line: 2857, baseType: !112, size: 32)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !113, line: 27, baseType: !7)
!113 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!114 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !109, file: !6, line: 2858, baseType: !112, size: 32, offset: 32)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !109, file: !6, line: 2859, baseType: !112, size: 32, offset: 64)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !109, file: !6, line: 2861, baseType: !112, size: 32, offset: 96)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !109, file: !6, line: 2862, baseType: !112, size: 32, offset: 128)
!118 = !{!119}
!119 = !DILocalVariable(name: "ctx", arg: 1, scope: !105, file: !3, line: 51, type: !108)
!120 = !DILocation(line: 0, scope: !105)
!121 = !DILocation(line: 54, column: 2, scope: !105)

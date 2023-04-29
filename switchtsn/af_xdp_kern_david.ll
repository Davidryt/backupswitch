; ModuleID = 'af_xdp_kern_david.c'
source_filename = "af_xdp_kern_david.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@xsks_map = dso_local global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !0
@qidconf_map = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !21
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !31
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @qidconf_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_vxlan_redirect to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_vxlan_redirect(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_sock" !dbg !124 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !136, metadata !DIExpression()), !dbg !159
  %3 = bitcast i32* %2 to i8*, !dbg !160
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !160
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !161
  %5 = load i32, i32* %4, align 4, !dbg !161, !tbaa !162
  call void @llvm.dbg.value(metadata i32 %5, metadata !139, metadata !DIExpression()), !dbg !159
  store i32 %5, i32* %2, align 4, !dbg !167, !tbaa !168
  call void @llvm.dbg.value(metadata i32* %2, metadata !139, metadata !DIExpression(DW_OP_deref)), !dbg !159
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @qidconf_map to i8*), i8* noundef nonnull %3) #3, !dbg !169
  call void @llvm.dbg.value(metadata i8* %6, metadata !137, metadata !DIExpression()), !dbg !159
  %7 = icmp eq i8* %6, null, !dbg !170
  br i1 %7, label %26, label %8, !dbg !171

8:                                                ; preds = %1
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !172
  %10 = load i32, i32* %9, align 4, !dbg !172, !tbaa !173
  %11 = zext i32 %10 to i64, !dbg !174
  %12 = inttoptr i64 %11 to i8*, !dbg !175
  call void @llvm.dbg.value(metadata i8* %12, metadata !140, metadata !DIExpression()), !dbg !176
  %13 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !177
  %14 = load i32, i32* %13, align 4, !dbg !177, !tbaa !178
  %15 = zext i32 %14 to i64, !dbg !179
  %16 = inttoptr i64 %15 to i8*, !dbg !180
  call void @llvm.dbg.value(metadata i8* %16, metadata !143, metadata !DIExpression()), !dbg !176
  %17 = inttoptr i64 %11 to %struct.ethhdr*, !dbg !181
  call void @llvm.dbg.value(metadata %struct.ethhdr* %17, metadata !144, metadata !DIExpression()), !dbg !176
  %18 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %17, i64 0, i32 2, !dbg !182
  %19 = load i16, i16* %18, align 1, !dbg !182, !tbaa !183
  call void @llvm.dbg.value(metadata i16 %19, metadata !158, metadata !DIExpression()), !dbg !176
  %20 = getelementptr i8, i8* %12, i64 14, !dbg !186
  %21 = icmp ule i8* %20, %16, !dbg !188
  %22 = icmp eq i16 %19, 8
  %23 = select i1 %21, i1 %22, i1 false, !dbg !189
  br i1 %23, label %24, label %26, !dbg !189

24:                                               ; preds = %8
  %25 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i64)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 noundef 11, i64 noundef 0) #3, !dbg !190
  br label %26

26:                                               ; preds = %1, %8, %24
  %27 = phi i32 [ %25, %24 ], [ 1, %8 ], [ 1, %1 ], !dbg !159
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !194
  ret i32 %27, !dbg !194
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
!llvm.module.flags = !{!119, !120, !121, !122}
!llvm.ident = !{!123}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 29, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "af_xdp_kern_david.c", directory: "/home/david/Escritorio/TSN/xdp-david/switchtsn", checksumkind: CSK_MD5, checksum: "c9e296de323e437c2eff156d829a400f")
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
!14 = !{!15, !16, !17}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !18, line: 24, baseType: !19)
!18 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!19 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!20 = !{!0, !21, !31, !37, !101, !103, !111}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "qidconf_map", scope: !2, file: !3, line: 36, type: !23, isLocal: false, isDefinition: true)
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !24, line: 33, size: 160, elements: !25)
!24 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-david/switchtsn", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!25 = !{!26, !27, !28, !29, !30}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !23, file: !24, line: 34, baseType: !7, size: 32)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !23, file: !24, line: 35, baseType: !7, size: 32, offset: 32)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !23, file: !24, line: 36, baseType: !7, size: 32, offset: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !23, file: !24, line: 37, baseType: !7, size: 32, offset: 96)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !23, file: !24, line: 38, baseType: !7, size: 32, offset: 128)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 186, type: !33, isLocal: false, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 32, elements: !35)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 4)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "stdin", scope: !2, file: !39, line: 143, type: !40, isLocal: false, isDefinition: false)
!39 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "f31eefcc3f15835fc5a4023a625cf609")
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !42, line: 7, baseType: !43)
!42 = !DIFile(filename: "/usr/include/bits/types/FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "571f9fb6223c42439075fdde11a0de5d")
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !44, line: 49, size: 1728, elements: !45)
!44 = !DIFile(filename: "/usr/include/bits/types/struct_FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "1bad07471b7974df4ecc1d1c2ca207e6")
!45 = !{!46, !48, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !63, !65, !66, !67, !70, !71, !73, !77, !80, !84, !87, !90, !91, !92, !96, !97}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !43, file: !44, line: 51, baseType: !47, size: 32)
!47 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !43, file: !44, line: 54, baseType: !49, size: 64, offset: 64)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !43, file: !44, line: 55, baseType: !49, size: 64, offset: 128)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !43, file: !44, line: 56, baseType: !49, size: 64, offset: 192)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !43, file: !44, line: 57, baseType: !49, size: 64, offset: 256)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !43, file: !44, line: 58, baseType: !49, size: 64, offset: 320)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !43, file: !44, line: 59, baseType: !49, size: 64, offset: 384)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !43, file: !44, line: 60, baseType: !49, size: 64, offset: 448)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !43, file: !44, line: 61, baseType: !49, size: 64, offset: 512)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !43, file: !44, line: 64, baseType: !49, size: 64, offset: 576)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !43, file: !44, line: 65, baseType: !49, size: 64, offset: 640)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !43, file: !44, line: 66, baseType: !49, size: 64, offset: 704)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !43, file: !44, line: 68, baseType: !61, size: 64, offset: 768)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !44, line: 36, flags: DIFlagFwdDecl)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !43, file: !44, line: 70, baseType: !64, size: 64, offset: 832)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !43, file: !44, line: 72, baseType: !47, size: 32, offset: 896)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !43, file: !44, line: 73, baseType: !47, size: 32, offset: 928)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !43, file: !44, line: 74, baseType: !68, size: 64, offset: 960)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !69, line: 152, baseType: !16)
!69 = !DIFile(filename: "/usr/include/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !43, file: !44, line: 77, baseType: !19, size: 16, offset: 1024)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !43, file: !44, line: 78, baseType: !72, size: 8, offset: 1040)
!72 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !43, file: !44, line: 79, baseType: !74, size: 8, offset: 1048)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 8, elements: !75)
!75 = !{!76}
!76 = !DISubrange(count: 1)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !43, file: !44, line: 81, baseType: !78, size: 64, offset: 1088)
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !44, line: 43, baseType: null)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !43, file: !44, line: 89, baseType: !81, size: 64, offset: 1152)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !69, line: 153, baseType: !82)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !69, line: 47, baseType: !83)
!83 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !43, file: !44, line: 91, baseType: !85, size: 64, offset: 1216)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !44, line: 37, flags: DIFlagFwdDecl)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !43, file: !44, line: 92, baseType: !88, size: 64, offset: 1280)
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !44, line: 38, flags: DIFlagFwdDecl)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !43, file: !44, line: 93, baseType: !64, size: 64, offset: 1344)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !43, file: !44, line: 94, baseType: !15, size: 64, offset: 1408)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !43, file: !44, line: 95, baseType: !93, size: 64, offset: 1472)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !94, line: 46, baseType: !95)
!94 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!95 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !43, file: !44, line: 96, baseType: !47, size: 32, offset: 1536)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !43, file: !44, line: 98, baseType: !98, size: 160, offset: 1568)
!98 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 160, elements: !99)
!99 = !{!100}
!100 = !DISubrange(count: 20)
!101 = !DIGlobalVariableExpression(var: !102, expr: !DIExpression())
!102 = distinct !DIGlobalVariable(name: "stdout", scope: !2, file: !39, line: 144, type: !40, isLocal: false, isDefinition: false)
!103 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression())
!104 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !105, line: 33, type: !106, isLocal: true, isDefinition: true)
!105 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/david/Escritorio/TSN/xdp-david/switchtsn", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = !DISubroutineType(types: !108)
!108 = !{!15, !15, !109}
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!111 = !DIGlobalVariableExpression(var: !112, expr: !DIExpression())
!112 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !105, line: 1254, type: !113, isLocal: true, isDefinition: true)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = !DISubroutineType(types: !115)
!115 = !{!47, !15, !116, !117}
!116 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !18, line: 27, baseType: !7)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !18, line: 31, baseType: !118)
!118 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!119 = !{i32 7, !"Dwarf Version", i32 5}
!120 = !{i32 2, !"Debug Info Version", i32 3}
!121 = !{i32 1, !"wchar_size", i32 4}
!122 = !{i32 7, !"frame-pointer", i32 2}
!123 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!124 = distinct !DISubprogram(name: "xdp_vxlan_redirect", scope: !3, file: !3, line: 51, type: !125, scopeLine: 52, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !135)
!125 = !DISubroutineType(types: !126)
!126 = !{!47, !127}
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !129)
!129 = !{!130, !131, !132, !133, !134}
!130 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !128, file: !6, line: 2857, baseType: !116, size: 32)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !128, file: !6, line: 2858, baseType: !116, size: 32, offset: 32)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !128, file: !6, line: 2859, baseType: !116, size: 32, offset: 64)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !128, file: !6, line: 2861, baseType: !116, size: 32, offset: 96)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !128, file: !6, line: 2862, baseType: !116, size: 32, offset: 128)
!135 = !{!136, !137, !139, !140, !143, !144, !158}
!136 = !DILocalVariable(name: "ctx", arg: 1, scope: !124, file: !3, line: 51, type: !127)
!137 = !DILocalVariable(name: "qidconf", scope: !124, file: !3, line: 53, type: !138)
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!139 = !DILocalVariable(name: "index", scope: !124, file: !3, line: 53, type: !47)
!140 = !DILocalVariable(name: "data", scope: !141, file: !3, line: 60, type: !15)
!141 = distinct !DILexicalBlock(scope: !142, file: !3, line: 59, column: 2)
!142 = distinct !DILexicalBlock(scope: !124, file: !3, line: 58, column: 6)
!143 = !DILocalVariable(name: "data_end", scope: !141, file: !3, line: 61, type: !15)
!144 = !DILocalVariable(name: "eth", scope: !141, file: !3, line: 63, type: !145)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !147, line: 168, size: 112, elements: !148)
!147 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!148 = !{!149, !154, !155}
!149 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !146, file: !147, line: 169, baseType: !150, size: 48)
!150 = !DICompositeType(tag: DW_TAG_array_type, baseType: !151, size: 48, elements: !152)
!151 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!152 = !{!153}
!153 = !DISubrange(count: 6)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !146, file: !147, line: 170, baseType: !150, size: 48, offset: 48)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !146, file: !147, line: 171, baseType: !156, size: 16, offset: 96)
!156 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !157, line: 25, baseType: !17)
!157 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!158 = !DILocalVariable(name: "h_proto", scope: !141, file: !3, line: 64, type: !17)
!159 = !DILocation(line: 0, scope: !124)
!160 = !DILocation(line: 53, column: 2, scope: !124)
!161 = !DILocation(line: 53, column: 29, scope: !124)
!162 = !{!163, !164, i64 16}
!163 = !{!"xdp_md", !164, i64 0, !164, i64 4, !164, i64 8, !164, i64 12, !164, i64 16}
!164 = !{!"int", !165, i64 0}
!165 = !{!"omnipotent char", !166, i64 0}
!166 = !{!"Simple C/C++ TBAA"}
!167 = !DILocation(line: 53, column: 16, scope: !124)
!168 = !{!164, !164, i64 0}
!169 = !DILocation(line: 56, column: 12, scope: !124)
!170 = !DILocation(line: 58, column: 6, scope: !142)
!171 = !DILocation(line: 58, column: 6, scope: !124)
!172 = !DILocation(line: 60, column: 34, scope: !141)
!173 = !{!163, !164, i64 0}
!174 = !DILocation(line: 60, column: 23, scope: !141)
!175 = !DILocation(line: 60, column: 16, scope: !141)
!176 = !DILocation(line: 0, scope: !141)
!177 = !DILocation(line: 61, column: 38, scope: !141)
!178 = !{!163, !164, i64 4}
!179 = !DILocation(line: 61, column: 27, scope: !141)
!180 = !DILocation(line: 61, column: 20, scope: !141)
!181 = !DILocation(line: 63, column: 24, scope: !141)
!182 = !DILocation(line: 64, column: 24, scope: !141)
!183 = !{!184, !185, i64 12}
!184 = !{!"ethhdr", !165, i64 0, !165, i64 6, !185, i64 12}
!185 = !{!"short", !165, i64 0}
!186 = !DILocation(line: 65, column: 18, scope: !187)
!187 = distinct !DILexicalBlock(scope: !141, file: !3, line: 65, column: 7)
!188 = !DILocation(line: 65, column: 33, scope: !187)
!189 = !DILocation(line: 65, column: 7, scope: !141)
!190 = !DILocation(line: 73, column: 16, scope: !191)
!191 = distinct !DILexicalBlock(scope: !192, file: !3, line: 66, column: 39)
!192 = distinct !DILexicalBlock(scope: !193, file: !3, line: 66, column: 8)
!193 = distinct !DILexicalBlock(scope: !187, file: !3, line: 65, column: 46)
!194 = !DILocation(line: 83, column: 1, scope: !124)

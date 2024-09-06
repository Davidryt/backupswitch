; ModuleID = 'af_xdp_kern_david.c'
source_filename = "af_xdp_kern_david.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xsks_map = dso_local global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !0
@qidconf_map = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !15
@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !25
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !27
@llvm.compiler.used = appending global [5 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @qidconf_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_sock_prog(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_sock" !dbg !129 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !141, metadata !DIExpression()), !dbg !145
  %3 = bitcast i32* %2 to i8*, !dbg !146
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !146
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !147
  %5 = load i32, i32* %4, align 4, !dbg !147, !tbaa !148
  call void @llvm.dbg.value(metadata i32 %5, metadata !142, metadata !DIExpression()), !dbg !145
  store i32 %5, i32* %2, align 4, !dbg !153, !tbaa !154
  call void @llvm.dbg.value(metadata i32* %2, metadata !142, metadata !DIExpression(DW_OP_deref)), !dbg !145
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %3) #3, !dbg !155
  %7 = bitcast i8* %6 to i32*, !dbg !155
  call void @llvm.dbg.value(metadata i32* %7, metadata !143, metadata !DIExpression()), !dbg !145
  %8 = icmp eq i8* %6, null, !dbg !156
  br i1 %8, label %16, label %9, !dbg !158

9:                                                ; preds = %1
  %10 = load i32, i32* %7, align 4, !dbg !159, !tbaa !154
  %11 = add i32 %10, 1, !dbg !159
  store i32 %11, i32* %7, align 4, !dbg !159, !tbaa !154
  %12 = and i32 %10, 1, !dbg !162
  %13 = icmp eq i32 %12, 0, !dbg !162
  br i1 %13, label %16, label %14, !dbg !163

14:                                               ; preds = %9
  %15 = call i32 inttoptr (i64 23 to i32 (i32, i64)*)(i32 noundef 9, i64 noundef 0) #3, !dbg !164
  br label %22, !dbg !165

16:                                               ; preds = %9, %1
  call void @llvm.dbg.value(metadata i32* %2, metadata !142, metadata !DIExpression(DW_OP_deref)), !dbg !145
  %17 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* noundef nonnull %3) #3, !dbg !166
  %18 = icmp eq i8* %17, null, !dbg !166
  br i1 %18, label %22, label %19, !dbg !168

19:                                               ; preds = %16
  %20 = load i32, i32* %2, align 4, !dbg !169, !tbaa !154
  call void @llvm.dbg.value(metadata i32 %20, metadata !142, metadata !DIExpression()), !dbg !145
  %21 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i64)*)(i8* noundef bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 noundef %20, i64 noundef 0) #3, !dbg !170
  br label %22, !dbg !171

22:                                               ; preds = %16, %19, %14
  %23 = phi i32 [ %15, %14 ], [ %21, %19 ], [ 2, %16 ], !dbg !145
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !172
  ret i32 %23, !dbg !172
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
!llvm.module.flags = !{!124, !125, !126, !127}
!llvm.ident = !{!128}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 29, type: !17, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "af_xdp_kern_david.c", directory: "/home/david/Escritorio/TSN/xdp-david/switchtsn", checksumkind: CSK_MD5, checksum: "93f591510301e7c82ba3852ee68cf8d0")
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
!14 = !{!0, !15, !25, !27, !33, !100, !102, !110, !119}
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
!26 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 50, type: !17, isLocal: false, isDefinition: true)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 193, type: !29, isLocal: false, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 32, elements: !31)
!30 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!31 = !{!32}
!32 = !DISubrange(count: 4)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "stdin", scope: !2, file: !35, line: 143, type: !36, isLocal: false, isDefinition: false)
!35 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "f31eefcc3f15835fc5a4023a625cf609")
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !38, line: 7, baseType: !39)
!38 = !DIFile(filename: "/usr/include/bits/types/FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "571f9fb6223c42439075fdde11a0de5d")
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !40, line: 49, size: 1728, elements: !41)
!40 = !DIFile(filename: "/usr/include/bits/types/struct_FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "1bad07471b7974df4ecc1d1c2ca207e6")
!41 = !{!42, !44, !46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !59, !61, !62, !63, !67, !69, !71, !75, !78, !82, !85, !88, !89, !91, !95, !96}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !39, file: !40, line: 51, baseType: !43, size: 32)
!43 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !39, file: !40, line: 54, baseType: !45, size: 64, offset: 64)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !39, file: !40, line: 55, baseType: !45, size: 64, offset: 128)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !39, file: !40, line: 56, baseType: !45, size: 64, offset: 192)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !39, file: !40, line: 57, baseType: !45, size: 64, offset: 256)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !39, file: !40, line: 58, baseType: !45, size: 64, offset: 320)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !39, file: !40, line: 59, baseType: !45, size: 64, offset: 384)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !39, file: !40, line: 60, baseType: !45, size: 64, offset: 448)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !39, file: !40, line: 61, baseType: !45, size: 64, offset: 512)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !39, file: !40, line: 64, baseType: !45, size: 64, offset: 576)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !39, file: !40, line: 65, baseType: !45, size: 64, offset: 640)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !39, file: !40, line: 66, baseType: !45, size: 64, offset: 704)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !39, file: !40, line: 68, baseType: !57, size: 64, offset: 768)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !40, line: 36, flags: DIFlagFwdDecl)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !39, file: !40, line: 70, baseType: !60, size: 64, offset: 832)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !39, file: !40, line: 72, baseType: !43, size: 32, offset: 896)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !39, file: !40, line: 73, baseType: !43, size: 32, offset: 928)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !39, file: !40, line: 74, baseType: !64, size: 64, offset: 960)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !65, line: 152, baseType: !66)
!65 = !DIFile(filename: "/usr/include/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!66 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !39, file: !40, line: 77, baseType: !68, size: 16, offset: 1024)
!68 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !39, file: !40, line: 78, baseType: !70, size: 8, offset: 1040)
!70 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !39, file: !40, line: 79, baseType: !72, size: 8, offset: 1048)
!72 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 8, elements: !73)
!73 = !{!74}
!74 = !DISubrange(count: 1)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !39, file: !40, line: 81, baseType: !76, size: 64, offset: 1088)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !40, line: 43, baseType: null)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !39, file: !40, line: 89, baseType: !79, size: 64, offset: 1152)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !65, line: 153, baseType: !80)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !65, line: 47, baseType: !81)
!81 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !39, file: !40, line: 91, baseType: !83, size: 64, offset: 1216)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !40, line: 37, flags: DIFlagFwdDecl)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !39, file: !40, line: 92, baseType: !86, size: 64, offset: 1280)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !40, line: 38, flags: DIFlagFwdDecl)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !39, file: !40, line: 93, baseType: !60, size: 64, offset: 1344)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !39, file: !40, line: 94, baseType: !90, size: 64, offset: 1408)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !39, file: !40, line: 95, baseType: !92, size: 64, offset: 1472)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !93, line: 46, baseType: !94)
!93 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!94 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !39, file: !40, line: 96, baseType: !43, size: 32, offset: 1536)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !39, file: !40, line: 98, baseType: !97, size: 160, offset: 1568)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 160, elements: !98)
!98 = !{!99}
!99 = !DISubrange(count: 20)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(name: "stdout", scope: !2, file: !35, line: 144, type: !36, isLocal: false, isDefinition: false)
!102 = !DIGlobalVariableExpression(var: !103, expr: !DIExpression())
!103 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !104, line: 33, type: !105, isLocal: true, isDefinition: true)
!104 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/david/Escritorio/TSN/xdp-david/switchtsn", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = !DISubroutineType(types: !107)
!107 = !{!90, !90, !108}
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!110 = !DIGlobalVariableExpression(var: !111, expr: !DIExpression())
!111 = distinct !DIGlobalVariable(name: "bpf_redirect", scope: !2, file: !104, line: 589, type: !112, isLocal: true, isDefinition: true)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DISubroutineType(types: !114)
!114 = !{!43, !115, !117}
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !116, line: 27, baseType: !7)
!116 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !116, line: 31, baseType: !118)
!118 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!119 = !DIGlobalVariableExpression(var: !120, expr: !DIExpression())
!120 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !104, line: 1254, type: !121, isLocal: true, isDefinition: true)
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !122, size: 64)
!122 = !DISubroutineType(types: !123)
!123 = !{!43, !90, !115, !117}
!124 = !{i32 7, !"Dwarf Version", i32 5}
!125 = !{i32 2, !"Debug Info Version", i32 3}
!126 = !{i32 1, !"wchar_size", i32 4}
!127 = !{i32 7, !"frame-pointer", i32 2}
!128 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!129 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 93, type: !130, scopeLine: 94, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !140)
!130 = !DISubroutineType(types: !131)
!131 = !{!43, !132}
!132 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !133, size: 64)
!133 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !134)
!134 = !{!135, !136, !137, !138, !139}
!135 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !133, file: !6, line: 2857, baseType: !115, size: 32)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !133, file: !6, line: 2858, baseType: !115, size: 32, offset: 32)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !133, file: !6, line: 2859, baseType: !115, size: 32, offset: 64)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !133, file: !6, line: 2861, baseType: !115, size: 32, offset: 96)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !133, file: !6, line: 2862, baseType: !115, size: 32, offset: 128)
!140 = !{!141, !142, !143}
!141 = !DILocalVariable(name: "ctx", arg: 1, scope: !129, file: !3, line: 93, type: !132)
!142 = !DILocalVariable(name: "index", scope: !129, file: !3, line: 95, type: !43)
!143 = !DILocalVariable(name: "pkt_count", scope: !129, file: !3, line: 96, type: !144)
!144 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!145 = !DILocation(line: 0, scope: !129)
!146 = !DILocation(line: 95, column: 5, scope: !129)
!147 = !DILocation(line: 95, column: 22, scope: !129)
!148 = !{!149, !150, i64 16}
!149 = !{!"xdp_md", !150, i64 0, !150, i64 4, !150, i64 8, !150, i64 12, !150, i64 16}
!150 = !{!"int", !151, i64 0}
!151 = !{!"omnipotent char", !152, i64 0}
!152 = !{!"Simple C/C++ TBAA"}
!153 = !DILocation(line: 95, column: 9, scope: !129)
!154 = !{!150, !150, i64 0}
!155 = !DILocation(line: 98, column: 17, scope: !129)
!156 = !DILocation(line: 99, column: 9, scope: !157)
!157 = distinct !DILexicalBlock(scope: !129, file: !3, line: 99, column: 9)
!158 = !DILocation(line: 99, column: 9, scope: !129)
!159 = !DILocation(line: 102, column: 25, scope: !160)
!160 = distinct !DILexicalBlock(scope: !161, file: !3, line: 102, column: 13)
!161 = distinct !DILexicalBlock(scope: !157, file: !3, line: 99, column: 20)
!162 = !DILocation(line: 102, column: 28, scope: !160)
!163 = !DILocation(line: 102, column: 13, scope: !161)
!164 = !DILocation(line: 103, column: 20, scope: !160)
!165 = !DILocation(line: 103, column: 13, scope: !160)
!166 = !DILocation(line: 108, column: 9, scope: !167)
!167 = distinct !DILexicalBlock(scope: !129, file: !3, line: 108, column: 9)
!168 = !DILocation(line: 108, column: 9, scope: !129)
!169 = !DILocation(line: 109, column: 44, scope: !167)
!170 = !DILocation(line: 109, column: 16, scope: !167)
!171 = !DILocation(line: 109, column: 9, scope: !167)
!172 = !DILocation(line: 112, column: 1, scope: !129)

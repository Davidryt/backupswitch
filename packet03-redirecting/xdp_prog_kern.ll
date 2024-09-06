; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.hdr_cursor = type { i8* }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.collect_vlans = type { [2 x i16] }
%struct.vlan_hdr = type { i16, i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, %union.anon }
%union.anon = type { %struct.anon }
%struct.anon = type { i32, i32 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %union.anon.1 }
%union.anon.1 = type { %struct.anon.2 }
%struct.anon.2 = type { %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon.3 }
%union.anon.3 = type { [4 x i32] }
%struct.icmphdr_common = type { i8, i8, i16 }
%struct.bpf_fib_lookup = type { i8, i8, i16, i16, i16, i32, %union.anon.5, %union.anon.6, %union.anon.7, i16, i16, [6 x i8], [6 x i8] }
%union.anon.5 = type { i32 }
%union.anon.6 = type { [4 x i32] }
%union.anon.7 = type { [4 x i32] }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@tx_port = dso_local global %struct.bpf_map_def { i32 14, i32 4, i32 4, i32 256, i32 0 }, section "maps", align 4, !dbg !78
@redirect_params = dso_local global %struct.bpf_map_def { i32 1, i32 6, i32 6, i32 1, i32 0 }, section "maps", align 4, !dbg !88
@__const.xdp_redirect_func.dst = private unnamed_addr constant [7 x i8] c"\E2\ABD\EAm\16\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !90
@llvm.compiler.used = appending global [9 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @redirect_params to i8*), i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_icmp_echo_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_map_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_router_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_icmp_echo_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_icmp_echo" !dbg !167 {
  %2 = alloca i32, align 4
  %3 = alloca [6 x i8], align 1
  %4 = alloca [4 x i32], align 4
  %5 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !179, metadata !DIExpression()), !dbg !266
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !267
  %7 = load i32, i32* %6, align 4, !dbg !267, !tbaa !268
  %8 = zext i32 %7 to i64, !dbg !273
  %9 = inttoptr i64 %8 to i8*, !dbg !274
  call void @llvm.dbg.value(metadata i8* %9, metadata !180, metadata !DIExpression()), !dbg !266
  %10 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !275
  %11 = load i32, i32* %10, align 4, !dbg !275, !tbaa !276
  %12 = zext i32 %11 to i64, !dbg !277
  %13 = inttoptr i64 %12 to i8*, !dbg !278
  call void @llvm.dbg.value(metadata i8* %13, metadata !181, metadata !DIExpression()), !dbg !266
  %14 = bitcast i32* %5 to i8*, !dbg !279
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %14) #8, !dbg !279
  call void @llvm.dbg.value(metadata i32 2, metadata !264, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata i8* %13, metadata !182, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !280, metadata !DIExpression()) #8, !dbg !289
  call void @llvm.dbg.value(metadata i8* %9, metadata !287, metadata !DIExpression()) #8, !dbg !289
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !288, metadata !DIExpression()) #8, !dbg !289
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !291, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata i8* %9, metadata !303, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !304, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !305, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata i8* %13, metadata !306, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata i32 14, metadata !307, metadata !DIExpression()) #8, !dbg !316
  %15 = getelementptr i8, i8* %13, i64 14, !dbg !318
  %16 = icmp ugt i8* %15, %9, !dbg !320
  br i1 %16, label %130, label %17, !dbg !321

17:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %13, metadata !306, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata i8* %15, metadata !182, metadata !DIExpression()), !dbg !266
  %18 = inttoptr i64 %12 to %struct.ethhdr*, !dbg !322
  call void @llvm.dbg.value(metadata i8* %15, metadata !308, metadata !DIExpression()) #8, !dbg !316
  %19 = getelementptr inbounds i8, i8* %13, i64 12, !dbg !323
  %20 = bitcast i8* %19 to i16*, !dbg !323
  call void @llvm.dbg.value(metadata i16 undef, metadata !314, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata i32 0, metadata !315, metadata !DIExpression()) #8, !dbg !316
  %21 = load i16, i16* %20, align 1, !dbg !316, !tbaa !324
  call void @llvm.dbg.value(metadata i16 %21, metadata !314, metadata !DIExpression()) #8, !dbg !316
  %22 = inttoptr i64 %8 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i16 %21, metadata !326, metadata !DIExpression()) #8, !dbg !331
  %23 = icmp eq i16 %21, 129, !dbg !337
  %24 = icmp eq i16 %21, -22392, !dbg !338
  %25 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %23) #8
  %26 = or i1 %24, %25, !dbg !338
  %27 = xor i1 %26, true, !dbg !339
  %28 = getelementptr i8, i8* %13, i64 18
  %29 = bitcast i8* %28 to %struct.vlan_hdr*
  %30 = icmp ugt %struct.vlan_hdr* %29, %22
  %31 = select i1 %27, i1 true, i1 %30, !dbg !340
  br i1 %31, label %49, label %32, !dbg !340

32:                                               ; preds = %17
  call void @llvm.dbg.value(metadata i16 undef, metadata !314, metadata !DIExpression()) #8, !dbg !316
  %33 = getelementptr i8, i8* %13, i64 16, !dbg !341
  %34 = bitcast i8* %33 to i16*, !dbg !341
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %29, metadata !308, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata i32 1, metadata !315, metadata !DIExpression()) #8, !dbg !316
  %35 = load i16, i16* %34, align 1, !dbg !316, !tbaa !324
  call void @llvm.dbg.value(metadata i16 %35, metadata !314, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata i16 %35, metadata !326, metadata !DIExpression()) #8, !dbg !331
  %36 = icmp eq i16 %35, 129, !dbg !337
  %37 = icmp eq i16 %35, -22392, !dbg !338
  %38 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %36) #8
  %39 = or i1 %37, %38, !dbg !338
  %40 = xor i1 %39, true, !dbg !339
  %41 = getelementptr i8, i8* %13, i64 22
  %42 = bitcast i8* %41 to %struct.vlan_hdr*
  %43 = icmp ugt %struct.vlan_hdr* %42, %22
  %44 = select i1 %40, i1 true, i1 %43, !dbg !340
  br i1 %44, label %49, label %45, !dbg !340

45:                                               ; preds = %32
  call void @llvm.dbg.value(metadata i16 undef, metadata !314, metadata !DIExpression()) #8, !dbg !316
  %46 = getelementptr i8, i8* %13, i64 20, !dbg !341
  %47 = bitcast i8* %46 to i16*, !dbg !341
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %42, metadata !308, metadata !DIExpression()) #8, !dbg !316
  call void @llvm.dbg.value(metadata i32 2, metadata !315, metadata !DIExpression()) #8, !dbg !316
  %48 = load i16, i16* %47, align 1, !dbg !316, !tbaa !324
  call void @llvm.dbg.value(metadata i16 %48, metadata !314, metadata !DIExpression()) #8, !dbg !316
  br label %49

49:                                               ; preds = %17, %32, %45
  %50 = phi i8* [ %15, %17 ], [ %28, %32 ], [ %41, %45 ], !dbg !316
  %51 = phi i16 [ %21, %17 ], [ %35, %32 ], [ %48, %45 ], !dbg !316
  call void @llvm.dbg.value(metadata i8* %50, metadata !182, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata i16 %51, metadata !196, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !266
  switch i16 %51, label %130 [
    i16 8, label %52
    i16 -8826, label %69
  ], !dbg !342

52:                                               ; preds = %49
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !343, metadata !DIExpression()), !dbg !353
  call void @llvm.dbg.value(metadata i8* %9, metadata !349, metadata !DIExpression()), !dbg !353
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !350, metadata !DIExpression()), !dbg !353
  call void @llvm.dbg.value(metadata i8* %50, metadata !351, metadata !DIExpression()), !dbg !353
  %53 = getelementptr inbounds i8, i8* %50, i64 20, !dbg !357
  %54 = icmp ugt i8* %53, %9, !dbg !359
  br i1 %54, label %130, label %55, !dbg !360

55:                                               ; preds = %52
  %56 = load i8, i8* %50, align 4, !dbg !361
  %57 = shl i8 %56, 2, !dbg !362
  %58 = and i8 %57, 60, !dbg !362
  call void @llvm.dbg.value(metadata i8 %58, metadata !352, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !353
  %59 = icmp ult i8 %58, 20, !dbg !363
  br i1 %59, label %130, label %60, !dbg !365

60:                                               ; preds = %55
  %61 = zext i8 %58 to i64
  call void @llvm.dbg.value(metadata i64 %61, metadata !352, metadata !DIExpression()), !dbg !353
  %62 = getelementptr i8, i8* %50, i64 %61, !dbg !366
  %63 = icmp ugt i8* %62, %9, !dbg !368
  br i1 %63, label %130, label %64, !dbg !369

64:                                               ; preds = %60
  call void @llvm.dbg.value(metadata i8* %62, metadata !182, metadata !DIExpression()), !dbg !266
  %65 = bitcast i8* %50 to %struct.iphdr*, !dbg !370
  %66 = getelementptr inbounds i8, i8* %50, i64 9, !dbg !371
  %67 = load i8, i8* %66, align 1, !dbg !371, !tbaa !372
  call void @llvm.dbg.value(metadata i8 %67, metadata !197, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !266
  %68 = icmp eq i8 %67, 1, !dbg !374
  br i1 %68, label %79, label %130, !dbg !376

69:                                               ; preds = %49
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !377, metadata !DIExpression()), !dbg !386
  call void @llvm.dbg.value(metadata i8* %9, metadata !383, metadata !DIExpression()), !dbg !386
  call void @llvm.dbg.value(metadata %struct.ipv6hdr** undef, metadata !384, metadata !DIExpression()), !dbg !386
  call void @llvm.dbg.value(metadata i8* %50, metadata !385, metadata !DIExpression()), !dbg !386
  %70 = getelementptr inbounds i8, i8* %50, i64 40, !dbg !390
  %71 = bitcast i8* %70 to %struct.ipv6hdr*, !dbg !390
  %72 = inttoptr i64 %8 to %struct.ipv6hdr*, !dbg !392
  %73 = icmp ugt %struct.ipv6hdr* %71, %72, !dbg !393
  br i1 %73, label %130, label %74, !dbg !394

74:                                               ; preds = %69
  %75 = bitcast i8* %50 to %struct.ipv6hdr*, !dbg !395
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %75, metadata !385, metadata !DIExpression()), !dbg !386
  call void @llvm.dbg.value(metadata i8* %70, metadata !182, metadata !DIExpression()), !dbg !266
  %76 = getelementptr inbounds i8, i8* %50, i64 6, !dbg !396
  %77 = load i8, i8* %76, align 2, !dbg !396, !tbaa !397
  call void @llvm.dbg.value(metadata i8 %77, metadata !197, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !266
  %78 = icmp eq i8 %77, 58, !dbg !399
  br i1 %78, label %79, label %130, !dbg !401

79:                                               ; preds = %74, %64
  %80 = phi i1 [ true, %64 ], [ false, %74 ]
  %81 = phi i1 [ false, %64 ], [ true, %74 ]
  %82 = phi i8* [ %62, %64 ], [ %70, %74 ], !dbg !402
  %83 = phi %struct.iphdr* [ %65, %64 ], [ undef, %74 ]
  %84 = phi %struct.ipv6hdr* [ undef, %64 ], [ %75, %74 ]
  call void @llvm.dbg.value(metadata i8* %82, metadata !182, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !403, metadata !DIExpression()), !dbg !412
  call void @llvm.dbg.value(metadata i8* %9, metadata !409, metadata !DIExpression()), !dbg !412
  call void @llvm.dbg.value(metadata %struct.icmphdr_common** undef, metadata !410, metadata !DIExpression()), !dbg !412
  call void @llvm.dbg.value(metadata i8* %82, metadata !411, metadata !DIExpression()), !dbg !412
  %85 = getelementptr inbounds i8, i8* %82, i64 4, !dbg !414
  %86 = bitcast i8* %85 to %struct.icmphdr_common*, !dbg !414
  %87 = inttoptr i64 %8 to %struct.icmphdr_common*, !dbg !416
  %88 = icmp ugt %struct.icmphdr_common* %86, %87, !dbg !417
  br i1 %88, label %130, label %89, !dbg !418

89:                                               ; preds = %79
  call void @llvm.dbg.value(metadata %struct.icmphdr_common* %86, metadata !182, metadata !DIExpression()), !dbg !266
  %90 = load i8, i8* %82, align 2, !dbg !419, !tbaa !420
  call void @llvm.dbg.value(metadata i8 %90, metadata !198, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !266
  %91 = icmp eq i8 %90, 8
  %92 = select i1 %80, i1 %91, i1 false, !dbg !422
  br i1 %92, label %93, label %98, !dbg !422

93:                                               ; preds = %89
  call void @llvm.dbg.value(metadata %struct.iphdr* %83, metadata !199, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata %struct.iphdr* %83, metadata !424, metadata !DIExpression()), !dbg !430
  %94 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %83, i64 0, i32 8, i32 0, i32 0, !dbg !433
  %95 = load i32, i32* %94, align 4, !dbg !433, !tbaa !434
  call void @llvm.dbg.value(metadata i32 %95, metadata !429, metadata !DIExpression()), !dbg !430
  %96 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %83, i64 0, i32 8, i32 0, i32 1, !dbg !435
  %97 = load i32, i32* %96, align 4, !dbg !435, !tbaa !434
  store i32 %97, i32* %94, align 4, !dbg !436, !tbaa !434
  store i32 %95, i32* %96, align 4, !dbg !437, !tbaa !434
  call void @llvm.dbg.value(metadata i16 0, metadata !254, metadata !DIExpression()), !dbg !266
  br label %109, !dbg !438

98:                                               ; preds = %89
  call void @llvm.dbg.value(metadata i8 %90, metadata !198, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !266
  %99 = icmp eq i8 %90, -128
  %100 = select i1 %81, i1 %99, i1 false, !dbg !439
  br i1 %100, label %101, label %130, !dbg !439

101:                                              ; preds = %98
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %84, metadata !227, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.declare(metadata [4 x i32]* %4, metadata !441, metadata !DIExpression()) #8, !dbg !447
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %84, metadata !446, metadata !DIExpression()) #8, !dbg !450
  %102 = bitcast [4 x i32]* %4 to i8*, !dbg !451
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %102), !dbg !451
  %103 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %84, i64 0, i32 5, !dbg !452
  %104 = bitcast %union.anon.1* %103 to i8*, !dbg !452
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %102, i8* noundef nonnull align 4 dereferenceable(16) %104, i64 16, i1 false) #8, !dbg !452, !tbaa.struct !453
  %105 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %84, i64 0, i32 5, i32 0, !dbg !454
  %106 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %84, i64 0, i32 5, i32 0, i32 1, !dbg !455
  %107 = bitcast %struct.anon.2* %105 to i8*, !dbg !455
  %108 = bitcast %struct.in6_addr* %106 to i8*, !dbg !455
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %107, i8* noundef nonnull align 4 dereferenceable(16) %108, i64 16, i1 false) #8, !dbg !455, !tbaa.struct !453
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %108, i8* noundef nonnull align 4 dereferenceable(16) %102, i64 16, i1 false) #8, !dbg !456, !tbaa.struct !453
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %102), !dbg !457
  call void @llvm.dbg.value(metadata i16 129, metadata !254, metadata !DIExpression()), !dbg !266
  br label %109

109:                                              ; preds = %101, %93
  %110 = phi i8 [ 0, %93 ], [ -127, %101 ]
  call void @llvm.dbg.value(metadata i16 poison, metadata !254, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata %struct.ethhdr* %18, metadata !187, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata %struct.ethhdr* %18, metadata !458, metadata !DIExpression()) #8, !dbg !464
  %111 = getelementptr inbounds [6 x i8], [6 x i8]* %3, i64 0, i64 0, !dbg !466
  call void @llvm.lifetime.start.p0i8(i64 6, i8* nonnull %111), !dbg !466
  call void @llvm.dbg.declare(metadata [6 x i8]* %3, metadata !463, metadata !DIExpression()) #8, !dbg !467
  %112 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %18, i64 0, i32 1, i64 0, !dbg !468
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) %111, i8* noundef nonnull align 1 dereferenceable(6) %112, i64 6, i1 false) #8, !dbg !468
  %113 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %18, i64 0, i32 0, i64 0, !dbg !469
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) %112, i8* noundef nonnull align 1 dereferenceable(6) %113, i64 6, i1 false) #8, !dbg !469
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) %113, i8* noundef nonnull align 1 dereferenceable(6) %111, i64 6, i1 false) #8, !dbg !470
  call void @llvm.lifetime.end.p0i8(i64 6, i8* nonnull %111), !dbg !471
  call void @llvm.dbg.value(metadata i8* %82, metadata !256, metadata !DIExpression()), !dbg !266
  %114 = getelementptr inbounds i8, i8* %82, i64 2, !dbg !472
  %115 = bitcast i8* %114 to i16*, !dbg !472
  %116 = load i16, i16* %115, align 2, !dbg !472, !tbaa !473
  call void @llvm.dbg.value(metadata i16 %116, metadata !255, metadata !DIExpression()), !dbg !266
  store i16 0, i16* %115, align 2, !dbg !474, !tbaa !473
  call void @llvm.dbg.value(metadata %struct.icmphdr_common* undef, metadata !256, metadata !DIExpression()), !dbg !266
  %117 = bitcast i8* %82 to i32*, !dbg !475
  %118 = load i32, i32* %117, align 2, !dbg !475
  call void @llvm.dbg.value(metadata i32 %118, metadata !263, metadata !DIExpression()), !dbg !266
  store i32 %118, i32* %5, align 4, !dbg !475
  call void @llvm.dbg.value(metadata i8* %82, metadata !256, metadata !DIExpression()), !dbg !266
  store i8 %110, i8* %82, align 2, !dbg !476, !tbaa !420
  %119 = xor i16 %116, -1, !dbg !477
  call void @llvm.dbg.value(metadata i16 %119, metadata !478, metadata !DIExpression()) #8, !dbg !487
  call void @llvm.dbg.value(metadata i8* %82, metadata !483, metadata !DIExpression()) #8, !dbg !487
  call void @llvm.dbg.value(metadata i32* %5, metadata !484, metadata !DIExpression()) #8, !dbg !487
  call void @llvm.dbg.value(metadata i32 4, metadata !486, metadata !DIExpression()) #8, !dbg !487
  %120 = zext i16 %119 to i32, !dbg !489
  call void @llvm.dbg.value(metadata i32* %5, metadata !263, metadata !DIExpression(DW_OP_deref)), !dbg !266
  %121 = call i64 inttoptr (i64 28 to i64 (i32*, i32, i32*, i32, i32)*)(i32* noundef nonnull %5, i32 noundef 4, i32* noundef nonnull %117, i32 noundef 4, i32 noundef %120) #8, !dbg !490
  %122 = trunc i64 %121 to i32, !dbg !490
  call void @llvm.dbg.value(metadata i32 %122, metadata !485, metadata !DIExpression()) #8, !dbg !487
  call void @llvm.dbg.value(metadata i32 %122, metadata !491, metadata !DIExpression()) #8, !dbg !497
  %123 = lshr i32 %122, 16, !dbg !499
  %124 = and i32 %122, 65535, !dbg !500
  %125 = add nuw nsw i32 %123, %124, !dbg !501
  call void @llvm.dbg.value(metadata i32 %125, metadata !496, metadata !DIExpression()) #8, !dbg !497
  %126 = lshr i32 %125, 16, !dbg !502
  %127 = add nuw nsw i32 %126, %125, !dbg !503
  call void @llvm.dbg.value(metadata i32 %127, metadata !496, metadata !DIExpression()) #8, !dbg !497
  %128 = trunc i32 %127 to i16, !dbg !504
  %129 = xor i16 %128, -1, !dbg !504
  store i16 %129, i16* %115, align 2, !dbg !505, !tbaa !473
  call void @llvm.dbg.value(metadata i32 3, metadata !264, metadata !DIExpression()), !dbg !266
  br label %130, !dbg !506

130:                                              ; preds = %49, %79, %69, %60, %55, %52, %1, %98, %74, %64, %109
  %131 = phi i32 [ 2, %64 ], [ 3, %109 ], [ 2, %98 ], [ 2, %74 ], [ 2, %1 ], [ 2, %52 ], [ 2, %55 ], [ 2, %60 ], [ 2, %69 ], [ 2, %79 ], [ 2, %49 ], !dbg !266
  call void @llvm.dbg.value(metadata i32 %131, metadata !264, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.label(metadata !265), !dbg !507
  %132 = bitcast i32* %2 to i8*, !dbg !508
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %132), !dbg !508
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !513, metadata !DIExpression()) #8, !dbg !508
  call void @llvm.dbg.value(metadata i32 %131, metadata !514, metadata !DIExpression()) #8, !dbg !508
  store i32 %131, i32* %2, align 4, !tbaa !523
  call void @llvm.dbg.value(metadata i32* %2, metadata !514, metadata !DIExpression(DW_OP_deref)) #8, !dbg !508
  %133 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %132) #8, !dbg !524
  call void @llvm.dbg.value(metadata i8* %133, metadata !515, metadata !DIExpression()) #8, !dbg !508
  %134 = icmp eq i8* %133, null, !dbg !525
  br i1 %134, label %148, label %135, !dbg !527

135:                                              ; preds = %130
  call void @llvm.dbg.value(metadata i8* %133, metadata !515, metadata !DIExpression()) #8, !dbg !508
  %136 = bitcast i8* %133 to i64*, !dbg !528
  %137 = load i64, i64* %136, align 8, !dbg !529, !tbaa !530
  %138 = add i64 %137, 1, !dbg !529
  store i64 %138, i64* %136, align 8, !dbg !529, !tbaa !530
  %139 = load i32, i32* %6, align 4, !dbg !533, !tbaa !268
  %140 = load i32, i32* %10, align 4, !dbg !534, !tbaa !276
  %141 = sub i32 %139, %140, !dbg !535
  %142 = zext i32 %141 to i64, !dbg !536
  %143 = getelementptr inbounds i8, i8* %133, i64 8, !dbg !537
  %144 = bitcast i8* %143 to i64*, !dbg !537
  %145 = load i64, i64* %144, align 8, !dbg !538, !tbaa !539
  %146 = add i64 %145, %142, !dbg !538
  store i64 %146, i64* %144, align 8, !dbg !538, !tbaa !539
  %147 = load i32, i32* %2, align 4, !dbg !540, !tbaa !523
  call void @llvm.dbg.value(metadata i32 %147, metadata !514, metadata !DIExpression()) #8, !dbg !508
  br label %148, !dbg !541

148:                                              ; preds = %130, %135
  %149 = phi i32 [ %147, %135 ], [ 0, %130 ], !dbg !508
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %132), !dbg !542
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %14) #8, !dbg !543
  ret i32 %149, !dbg !544
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind
define dso_local i32 @xdp_redirect_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_redirect" !dbg !545 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !547, metadata !DIExpression()), !dbg !560
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !561
  %4 = load i32, i32* %3, align 4, !dbg !561, !tbaa !268
  %5 = zext i32 %4 to i64, !dbg !562
  %6 = inttoptr i64 %5 to i8*, !dbg !563
  call void @llvm.dbg.value(metadata i8* %6, metadata !548, metadata !DIExpression()), !dbg !560
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !564
  %8 = load i32, i32* %7, align 4, !dbg !564, !tbaa !276
  %9 = zext i32 %8 to i64, !dbg !565
  %10 = inttoptr i64 %9 to i8*, !dbg !566
  call void @llvm.dbg.value(metadata i8* %10, metadata !549, metadata !DIExpression()), !dbg !560
  call void @llvm.dbg.value(metadata i32 2, metadata !553, metadata !DIExpression()), !dbg !560
  call void @llvm.dbg.declare(metadata [7 x i8]* @__const.xdp_redirect_func.dst, metadata !554, metadata !DIExpression()), !dbg !567
  call void @llvm.dbg.value(metadata i32 5, metadata !558, metadata !DIExpression()), !dbg !560
  call void @llvm.dbg.value(metadata i8* %10, metadata !550, metadata !DIExpression()), !dbg !560
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !280, metadata !DIExpression()) #8, !dbg !568
  call void @llvm.dbg.value(metadata i8* %6, metadata !287, metadata !DIExpression()) #8, !dbg !568
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !288, metadata !DIExpression()) #8, !dbg !568
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !291, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata i8* %6, metadata !303, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !304, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !305, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata i8* %10, metadata !306, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata i32 14, metadata !307, metadata !DIExpression()) #8, !dbg !570
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !572
  %12 = icmp ugt i8* %11, %6, !dbg !573
  br i1 %12, label %19, label %13, !dbg !574

13:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !306, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata i8* %11, metadata !550, metadata !DIExpression()), !dbg !560
  %14 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !575
  call void @llvm.dbg.value(metadata i8* %11, metadata !308, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata i16 undef, metadata !314, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata i32 0, metadata !315, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata i16 undef, metadata !314, metadata !DIExpression()) #8, !dbg !570
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !550, metadata !DIExpression()), !dbg !560
  call void @llvm.dbg.value(metadata i16 undef, metadata !552, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !560
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !551, metadata !DIExpression()), !dbg !560
  %15 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 0, !dbg !576
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) %15, i8* noundef nonnull align 1 dereferenceable(6) getelementptr inbounds ([7 x i8], [7 x i8]* @__const.xdp_redirect_func.dst, i64 0, i64 0), i64 6, i1 false), !dbg !576
  %16 = tail call i32 inttoptr (i64 23 to i32 (i32, i64)*)(i32 noundef 5, i64 noundef 0) #8, !dbg !577
  call void @llvm.dbg.value(metadata i32 %16, metadata !553, metadata !DIExpression()), !dbg !560
  call void @llvm.dbg.label(metadata !559), !dbg !578
  %17 = bitcast i32* %2 to i8*, !dbg !579
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %17), !dbg !579
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !513, metadata !DIExpression()) #8, !dbg !579
  call void @llvm.dbg.value(metadata i32 %16, metadata !514, metadata !DIExpression()) #8, !dbg !579
  store i32 %16, i32* %2, align 4, !tbaa !523
  %18 = icmp ugt i32 %16, 4, !dbg !581
  br i1 %18, label %38, label %21, !dbg !583

19:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i32 %16, metadata !553, metadata !DIExpression()), !dbg !560
  call void @llvm.dbg.label(metadata !559), !dbg !578
  %20 = bitcast i32* %2 to i8*, !dbg !579
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %20), !dbg !579
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !513, metadata !DIExpression()) #8, !dbg !579
  call void @llvm.dbg.value(metadata i32 %16, metadata !514, metadata !DIExpression()) #8, !dbg !579
  store i32 2, i32* %2, align 4, !tbaa !523
  br label %21, !dbg !583

21:                                               ; preds = %19, %13
  %22 = bitcast i32* %2 to i8*
  call void @llvm.dbg.value(metadata i32* %2, metadata !514, metadata !DIExpression(DW_OP_deref)) #8, !dbg !579
  %23 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %22) #8, !dbg !584
  call void @llvm.dbg.value(metadata i8* %23, metadata !515, metadata !DIExpression()) #8, !dbg !579
  %24 = icmp eq i8* %23, null, !dbg !585
  br i1 %24, label %38, label %25, !dbg !586

25:                                               ; preds = %21
  call void @llvm.dbg.value(metadata i8* %23, metadata !515, metadata !DIExpression()) #8, !dbg !579
  %26 = bitcast i8* %23 to i64*, !dbg !587
  %27 = load i64, i64* %26, align 8, !dbg !588, !tbaa !530
  %28 = add i64 %27, 1, !dbg !588
  store i64 %28, i64* %26, align 8, !dbg !588, !tbaa !530
  %29 = load i32, i32* %3, align 4, !dbg !589, !tbaa !268
  %30 = load i32, i32* %7, align 4, !dbg !590, !tbaa !276
  %31 = sub i32 %29, %30, !dbg !591
  %32 = zext i32 %31 to i64, !dbg !592
  %33 = getelementptr inbounds i8, i8* %23, i64 8, !dbg !593
  %34 = bitcast i8* %33 to i64*, !dbg !593
  %35 = load i64, i64* %34, align 8, !dbg !594, !tbaa !539
  %36 = add i64 %35, %32, !dbg !594
  store i64 %36, i64* %34, align 8, !dbg !594, !tbaa !539
  %37 = load i32, i32* %2, align 4, !dbg !595, !tbaa !523
  call void @llvm.dbg.value(metadata i32 %37, metadata !514, metadata !DIExpression()) #8, !dbg !579
  br label %38, !dbg !596

38:                                               ; preds = %13, %21, %25
  %39 = phi i32 [ 0, %13 ], [ %37, %25 ], [ 0, %21 ], !dbg !579
  %40 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %40), !dbg !597
  ret i32 %39, !dbg !598
}

; Function Attrs: nounwind
define dso_local i32 @xdp_redirect_map_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_redirect_map" !dbg !599 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !601, metadata !DIExpression()), !dbg !611
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !612
  %4 = load i32, i32* %3, align 4, !dbg !612, !tbaa !268
  %5 = zext i32 %4 to i64, !dbg !613
  %6 = inttoptr i64 %5 to i8*, !dbg !614
  call void @llvm.dbg.value(metadata i8* %6, metadata !602, metadata !DIExpression()), !dbg !611
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !615
  %8 = load i32, i32* %7, align 4, !dbg !615, !tbaa !276
  %9 = zext i32 %8 to i64, !dbg !616
  %10 = inttoptr i64 %9 to i8*, !dbg !617
  call void @llvm.dbg.value(metadata i8* %10, metadata !603, metadata !DIExpression()), !dbg !611
  call void @llvm.dbg.value(metadata i32 2, metadata !607, metadata !DIExpression()), !dbg !611
  call void @llvm.dbg.value(metadata i8* %10, metadata !604, metadata !DIExpression()), !dbg !611
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !280, metadata !DIExpression()) #8, !dbg !618
  call void @llvm.dbg.value(metadata i8* %6, metadata !287, metadata !DIExpression()) #8, !dbg !618
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !288, metadata !DIExpression()) #8, !dbg !618
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !291, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata i8* %6, metadata !303, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !304, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !305, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata i8* %10, metadata !306, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata i32 14, metadata !307, metadata !DIExpression()) #8, !dbg !620
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !622
  %12 = icmp ugt i8* %11, %6, !dbg !623
  br i1 %12, label %18, label %13, !dbg !624

13:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !306, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata i8* %11, metadata !604, metadata !DIExpression()), !dbg !611
  %14 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !625
  call void @llvm.dbg.value(metadata i8* %11, metadata !308, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata i16 undef, metadata !314, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata i32 0, metadata !315, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata i16 undef, metadata !314, metadata !DIExpression()) #8, !dbg !620
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !604, metadata !DIExpression()), !dbg !611
  call void @llvm.dbg.value(metadata i16 undef, metadata !606, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !611
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !605, metadata !DIExpression()), !dbg !611
  %15 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 1, i64 0, !dbg !626
  %16 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @redirect_params to i8*), i8* noundef nonnull %15) #8, !dbg !627
  call void @llvm.dbg.value(metadata i8* %16, metadata !608, metadata !DIExpression()), !dbg !611
  %17 = icmp eq i8* %16, null, !dbg !628
  br i1 %17, label %18, label %20, !dbg !630

18:                                               ; preds = %13, %1
  call void @llvm.dbg.value(metadata i32 %22, metadata !607, metadata !DIExpression()), !dbg !611
  call void @llvm.dbg.label(metadata !610), !dbg !631
  %19 = bitcast i32* %2 to i8*, !dbg !632
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %19), !dbg !632
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !513, metadata !DIExpression()) #8, !dbg !632
  call void @llvm.dbg.value(metadata i32 %22, metadata !514, metadata !DIExpression()) #8, !dbg !632
  store i32 2, i32* %2, align 4, !tbaa !523
  br label %25, !dbg !634

20:                                               ; preds = %13
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !605, metadata !DIExpression()), !dbg !611
  %21 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 0, !dbg !635
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) %21, i8* noundef nonnull align 1 dereferenceable(6) %16, i64 6, i1 false), !dbg !635
  %22 = tail call i32 inttoptr (i64 51 to i32 (i8*, i32, i64)*)(i8* noundef bitcast (%struct.bpf_map_def* @tx_port to i8*), i32 noundef 0, i64 noundef 0) #8, !dbg !636
  call void @llvm.dbg.value(metadata i32 %22, metadata !607, metadata !DIExpression()), !dbg !611
  call void @llvm.dbg.label(metadata !610), !dbg !631
  %23 = bitcast i32* %2 to i8*, !dbg !632
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %23), !dbg !632
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !513, metadata !DIExpression()) #8, !dbg !632
  call void @llvm.dbg.value(metadata i32 %22, metadata !514, metadata !DIExpression()) #8, !dbg !632
  store i32 %22, i32* %2, align 4, !tbaa !523
  %24 = icmp ugt i32 %22, 4, !dbg !637
  br i1 %24, label %42, label %25, !dbg !634

25:                                               ; preds = %18, %20
  %26 = bitcast i32* %2 to i8*
  call void @llvm.dbg.value(metadata i32* %2, metadata !514, metadata !DIExpression(DW_OP_deref)) #8, !dbg !632
  %27 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %26) #8, !dbg !638
  call void @llvm.dbg.value(metadata i8* %27, metadata !515, metadata !DIExpression()) #8, !dbg !632
  %28 = icmp eq i8* %27, null, !dbg !639
  br i1 %28, label %42, label %29, !dbg !640

29:                                               ; preds = %25
  call void @llvm.dbg.value(metadata i8* %27, metadata !515, metadata !DIExpression()) #8, !dbg !632
  %30 = bitcast i8* %27 to i64*, !dbg !641
  %31 = load i64, i64* %30, align 8, !dbg !642, !tbaa !530
  %32 = add i64 %31, 1, !dbg !642
  store i64 %32, i64* %30, align 8, !dbg !642, !tbaa !530
  %33 = load i32, i32* %3, align 4, !dbg !643, !tbaa !268
  %34 = load i32, i32* %7, align 4, !dbg !644, !tbaa !276
  %35 = sub i32 %33, %34, !dbg !645
  %36 = zext i32 %35 to i64, !dbg !646
  %37 = getelementptr inbounds i8, i8* %27, i64 8, !dbg !647
  %38 = bitcast i8* %37 to i64*, !dbg !647
  %39 = load i64, i64* %38, align 8, !dbg !648, !tbaa !539
  %40 = add i64 %39, %36, !dbg !648
  store i64 %40, i64* %38, align 8, !dbg !648, !tbaa !539
  %41 = load i32, i32* %2, align 4, !dbg !649, !tbaa !523
  call void @llvm.dbg.value(metadata i32 %41, metadata !514, metadata !DIExpression()) #8, !dbg !632
  br label %42, !dbg !650

42:                                               ; preds = %20, %25, %29
  %43 = phi i32 [ 0, %20 ], [ %41, %29 ], [ 0, %25 ], !dbg !632
  %44 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %44), !dbg !651
  ret i32 %43, !dbg !652
}

; Function Attrs: nounwind
define dso_local i32 @xdp_router_func(%struct.xdp_md* noundef %0) #0 section "xdp_router" !dbg !653 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.bpf_fib_lookup, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !655, metadata !DIExpression()), !dbg !672
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !673
  %5 = load i32, i32* %4, align 4, !dbg !673, !tbaa !268
  %6 = zext i32 %5 to i64, !dbg !674
  %7 = inttoptr i64 %6 to i8*, !dbg !675
  call void @llvm.dbg.value(metadata i8* %7, metadata !656, metadata !DIExpression()), !dbg !672
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !676
  %9 = load i32, i32* %8, align 4, !dbg !676, !tbaa !276
  %10 = zext i32 %9 to i64, !dbg !677
  %11 = inttoptr i64 %10 to i8*, !dbg !678
  call void @llvm.dbg.value(metadata i8* %11, metadata !657, metadata !DIExpression()), !dbg !672
  %12 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 0, !dbg !679
  call void @llvm.lifetime.start.p0i8(i64 64, i8* nonnull %12) #8, !dbg !679
  call void @llvm.dbg.declare(metadata %struct.bpf_fib_lookup* %3, metadata !658, metadata !DIExpression()), !dbg !680
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(64) %12, i8 0, i64 64, i1 false), !dbg !680
  %13 = inttoptr i64 %10 to %struct.ethhdr*, !dbg !681
  call void @llvm.dbg.value(metadata %struct.ethhdr* %13, metadata !659, metadata !DIExpression()), !dbg !672
  call void @llvm.dbg.value(metadata i32 2, metadata !665, metadata !DIExpression()), !dbg !672
  call void @llvm.dbg.value(metadata i64 14, metadata !663, metadata !DIExpression()), !dbg !672
  %14 = getelementptr i8, i8* %11, i64 14, !dbg !682
  %15 = icmp ugt i8* %14, %7, !dbg !684
  br i1 %15, label %110, label %16, !dbg !685

16:                                               ; preds = %1
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 2, !dbg !686
  %18 = load i16, i16* %17, align 1, !dbg !686, !tbaa !687
  call void @llvm.dbg.value(metadata i16 %18, metadata !662, metadata !DIExpression()), !dbg !672
  %19 = icmp eq i16 %18, 8, !dbg !689
  br i1 %19, label %20, label %52, !dbg !690

20:                                               ; preds = %16
  %21 = bitcast i8* %14 to %struct.iphdr*, !dbg !691
  call void @llvm.dbg.value(metadata %struct.iphdr* %21, metadata !661, metadata !DIExpression()), !dbg !672
  %22 = getelementptr i8, i8* %11, i64 34, !dbg !693
  %23 = bitcast i8* %22 to %struct.iphdr*, !dbg !693
  %24 = inttoptr i64 %6 to %struct.iphdr*, !dbg !695
  %25 = icmp ugt %struct.iphdr* %23, %24, !dbg !696
  br i1 %25, label %110, label %26, !dbg !697

26:                                               ; preds = %20
  %27 = getelementptr i8, i8* %11, i64 22, !dbg !698
  %28 = load i8, i8* %27, align 4, !dbg !698, !tbaa !700
  %29 = icmp ult i8 %28, 2, !dbg !701
  br i1 %29, label %110, label %30, !dbg !702

30:                                               ; preds = %26
  store i8 2, i8* %12, align 4, !dbg !703, !tbaa !704
  %31 = getelementptr i8, i8* %11, i64 15, !dbg !706
  %32 = load i8, i8* %31, align 1, !dbg !706, !tbaa !707
  %33 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 6, !dbg !708
  %34 = bitcast %union.anon.5* %33 to i8*, !dbg !708
  store i8 %32, i8* %34, align 4, !dbg !709, !tbaa !434
  %35 = getelementptr i8, i8* %11, i64 23, !dbg !710
  %36 = load i8, i8* %35, align 1, !dbg !710, !tbaa !372
  %37 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 1, !dbg !711
  store i8 %36, i8* %37, align 1, !dbg !712, !tbaa !713
  %38 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 3, !dbg !714
  store i16 0, i16* %38, align 4, !dbg !715, !tbaa !716
  %39 = getelementptr i8, i8* %11, i64 16, !dbg !717
  %40 = bitcast i8* %39 to i16*, !dbg !717
  %41 = load i16, i16* %40, align 2, !dbg !717, !tbaa !718
  %42 = tail call i16 @llvm.bswap.i16(i16 %41)
  %43 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 4, !dbg !719
  store i16 %42, i16* %43, align 2, !dbg !720, !tbaa !721
  %44 = getelementptr i8, i8* %11, i64 26, !dbg !722
  %45 = bitcast i8* %44 to i32*, !dbg !722
  %46 = load i32, i32* %45, align 4, !dbg !722, !tbaa !434
  %47 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 7, i32 0, i64 0, !dbg !723
  store i32 %46, i32* %47, align 4, !dbg !724, !tbaa !434
  %48 = getelementptr i8, i8* %11, i64 30, !dbg !725
  %49 = bitcast i8* %48 to i32*, !dbg !725
  %50 = load i32, i32* %49, align 4, !dbg !725, !tbaa !434
  %51 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 8, i32 0, i64 0, !dbg !726
  store i32 %50, i32* %51, align 4, !dbg !727, !tbaa !434
  br label %84, !dbg !728

52:                                               ; preds = %16
  %53 = icmp eq i16 %18, -8826, !dbg !729
  br i1 %53, label %54, label %110, !dbg !730

54:                                               ; preds = %52
  %55 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 7, i32 0, i64 0, !dbg !731
  call void @llvm.dbg.value(metadata i32* %55, metadata !666, metadata !DIExpression()), !dbg !732
  %56 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 8, i32 0, i64 0, !dbg !733
  call void @llvm.dbg.value(metadata i32* %56, metadata !670, metadata !DIExpression()), !dbg !732
  %57 = bitcast i8* %14 to %struct.ipv6hdr*, !dbg !734
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %57, metadata !660, metadata !DIExpression()), !dbg !672
  %58 = getelementptr i8, i8* %11, i64 54, !dbg !735
  %59 = bitcast i8* %58 to %struct.ipv6hdr*, !dbg !735
  %60 = inttoptr i64 %6 to %struct.ipv6hdr*, !dbg !737
  %61 = icmp ugt %struct.ipv6hdr* %59, %60, !dbg !738
  br i1 %61, label %110, label %62, !dbg !739

62:                                               ; preds = %54
  %63 = getelementptr i8, i8* %11, i64 21, !dbg !740
  %64 = load i8, i8* %63, align 1, !dbg !740, !tbaa !742
  %65 = icmp ult i8 %64, 2, !dbg !743
  br i1 %65, label %110, label %66, !dbg !744

66:                                               ; preds = %62
  store i8 10, i8* %12, align 4, !dbg !745, !tbaa !704
  %67 = bitcast i8* %14 to i32*, !dbg !746
  %68 = load i32, i32* %67, align 4, !dbg !746, !tbaa !523
  %69 = and i32 %68, -241, !dbg !747
  %70 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 6, i32 0, !dbg !748
  store i32 %69, i32* %70, align 4, !dbg !749, !tbaa !434
  %71 = getelementptr i8, i8* %11, i64 20, !dbg !750
  %72 = load i8, i8* %71, align 2, !dbg !750, !tbaa !397
  %73 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 1, !dbg !751
  store i8 %72, i8* %73, align 1, !dbg !752, !tbaa !713
  %74 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 3, !dbg !753
  store i16 0, i16* %74, align 4, !dbg !754, !tbaa !716
  %75 = getelementptr i8, i8* %11, i64 18, !dbg !755
  %76 = bitcast i8* %75 to i16*, !dbg !755
  %77 = load i16, i16* %76, align 4, !dbg !755, !tbaa !756
  %78 = tail call i16 @llvm.bswap.i16(i16 %77)
  %79 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 4, !dbg !757
  store i16 %78, i16* %79, align 2, !dbg !758, !tbaa !721
  %80 = getelementptr i8, i8* %11, i64 22, !dbg !759
  %81 = bitcast i32* %55 to i8*, !dbg !759
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %81, i8* noundef nonnull align 4 dereferenceable(16) %80, i64 16, i1 false), !dbg !759, !tbaa.struct !453
  %82 = getelementptr i8, i8* %11, i64 38, !dbg !760
  %83 = bitcast i32* %56 to i8*, !dbg !760
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %83, i8* noundef nonnull align 4 dereferenceable(16) %82, i64 16, i1 false), !dbg !760, !tbaa.struct !453
  call void @llvm.dbg.value(metadata i32 2, metadata !665, metadata !DIExpression()), !dbg !672
  br label %84

84:                                               ; preds = %66, %30
  %85 = phi %struct.iphdr* [ %21, %30 ], [ undef, %66 ]
  %86 = phi %struct.ipv6hdr* [ undef, %30 ], [ %57, %66 ]
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %86, metadata !660, metadata !DIExpression()), !dbg !672
  call void @llvm.dbg.value(metadata i32 2, metadata !665, metadata !DIExpression()), !dbg !672
  call void @llvm.dbg.value(metadata %struct.iphdr* %85, metadata !661, metadata !DIExpression()), !dbg !672
  %87 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 3, !dbg !761
  %88 = load i32, i32* %87, align 4, !dbg !761, !tbaa !762
  %89 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 5, !dbg !763
  store i32 %88, i32* %89, align 4, !dbg !764, !tbaa !765
  %90 = bitcast %struct.xdp_md* %0 to i8*, !dbg !766
  %91 = call i32 inttoptr (i64 69 to i32 (i8*, %struct.bpf_fib_lookup*, i32, i32)*)(i8* noundef %90, %struct.bpf_fib_lookup* noundef nonnull %3, i32 noundef 64, i32 noundef 0) #8, !dbg !767
  call void @llvm.dbg.value(metadata i32 %91, metadata !664, metadata !DIExpression()), !dbg !672
  switch i32 %91, label %110 [
    i32 0, label %92
    i32 1, label %109
    i32 2, label %109
    i32 3, label %109
  ], !dbg !768

92:                                               ; preds = %84
  br i1 %19, label %93, label %103, !dbg !769

93:                                               ; preds = %92
  call void @llvm.dbg.value(metadata %struct.iphdr* %85, metadata !771, metadata !DIExpression()), !dbg !777
  %94 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %85, i64 0, i32 7, !dbg !780
  %95 = load i16, i16* %94, align 2, !dbg !780, !tbaa !781
  call void @llvm.dbg.value(metadata i16 %95, metadata !776, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !777
  %96 = add i16 %95, 1, !dbg !782
  call void @llvm.dbg.value(metadata i16 %95, metadata !776, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !777
  %97 = icmp ugt i16 %95, -3, !dbg !783
  %98 = zext i1 %97 to i16, !dbg !783
  %99 = add i16 %96, %98, !dbg !784
  store i16 %99, i16* %94, align 2, !dbg !785, !tbaa !781
  %100 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %85, i64 0, i32 5, !dbg !786
  %101 = load i8, i8* %100, align 4, !dbg !787, !tbaa !700
  %102 = add i8 %101, -1, !dbg !787
  store i8 %102, i8* %100, align 4, !dbg !787, !tbaa !700
  br label %113, !dbg !788

103:                                              ; preds = %92
  %104 = icmp eq i16 %18, -8826, !dbg !789
  br i1 %104, label %105, label %113, !dbg !791

105:                                              ; preds = %103
  %106 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %86, i64 0, i32 4, !dbg !792
  %107 = load i8, i8* %106, align 1, !dbg !793, !tbaa !742
  %108 = add i8 %107, -1, !dbg !793
  store i8 %108, i8* %106, align 1, !dbg !793, !tbaa !742
  br label %113, !dbg !794

109:                                              ; preds = %84, %84, %84
  call void @llvm.dbg.value(metadata i32 1, metadata !665, metadata !DIExpression()), !dbg !672
  br label %110, !dbg !795

110:                                              ; preds = %26, %84, %109, %52, %1, %20, %54, %62
  %111 = phi i32 [ 1, %20 ], [ 1, %1 ], [ 2, %52 ], [ 1, %109 ], [ 2, %84 ], [ 2, %26 ], [ 2, %62 ], [ 1, %54 ]
  call void @llvm.dbg.value(metadata i32 %119, metadata !665, metadata !DIExpression()), !dbg !672
  call void @llvm.dbg.label(metadata !671), !dbg !796
  %112 = bitcast i32* %2 to i8*, !dbg !797
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %112), !dbg !797
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !513, metadata !DIExpression()) #8, !dbg !797
  call void @llvm.dbg.value(metadata i32 %119, metadata !514, metadata !DIExpression()) #8, !dbg !797
  store i32 %111, i32* %2, align 4, !tbaa !523
  br label %122, !dbg !799

113:                                              ; preds = %93, %105, %103
  %114 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 0, i64 0, !dbg !800
  %115 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 12, i64 0, !dbg !800
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) %114, i8* noundef nonnull align 2 dereferenceable(6) %115, i64 6, i1 false), !dbg !800
  %116 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 1, i64 0, !dbg !801
  %117 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 11, i64 0, !dbg !801
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) %116, i8* noundef nonnull align 4 dereferenceable(6) %117, i64 6, i1 false), !dbg !801
  %118 = load i32, i32* %89, align 4, !dbg !802, !tbaa !765
  %119 = call i32 inttoptr (i64 23 to i32 (i32, i64)*)(i32 noundef %118, i64 noundef 0) #8, !dbg !803
  call void @llvm.dbg.value(metadata i32 %119, metadata !665, metadata !DIExpression()), !dbg !672
  call void @llvm.dbg.label(metadata !671), !dbg !796
  %120 = bitcast i32* %2 to i8*, !dbg !797
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %120), !dbg !797
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !513, metadata !DIExpression()) #8, !dbg !797
  call void @llvm.dbg.value(metadata i32 %119, metadata !514, metadata !DIExpression()) #8, !dbg !797
  store i32 %119, i32* %2, align 4, !tbaa !523
  %121 = icmp ugt i32 %119, 4, !dbg !804
  br i1 %121, label %139, label %122, !dbg !799

122:                                              ; preds = %110, %113
  %123 = bitcast i32* %2 to i8*
  call void @llvm.dbg.value(metadata i32* %2, metadata !514, metadata !DIExpression(DW_OP_deref)) #8, !dbg !797
  %124 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* noundef nonnull %123) #8, !dbg !805
  call void @llvm.dbg.value(metadata i8* %124, metadata !515, metadata !DIExpression()) #8, !dbg !797
  %125 = icmp eq i8* %124, null, !dbg !806
  br i1 %125, label %139, label %126, !dbg !807

126:                                              ; preds = %122
  call void @llvm.dbg.value(metadata i8* %124, metadata !515, metadata !DIExpression()) #8, !dbg !797
  %127 = bitcast i8* %124 to i64*, !dbg !808
  %128 = load i64, i64* %127, align 8, !dbg !809, !tbaa !530
  %129 = add i64 %128, 1, !dbg !809
  store i64 %129, i64* %127, align 8, !dbg !809, !tbaa !530
  %130 = load i32, i32* %4, align 4, !dbg !810, !tbaa !268
  %131 = load i32, i32* %8, align 4, !dbg !811, !tbaa !276
  %132 = sub i32 %130, %131, !dbg !812
  %133 = zext i32 %132 to i64, !dbg !813
  %134 = getelementptr inbounds i8, i8* %124, i64 8, !dbg !814
  %135 = bitcast i8* %134 to i64*, !dbg !814
  %136 = load i64, i64* %135, align 8, !dbg !815, !tbaa !539
  %137 = add i64 %136, %133, !dbg !815
  store i64 %137, i64* %135, align 8, !dbg !815, !tbaa !539
  %138 = load i32, i32* %2, align 4, !dbg !816, !tbaa !523
  call void @llvm.dbg.value(metadata i32 %138, metadata !514, metadata !DIExpression()) #8, !dbg !797
  br label %139, !dbg !817

139:                                              ; preds = %113, %122, %126
  %140 = phi i32 [ 0, %113 ], [ %138, %126 ], [ 0, %122 ], !dbg !797
  %141 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %141), !dbg !818
  call void @llvm.lifetime.end.p0i8(i64 64, i8* nonnull %12) #8, !dbg !819
  ret i32 %140, !dbg !819
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #4

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readnone %0) #5 section "xdp_pass" !dbg !820 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !822, metadata !DIExpression()), !dbg !823
  ret i32 2, !dbg !824
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #6

; Function Attrs: nounwind readnone
declare i1 @llvm.bpf.passthrough.i1.i1(i32, i1) #7

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #4 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #5 = { mustprogress nofree norecurse nosync nounwind readnone willreturn "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #6 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #7 = { nounwind readnone }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!162, !163, !164, !165}
!llvm.ident = !{!166}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !161, line: 16, type: !80, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !45, globals: !77, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet03-redirecting", checksumkind: CSK_MD5, checksum: "bfcc14c71c6cf98635aa68e9ac7d9455")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet03-redirecting", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
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
!45 = !{!46, !47, !48, !51, !76, !73}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!47 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !49, line: 24, baseType: !50)
!49 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!50 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !53, line: 33, size: 128, elements: !54)
!53 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "", checksumkind: CSK_MD5, checksum: "8bebb780b45d3fe932cc1d934fa5f5fe")
!54 = !{!55}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !52, file: !53, line: 40, baseType: !56, size: 128)
!56 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !52, file: !53, line: 34, size: 128, elements: !57)
!57 = !{!58, !64, !70}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !56, file: !53, line: 35, baseType: !59, size: 128)
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 128, elements: !62)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !49, line: 21, baseType: !61)
!61 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!62 = !{!63}
!63 = !DISubrange(count: 16)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !56, file: !53, line: 37, baseType: !65, size: 128)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 128, elements: !68)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !67, line: 25, baseType: !48)
!67 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!68 = !{!69}
!69 = !DISubrange(count: 8)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !56, file: !53, line: 38, baseType: !71, size: 128)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 128, elements: !74)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !67, line: 27, baseType: !73)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !49, line: 27, baseType: !7)
!74 = !{!75}
!75 = !DISubrange(count: 4)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!77 = !{!0, !78, !88, !90, !94, !103, !111, !118, !123}
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "tx_port", scope: !2, file: !3, line: 18, type: !80, isLocal: false, isDefinition: true)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !81, line: 33, size: 160, elements: !82)
!81 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet03-redirecting", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!82 = !{!83, !84, !85, !86, !87}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !80, file: !81, line: 34, baseType: !7, size: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !80, file: !81, line: 35, baseType: !7, size: 32, offset: 32)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !80, file: !81, line: 36, baseType: !7, size: 32, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !80, file: !81, line: 37, baseType: !7, size: 32, offset: 96)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !80, file: !81, line: 38, baseType: !7, size: 32, offset: 128)
!88 = !DIGlobalVariableExpression(var: !89, expr: !DIExpression())
!89 = distinct !DIGlobalVariable(name: "redirect_params", scope: !2, file: !3, line: 25, type: !80, isLocal: false, isDefinition: true)
!90 = !DIGlobalVariableExpression(var: !91, expr: !DIExpression())
!91 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 366, type: !92, isLocal: false, isDefinition: true)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !93, size: 32, elements: !74)
!93 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!94 = !DIGlobalVariableExpression(var: !95, expr: !DIExpression())
!95 = distinct !DIGlobalVariable(name: "bpf_csum_diff", scope: !2, file: !96, line: 764, type: !97, isLocal: true, isDefinition: true)
!96 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet03-redirecting", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = !DISubroutineType(types: !99)
!99 = !{!100, !76, !73, !76, !73, !102}
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "__s64", file: !49, line: 30, baseType: !101)
!101 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "__wsum", file: !67, line: 32, baseType: !73)
!103 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression())
!104 = distinct !DIGlobalVariable(name: "bpf_redirect", scope: !2, file: !96, line: 589, type: !105, isLocal: true, isDefinition: true)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = !DISubroutineType(types: !107)
!107 = !{!108, !73, !109}
!108 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !49, line: 31, baseType: !110)
!110 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!111 = !DIGlobalVariableExpression(var: !112, expr: !DIExpression())
!112 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !96, line: 33, type: !113, isLocal: true, isDefinition: true)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = !DISubroutineType(types: !115)
!115 = !{!46, !46, !116}
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!118 = !DIGlobalVariableExpression(var: !119, expr: !DIExpression())
!119 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !96, line: 1254, type: !120, isLocal: true, isDefinition: true)
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!121 = !DISubroutineType(types: !122)
!122 = !{!108, !46, !73, !109}
!123 = !DIGlobalVariableExpression(var: !124, expr: !DIExpression())
!124 = distinct !DIGlobalVariable(name: "bpf_fib_lookup", scope: !2, file: !96, line: 1764, type: !125, isLocal: true, isDefinition: true)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = !DISubroutineType(types: !127)
!127 = !{!108, !46, !128, !108, !73}
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !129, size: 64)
!129 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_fib_lookup", file: !6, line: 3179, size: 512, elements: !130)
!130 = !{!131, !132, !133, !134, !135, !136, !137, !143, !149, !154, !155, !156, !160}
!131 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !129, file: !6, line: 3183, baseType: !60, size: 8)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "l4_protocol", scope: !129, file: !6, line: 3186, baseType: !60, size: 8, offset: 8)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !129, file: !6, line: 3187, baseType: !66, size: 16, offset: 16)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !129, file: !6, line: 3188, baseType: !66, size: 16, offset: 32)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !129, file: !6, line: 3191, baseType: !48, size: 16, offset: 48)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !129, file: !6, line: 3196, baseType: !73, size: 32, offset: 64)
!137 = !DIDerivedType(tag: DW_TAG_member, scope: !129, file: !6, line: 3198, baseType: !138, size: 32, offset: 96)
!138 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !129, file: !6, line: 3198, size: 32, elements: !139)
!139 = !{!140, !141, !142}
!140 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !138, file: !6, line: 3200, baseType: !60, size: 8)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "flowinfo", scope: !138, file: !6, line: 3201, baseType: !72, size: 32)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "rt_metric", scope: !138, file: !6, line: 3204, baseType: !73, size: 32)
!143 = !DIDerivedType(tag: DW_TAG_member, scope: !129, file: !6, line: 3207, baseType: !144, size: 128, offset: 128)
!144 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !129, file: !6, line: 3207, size: 128, elements: !145)
!145 = !{!146, !147}
!146 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !144, file: !6, line: 3208, baseType: !72, size: 32)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !144, file: !6, line: 3209, baseType: !148, size: 128)
!148 = !DICompositeType(tag: DW_TAG_array_type, baseType: !73, size: 128, elements: !74)
!149 = !DIDerivedType(tag: DW_TAG_member, scope: !129, file: !6, line: 3216, baseType: !150, size: 128, offset: 256)
!150 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !129, file: !6, line: 3216, size: 128, elements: !151)
!151 = !{!152, !153}
!152 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !150, file: !6, line: 3217, baseType: !72, size: 32)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !150, file: !6, line: 3218, baseType: !148, size: 128)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_proto", scope: !129, file: !6, line: 3222, baseType: !66, size: 16, offset: 384)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !129, file: !6, line: 3223, baseType: !66, size: 16, offset: 400)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "smac", scope: !129, file: !6, line: 3224, baseType: !157, size: 48, offset: 416)
!157 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 48, elements: !158)
!158 = !{!159}
!159 = !DISubrange(count: 6)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "dmac", scope: !129, file: !6, line: 3225, baseType: !157, size: 48, offset: 464)
!161 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet03-redirecting", checksumkind: CSK_MD5, checksum: "0f65d57b07088eec24d5031993b90668")
!162 = !{i32 7, !"Dwarf Version", i32 5}
!163 = !{i32 2, !"Debug Info Version", i32 3}
!164 = !{i32 1, !"wchar_size", i32 4}
!165 = !{i32 7, !"frame-pointer", i32 2}
!166 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!167 = distinct !DISubprogram(name: "xdp_icmp_echo_func", scope: !3, file: !3, line: 90, type: !168, scopeLine: 91, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !178)
!168 = !DISubroutineType(types: !169)
!169 = !{!108, !170}
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !171, size: 64)
!171 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !172)
!172 = !{!173, !174, !175, !176, !177}
!173 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !171, file: !6, line: 2857, baseType: !73, size: 32)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !171, file: !6, line: 2858, baseType: !73, size: 32, offset: 32)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !171, file: !6, line: 2859, baseType: !73, size: 32, offset: 64)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !171, file: !6, line: 2861, baseType: !73, size: 32, offset: 96)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !171, file: !6, line: 2862, baseType: !73, size: 32, offset: 128)
!178 = !{!179, !180, !181, !182, !187, !196, !197, !198, !199, !227, !254, !255, !256, !263, !264, !265}
!179 = !DILocalVariable(name: "ctx", arg: 1, scope: !167, file: !3, line: 90, type: !170)
!180 = !DILocalVariable(name: "data_end", scope: !167, file: !3, line: 92, type: !46)
!181 = !DILocalVariable(name: "data", scope: !167, file: !3, line: 93, type: !46)
!182 = !DILocalVariable(name: "nh", scope: !167, file: !3, line: 94, type: !183)
!183 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !184, line: 33, size: 64, elements: !185)
!184 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet03-redirecting", checksumkind: CSK_MD5, checksum: "172efdd203783aed49c0ce78645261a8")
!185 = !{!186}
!186 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !183, file: !184, line: 34, baseType: !46, size: 64)
!187 = !DILocalVariable(name: "eth", scope: !167, file: !3, line: 95, type: !188)
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !189, size: 64)
!189 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !190, line: 168, size: 112, elements: !191)
!190 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!191 = !{!192, !194, !195}
!192 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !189, file: !190, line: 169, baseType: !193, size: 48)
!193 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 48, elements: !158)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !189, file: !190, line: 170, baseType: !193, size: 48, offset: 48)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !189, file: !190, line: 171, baseType: !66, size: 16, offset: 96)
!196 = !DILocalVariable(name: "eth_type", scope: !167, file: !3, line: 96, type: !108)
!197 = !DILocalVariable(name: "ip_type", scope: !167, file: !3, line: 97, type: !108)
!198 = !DILocalVariable(name: "icmp_type", scope: !167, file: !3, line: 98, type: !108)
!199 = !DILocalVariable(name: "iphdr", scope: !167, file: !3, line: 99, type: !200)
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !201, size: 64)
!201 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !202, line: 86, size: 160, elements: !203)
!202 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "4e88ed297bc3832dfa96a5c9b60cec92")
!203 = !{!204, !205, !206, !207, !208, !209, !210, !211, !212, !214}
!204 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !201, file: !202, line: 88, baseType: !60, size: 4, flags: DIFlagBitField, extraData: i64 0)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !201, file: !202, line: 89, baseType: !60, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !201, file: !202, line: 96, baseType: !60, size: 8, offset: 8)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !201, file: !202, line: 97, baseType: !66, size: 16, offset: 16)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !201, file: !202, line: 98, baseType: !66, size: 16, offset: 32)
!209 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !201, file: !202, line: 99, baseType: !66, size: 16, offset: 48)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !201, file: !202, line: 100, baseType: !60, size: 8, offset: 64)
!211 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !201, file: !202, line: 101, baseType: !60, size: 8, offset: 72)
!212 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !201, file: !202, line: 102, baseType: !213, size: 16, offset: 80)
!213 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !67, line: 31, baseType: !48)
!214 = !DIDerivedType(tag: DW_TAG_member, scope: !201, file: !202, line: 103, baseType: !215, size: 64, offset: 96)
!215 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !201, file: !202, line: 103, size: 64, elements: !216)
!216 = !{!217, !222}
!217 = !DIDerivedType(tag: DW_TAG_member, scope: !215, file: !202, line: 103, baseType: !218, size: 64)
!218 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !215, file: !202, line: 103, size: 64, elements: !219)
!219 = !{!220, !221}
!220 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !218, file: !202, line: 103, baseType: !72, size: 32)
!221 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !218, file: !202, line: 103, baseType: !72, size: 32, offset: 32)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !215, file: !202, line: 103, baseType: !223, size: 64)
!223 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !215, file: !202, line: 103, size: 64, elements: !224)
!224 = !{!225, !226}
!225 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !223, file: !202, line: 103, baseType: !72, size: 32)
!226 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !223, file: !202, line: 103, baseType: !72, size: 32, offset: 32)
!227 = !DILocalVariable(name: "ipv6hdr", scope: !167, file: !3, line: 100, type: !228)
!228 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !229, size: 64)
!229 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !230, line: 117, size: 320, elements: !231)
!230 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "0a3e356f53cd1c3f0cebfdeaff4287e2")
!231 = !{!232, !233, !234, !238, !239, !240, !241}
!232 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !229, file: !230, line: 119, baseType: !60, size: 4, flags: DIFlagBitField, extraData: i64 0)
!233 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !229, file: !230, line: 120, baseType: !60, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!234 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !229, file: !230, line: 127, baseType: !235, size: 24, offset: 8)
!235 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 24, elements: !236)
!236 = !{!237}
!237 = !DISubrange(count: 3)
!238 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !229, file: !230, line: 129, baseType: !66, size: 16, offset: 32)
!239 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !229, file: !230, line: 130, baseType: !60, size: 8, offset: 48)
!240 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !229, file: !230, line: 131, baseType: !60, size: 8, offset: 56)
!241 = !DIDerivedType(tag: DW_TAG_member, scope: !229, file: !230, line: 133, baseType: !242, size: 256, offset: 64)
!242 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !229, file: !230, line: 133, size: 256, elements: !243)
!243 = !{!244, !249}
!244 = !DIDerivedType(tag: DW_TAG_member, scope: !242, file: !230, line: 133, baseType: !245, size: 256)
!245 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !242, file: !230, line: 133, size: 256, elements: !246)
!246 = !{!247, !248}
!247 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !245, file: !230, line: 133, baseType: !52, size: 128)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !245, file: !230, line: 133, baseType: !52, size: 128, offset: 128)
!249 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !242, file: !230, line: 133, baseType: !250, size: 256)
!250 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !242, file: !230, line: 133, size: 256, elements: !251)
!251 = !{!252, !253}
!252 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !250, file: !230, line: 133, baseType: !52, size: 128)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !250, file: !230, line: 133, baseType: !52, size: 128, offset: 128)
!254 = !DILocalVariable(name: "echo_reply", scope: !167, file: !3, line: 101, type: !48)
!255 = !DILocalVariable(name: "old_csum", scope: !167, file: !3, line: 101, type: !48)
!256 = !DILocalVariable(name: "icmphdr", scope: !167, file: !3, line: 102, type: !257)
!257 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !258, size: 64)
!258 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr_common", file: !184, line: 51, size: 32, elements: !259)
!259 = !{!260, !261, !262}
!260 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !258, file: !184, line: 52, baseType: !60, size: 8)
!261 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !258, file: !184, line: 53, baseType: !60, size: 8, offset: 8)
!262 = !DIDerivedType(tag: DW_TAG_member, name: "cksum", scope: !258, file: !184, line: 54, baseType: !213, size: 16, offset: 16)
!263 = !DILocalVariable(name: "icmphdr_old", scope: !167, file: !3, line: 103, type: !258)
!264 = !DILocalVariable(name: "action", scope: !167, file: !3, line: 104, type: !73)
!265 = !DILabel(scope: !167, name: "out", file: !3, line: 159)
!266 = !DILocation(line: 0, scope: !167)
!267 = !DILocation(line: 92, column: 38, scope: !167)
!268 = !{!269, !270, i64 4}
!269 = !{!"xdp_md", !270, i64 0, !270, i64 4, !270, i64 8, !270, i64 12, !270, i64 16}
!270 = !{!"int", !271, i64 0}
!271 = !{!"omnipotent char", !272, i64 0}
!272 = !{!"Simple C/C++ TBAA"}
!273 = !DILocation(line: 92, column: 27, scope: !167)
!274 = !DILocation(line: 92, column: 19, scope: !167)
!275 = !DILocation(line: 93, column: 34, scope: !167)
!276 = !{!269, !270, i64 0}
!277 = !DILocation(line: 93, column: 23, scope: !167)
!278 = !DILocation(line: 93, column: 15, scope: !167)
!279 = !DILocation(line: 103, column: 2, scope: !167)
!280 = !DILocalVariable(name: "nh", arg: 1, scope: !281, file: !184, line: 124, type: !284)
!281 = distinct !DISubprogram(name: "parse_ethhdr", scope: !184, file: !184, line: 124, type: !282, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !286)
!282 = !DISubroutineType(types: !283)
!283 = !{!108, !284, !46, !285}
!284 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !183, size: 64)
!285 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !188, size: 64)
!286 = !{!280, !287, !288}
!287 = !DILocalVariable(name: "data_end", arg: 2, scope: !281, file: !184, line: 125, type: !46)
!288 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !281, file: !184, line: 126, type: !285)
!289 = !DILocation(line: 0, scope: !281, inlinedAt: !290)
!290 = distinct !DILocation(line: 110, column: 13, scope: !167)
!291 = !DILocalVariable(name: "nh", arg: 1, scope: !292, file: !184, line: 79, type: !284)
!292 = distinct !DISubprogram(name: "parse_ethhdr_vlan", scope: !184, file: !184, line: 79, type: !293, scopeLine: 83, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !302)
!293 = !DISubroutineType(types: !294)
!294 = !{!108, !284, !46, !285, !295}
!295 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !296, size: 64)
!296 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "collect_vlans", file: !184, line: 64, size: 32, elements: !297)
!297 = !{!298}
!298 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !296, file: !184, line: 65, baseType: !299, size: 32)
!299 = !DICompositeType(tag: DW_TAG_array_type, baseType: !48, size: 32, elements: !300)
!300 = !{!301}
!301 = !DISubrange(count: 2)
!302 = !{!291, !303, !304, !305, !306, !307, !308, !314, !315}
!303 = !DILocalVariable(name: "data_end", arg: 2, scope: !292, file: !184, line: 80, type: !46)
!304 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !292, file: !184, line: 81, type: !285)
!305 = !DILocalVariable(name: "vlans", arg: 4, scope: !292, file: !184, line: 82, type: !295)
!306 = !DILocalVariable(name: "eth", scope: !292, file: !184, line: 84, type: !188)
!307 = !DILocalVariable(name: "hdrsize", scope: !292, file: !184, line: 85, type: !108)
!308 = !DILocalVariable(name: "vlh", scope: !292, file: !184, line: 86, type: !309)
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !310, size: 64)
!310 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !184, line: 42, size: 32, elements: !311)
!311 = !{!312, !313}
!312 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !310, file: !184, line: 43, baseType: !66, size: 16)
!313 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !310, file: !184, line: 44, baseType: !66, size: 16, offset: 16)
!314 = !DILocalVariable(name: "h_proto", scope: !292, file: !184, line: 87, type: !48)
!315 = !DILocalVariable(name: "i", scope: !292, file: !184, line: 88, type: !108)
!316 = !DILocation(line: 0, scope: !292, inlinedAt: !317)
!317 = distinct !DILocation(line: 129, column: 9, scope: !281, inlinedAt: !290)
!318 = !DILocation(line: 93, column: 14, scope: !319, inlinedAt: !317)
!319 = distinct !DILexicalBlock(scope: !292, file: !184, line: 93, column: 6)
!320 = !DILocation(line: 93, column: 24, scope: !319, inlinedAt: !317)
!321 = !DILocation(line: 93, column: 6, scope: !292, inlinedAt: !317)
!322 = !DILocation(line: 97, column: 10, scope: !292, inlinedAt: !317)
!323 = !DILocation(line: 99, column: 17, scope: !292, inlinedAt: !317)
!324 = !{!325, !325, i64 0}
!325 = !{!"short", !271, i64 0}
!326 = !DILocalVariable(name: "h_proto", arg: 1, scope: !327, file: !184, line: 68, type: !48)
!327 = distinct !DISubprogram(name: "proto_is_vlan", scope: !184, file: !184, line: 68, type: !328, scopeLine: 69, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !330)
!328 = !DISubroutineType(types: !329)
!329 = !{!108, !48}
!330 = !{!326}
!331 = !DILocation(line: 0, scope: !327, inlinedAt: !332)
!332 = distinct !DILocation(line: 106, column: 8, scope: !333, inlinedAt: !317)
!333 = distinct !DILexicalBlock(scope: !334, file: !184, line: 106, column: 7)
!334 = distinct !DILexicalBlock(scope: !335, file: !184, line: 105, column: 39)
!335 = distinct !DILexicalBlock(scope: !336, file: !184, line: 105, column: 2)
!336 = distinct !DILexicalBlock(scope: !292, file: !184, line: 105, column: 2)
!337 = !DILocation(line: 70, column: 20, scope: !327, inlinedAt: !332)
!338 = !DILocation(line: 70, column: 46, scope: !327, inlinedAt: !332)
!339 = !DILocation(line: 106, column: 8, scope: !333, inlinedAt: !317)
!340 = !DILocation(line: 106, column: 7, scope: !334, inlinedAt: !317)
!341 = !DILocation(line: 112, column: 18, scope: !334, inlinedAt: !317)
!342 = !DILocation(line: 111, column: 6, scope: !167)
!343 = !DILocalVariable(name: "nh", arg: 1, scope: !344, file: !184, line: 151, type: !284)
!344 = distinct !DISubprogram(name: "parse_iphdr", scope: !184, file: !184, line: 151, type: !345, scopeLine: 154, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !348)
!345 = !DISubroutineType(types: !346)
!346 = !{!108, !284, !46, !347}
!347 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !200, size: 64)
!348 = !{!343, !349, !350, !351, !352}
!349 = !DILocalVariable(name: "data_end", arg: 2, scope: !344, file: !184, line: 152, type: !46)
!350 = !DILocalVariable(name: "iphdr", arg: 3, scope: !344, file: !184, line: 153, type: !347)
!351 = !DILocalVariable(name: "iph", scope: !344, file: !184, line: 155, type: !200)
!352 = !DILocalVariable(name: "hdrsize", scope: !344, file: !184, line: 156, type: !108)
!353 = !DILocation(line: 0, scope: !344, inlinedAt: !354)
!354 = distinct !DILocation(line: 112, column: 13, scope: !355)
!355 = distinct !DILexicalBlock(scope: !356, file: !3, line: 111, column: 39)
!356 = distinct !DILexicalBlock(scope: !167, file: !3, line: 111, column: 6)
!357 = !DILocation(line: 158, column: 10, scope: !358, inlinedAt: !354)
!358 = distinct !DILexicalBlock(scope: !344, file: !184, line: 158, column: 6)
!359 = !DILocation(line: 158, column: 14, scope: !358, inlinedAt: !354)
!360 = !DILocation(line: 158, column: 6, scope: !344, inlinedAt: !354)
!361 = !DILocation(line: 161, column: 17, scope: !344, inlinedAt: !354)
!362 = !DILocation(line: 161, column: 21, scope: !344, inlinedAt: !354)
!363 = !DILocation(line: 163, column: 13, scope: !364, inlinedAt: !354)
!364 = distinct !DILexicalBlock(scope: !344, file: !184, line: 163, column: 5)
!365 = !DILocation(line: 163, column: 5, scope: !344, inlinedAt: !354)
!366 = !DILocation(line: 167, column: 14, scope: !367, inlinedAt: !354)
!367 = distinct !DILexicalBlock(scope: !344, file: !184, line: 167, column: 6)
!368 = !DILocation(line: 167, column: 24, scope: !367, inlinedAt: !354)
!369 = !DILocation(line: 167, column: 6, scope: !344, inlinedAt: !354)
!370 = !DILocation(line: 171, column: 9, scope: !344, inlinedAt: !354)
!371 = !DILocation(line: 173, column: 14, scope: !344, inlinedAt: !354)
!372 = !{!373, !271, i64 9}
!373 = !{!"iphdr", !271, i64 0, !271, i64 0, !271, i64 1, !325, i64 2, !325, i64 4, !325, i64 6, !271, i64 8, !271, i64 9, !325, i64 10, !271, i64 12}
!374 = !DILocation(line: 113, column: 15, scope: !375)
!375 = distinct !DILexicalBlock(scope: !355, file: !3, line: 113, column: 7)
!376 = !DILocation(line: 113, column: 7, scope: !355)
!377 = !DILocalVariable(name: "nh", arg: 1, scope: !378, file: !184, line: 132, type: !284)
!378 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !184, file: !184, line: 132, type: !379, scopeLine: 135, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !382)
!379 = !DISubroutineType(types: !380)
!380 = !{!108, !284, !46, !381}
!381 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !228, size: 64)
!382 = !{!377, !383, !384, !385}
!383 = !DILocalVariable(name: "data_end", arg: 2, scope: !378, file: !184, line: 133, type: !46)
!384 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !378, file: !184, line: 134, type: !381)
!385 = !DILocalVariable(name: "ip6h", scope: !378, file: !184, line: 136, type: !228)
!386 = !DILocation(line: 0, scope: !378, inlinedAt: !387)
!387 = distinct !DILocation(line: 116, column: 13, scope: !388)
!388 = distinct !DILexicalBlock(scope: !389, file: !3, line: 115, column: 48)
!389 = distinct !DILexicalBlock(scope: !356, file: !3, line: 115, column: 13)
!390 = !DILocation(line: 142, column: 11, scope: !391, inlinedAt: !387)
!391 = distinct !DILexicalBlock(scope: !378, file: !184, line: 142, column: 6)
!392 = !DILocation(line: 142, column: 17, scope: !391, inlinedAt: !387)
!393 = !DILocation(line: 142, column: 15, scope: !391, inlinedAt: !387)
!394 = !DILocation(line: 142, column: 6, scope: !378, inlinedAt: !387)
!395 = !DILocation(line: 136, column: 29, scope: !378, inlinedAt: !387)
!396 = !DILocation(line: 148, column: 15, scope: !378, inlinedAt: !387)
!397 = !{!398, !271, i64 6}
!398 = !{!"ipv6hdr", !271, i64 0, !271, i64 0, !271, i64 1, !325, i64 4, !271, i64 6, !271, i64 7, !271, i64 8}
!399 = !DILocation(line: 117, column: 15, scope: !400)
!400 = distinct !DILexicalBlock(scope: !388, file: !3, line: 117, column: 7)
!401 = !DILocation(line: 117, column: 7, scope: !388)
!402 = !DILocation(line: 107, column: 9, scope: !167)
!403 = !DILocalVariable(name: "nh", arg: 1, scope: !404, file: !184, line: 206, type: !284)
!404 = distinct !DISubprogram(name: "parse_icmphdr_common", scope: !184, file: !184, line: 206, type: !405, scopeLine: 209, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !408)
!405 = !DISubroutineType(types: !406)
!406 = !{!108, !284, !46, !407}
!407 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !257, size: 64)
!408 = !{!403, !409, !410, !411}
!409 = !DILocalVariable(name: "data_end", arg: 2, scope: !404, file: !184, line: 207, type: !46)
!410 = !DILocalVariable(name: "icmphdr", arg: 3, scope: !404, file: !184, line: 208, type: !407)
!411 = !DILocalVariable(name: "h", scope: !404, file: !184, line: 210, type: !257)
!412 = !DILocation(line: 0, scope: !404, inlinedAt: !413)
!413 = distinct !DILocation(line: 129, column: 14, scope: !167)
!414 = !DILocation(line: 212, column: 8, scope: !415, inlinedAt: !413)
!415 = distinct !DILexicalBlock(scope: !404, file: !184, line: 212, column: 6)
!416 = !DILocation(line: 212, column: 14, scope: !415, inlinedAt: !413)
!417 = !DILocation(line: 212, column: 12, scope: !415, inlinedAt: !413)
!418 = !DILocation(line: 212, column: 6, scope: !404, inlinedAt: !413)
!419 = !DILocation(line: 218, column: 12, scope: !404, inlinedAt: !413)
!420 = !{!421, !271, i64 0}
!421 = !{!"icmphdr_common", !271, i64 0, !271, i64 1, !325, i64 2}
!422 = !DILocation(line: 130, column: 38, scope: !423)
!423 = distinct !DILexicalBlock(scope: !167, file: !3, line: 130, column: 6)
!424 = !DILocalVariable(name: "iphdr", arg: 1, scope: !425, file: !3, line: 51, type: !200)
!425 = distinct !DISubprogram(name: "swap_src_dst_ipv4", scope: !3, file: !3, line: 51, type: !426, scopeLine: 52, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !428)
!426 = !DISubroutineType(types: !427)
!427 = !{null, !200}
!428 = !{!424, !429}
!429 = !DILocalVariable(name: "tmp", scope: !425, file: !3, line: 54, type: !72)
!430 = !DILocation(line: 0, scope: !425, inlinedAt: !431)
!431 = distinct !DILocation(line: 132, column: 3, scope: !432)
!432 = distinct !DILexicalBlock(scope: !423, file: !3, line: 130, column: 65)
!433 = !DILocation(line: 54, column: 22, scope: !425, inlinedAt: !431)
!434 = !{!271, !271, i64 0}
!435 = !DILocation(line: 56, column: 24, scope: !425, inlinedAt: !431)
!436 = !DILocation(line: 56, column: 15, scope: !425, inlinedAt: !431)
!437 = !DILocation(line: 57, column: 15, scope: !425, inlinedAt: !431)
!438 = !DILocation(line: 134, column: 2, scope: !432)
!439 = !DILocation(line: 135, column: 6, scope: !440)
!440 = distinct !DILexicalBlock(scope: !423, file: !3, line: 134, column: 13)
!441 = !DILocalVariable(name: "tmp", scope: !442, file: !3, line: 45, type: !52)
!442 = distinct !DISubprogram(name: "swap_src_dst_ipv6", scope: !3, file: !3, line: 42, type: !443, scopeLine: 43, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !445)
!443 = !DISubroutineType(types: !444)
!444 = !{null, !228}
!445 = !{!446, !441}
!446 = !DILocalVariable(name: "ipv6", arg: 1, scope: !442, file: !3, line: 42, type: !228)
!447 = !DILocation(line: 45, column: 18, scope: !442, inlinedAt: !448)
!448 = distinct !DILocation(line: 137, column: 3, scope: !449)
!449 = distinct !DILexicalBlock(scope: !440, file: !3, line: 135, column: 43)
!450 = !DILocation(line: 0, scope: !442, inlinedAt: !448)
!451 = !DILocation(line: 45, column: 2, scope: !442, inlinedAt: !448)
!452 = !DILocation(line: 45, column: 30, scope: !442, inlinedAt: !448)
!453 = !{i64 0, i64 16, !434, i64 0, i64 16, !434, i64 0, i64 16, !434}
!454 = !DILocation(line: 47, column: 8, scope: !442, inlinedAt: !448)
!455 = !DILocation(line: 47, column: 22, scope: !442, inlinedAt: !448)
!456 = !DILocation(line: 48, column: 16, scope: !442, inlinedAt: !448)
!457 = !DILocation(line: 49, column: 1, scope: !442, inlinedAt: !448)
!458 = !DILocalVariable(name: "eth", arg: 1, scope: !459, file: !3, line: 31, type: !188)
!459 = distinct !DISubprogram(name: "swap_src_dst_mac", scope: !3, file: !3, line: 31, type: !460, scopeLine: 32, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !462)
!460 = !DISubroutineType(types: !461)
!461 = !{null, !188}
!462 = !{!458, !463}
!463 = !DILocalVariable(name: "h_tmp", scope: !459, file: !3, line: 35, type: !157)
!464 = !DILocation(line: 0, scope: !459, inlinedAt: !465)
!465 = distinct !DILocation(line: 144, column: 2, scope: !167)
!466 = !DILocation(line: 35, column: 3, scope: !459, inlinedAt: !465)
!467 = !DILocation(line: 35, column: 8, scope: !459, inlinedAt: !465)
!468 = !DILocation(line: 37, column: 2, scope: !459, inlinedAt: !465)
!469 = !DILocation(line: 38, column: 2, scope: !459, inlinedAt: !465)
!470 = !DILocation(line: 39, column: 2, scope: !459, inlinedAt: !465)
!471 = !DILocation(line: 40, column: 1, scope: !459, inlinedAt: !465)
!472 = !DILocation(line: 148, column: 22, scope: !167)
!473 = !{!421, !325, i64 2}
!474 = !DILocation(line: 149, column: 17, scope: !167)
!475 = !DILocation(line: 150, column: 16, scope: !167)
!476 = !DILocation(line: 151, column: 16, scope: !167)
!477 = !DILocation(line: 154, column: 38, scope: !167)
!478 = !DILocalVariable(name: "seed", arg: 1, scope: !479, file: !3, line: 77, type: !48)
!479 = distinct !DISubprogram(name: "icmp_checksum_diff", scope: !3, file: !3, line: 76, type: !480, scopeLine: 80, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !482)
!480 = !DISubroutineType(types: !481)
!481 = !{!48, !48, !257, !257}
!482 = !{!478, !483, !484, !485, !486}
!483 = !DILocalVariable(name: "icmphdr_new", arg: 2, scope: !479, file: !3, line: 78, type: !257)
!484 = !DILocalVariable(name: "icmphdr_old", arg: 3, scope: !479, file: !3, line: 79, type: !257)
!485 = !DILocalVariable(name: "csum", scope: !479, file: !3, line: 81, type: !73)
!486 = !DILocalVariable(name: "size", scope: !479, file: !3, line: 81, type: !73)
!487 = !DILocation(line: 0, scope: !479, inlinedAt: !488)
!488 = distinct !DILocation(line: 154, column: 19, scope: !167)
!489 = !DILocation(line: 83, column: 81, scope: !479, inlinedAt: !488)
!490 = !DILocation(line: 83, column: 9, scope: !479, inlinedAt: !488)
!491 = !DILocalVariable(name: "csum", arg: 1, scope: !492, file: !3, line: 61, type: !73)
!492 = distinct !DISubprogram(name: "csum_fold_helper", scope: !3, file: !3, line: 61, type: !493, scopeLine: 62, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !495)
!493 = !DISubroutineType(types: !494)
!494 = !{!48, !73}
!495 = !{!491, !496}
!496 = !DILocalVariable(name: "sum", scope: !492, file: !3, line: 63, type: !73)
!497 = !DILocation(line: 0, scope: !492, inlinedAt: !498)
!498 = distinct !DILocation(line: 84, column: 9, scope: !479, inlinedAt: !488)
!499 = !DILocation(line: 64, column: 14, scope: !492, inlinedAt: !498)
!500 = !DILocation(line: 64, column: 29, scope: !492, inlinedAt: !498)
!501 = !DILocation(line: 64, column: 21, scope: !492, inlinedAt: !498)
!502 = !DILocation(line: 65, column: 14, scope: !492, inlinedAt: !498)
!503 = !DILocation(line: 65, column: 6, scope: !492, inlinedAt: !498)
!504 = !DILocation(line: 66, column: 9, scope: !492, inlinedAt: !498)
!505 = !DILocation(line: 154, column: 17, scope: !167)
!506 = !DILocation(line: 157, column: 2, scope: !167)
!507 = !DILocation(line: 159, column: 1, scope: !167)
!508 = !DILocation(line: 0, scope: !509, inlinedAt: !522)
!509 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !161, file: !161, line: 24, type: !510, scopeLine: 25, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !512)
!510 = !DISubroutineType(types: !511)
!511 = !{!73, !170, !73}
!512 = !{!513, !514, !515}
!513 = !DILocalVariable(name: "ctx", arg: 1, scope: !509, file: !161, line: 24, type: !170)
!514 = !DILocalVariable(name: "action", arg: 2, scope: !509, file: !161, line: 24, type: !73)
!515 = !DILocalVariable(name: "rec", scope: !509, file: !161, line: 30, type: !516)
!516 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !517, size: 64)
!517 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !518, line: 10, size: 128, elements: !519)
!518 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/david/Escritorio/TSN/xdp-tutorial/packet03-redirecting", checksumkind: CSK_MD5, checksum: "96c2435685fa7da2d24f219444d8659d")
!519 = !{!520, !521}
!520 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !517, file: !518, line: 11, baseType: !109, size: 64)
!521 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !517, file: !518, line: 12, baseType: !109, size: 64, offset: 64)
!522 = distinct !DILocation(line: 160, column: 9, scope: !167)
!523 = !{!270, !270, i64 0}
!524 = !DILocation(line: 30, column: 24, scope: !509, inlinedAt: !522)
!525 = !DILocation(line: 31, column: 7, scope: !526, inlinedAt: !522)
!526 = distinct !DILexicalBlock(scope: !509, file: !161, line: 31, column: 6)
!527 = !DILocation(line: 31, column: 6, scope: !509, inlinedAt: !522)
!528 = !DILocation(line: 38, column: 7, scope: !509, inlinedAt: !522)
!529 = !DILocation(line: 38, column: 17, scope: !509, inlinedAt: !522)
!530 = !{!531, !532, i64 0}
!531 = !{!"datarec", !532, i64 0, !532, i64 8}
!532 = !{!"long long", !271, i64 0}
!533 = !DILocation(line: 39, column: 25, scope: !509, inlinedAt: !522)
!534 = !DILocation(line: 39, column: 41, scope: !509, inlinedAt: !522)
!535 = !DILocation(line: 39, column: 34, scope: !509, inlinedAt: !522)
!536 = !DILocation(line: 39, column: 19, scope: !509, inlinedAt: !522)
!537 = !DILocation(line: 39, column: 7, scope: !509, inlinedAt: !522)
!538 = !DILocation(line: 39, column: 16, scope: !509, inlinedAt: !522)
!539 = !{!531, !532, i64 8}
!540 = !DILocation(line: 41, column: 9, scope: !509, inlinedAt: !522)
!541 = !DILocation(line: 41, column: 2, scope: !509, inlinedAt: !522)
!542 = !DILocation(line: 42, column: 1, scope: !509, inlinedAt: !522)
!543 = !DILocation(line: 161, column: 1, scope: !167)
!544 = !DILocation(line: 160, column: 2, scope: !167)
!545 = distinct !DISubprogram(name: "xdp_redirect_func", scope: !3, file: !3, line: 165, type: !168, scopeLine: 166, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !546)
!546 = !{!547, !548, !549, !550, !551, !552, !553, !554, !558, !559}
!547 = !DILocalVariable(name: "ctx", arg: 1, scope: !545, file: !3, line: 165, type: !170)
!548 = !DILocalVariable(name: "data_end", scope: !545, file: !3, line: 167, type: !46)
!549 = !DILocalVariable(name: "data", scope: !545, file: !3, line: 168, type: !46)
!550 = !DILocalVariable(name: "nh", scope: !545, file: !3, line: 169, type: !183)
!551 = !DILocalVariable(name: "eth", scope: !545, file: !3, line: 170, type: !188)
!552 = !DILocalVariable(name: "eth_type", scope: !545, file: !3, line: 171, type: !108)
!553 = !DILocalVariable(name: "action", scope: !545, file: !3, line: 172, type: !108)
!554 = !DILocalVariable(name: "dst", scope: !545, file: !3, line: 175, type: !555)
!555 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 56, elements: !556)
!556 = !{!557}
!557 = !DISubrange(count: 7)
!558 = !DILocalVariable(name: "ifindex", scope: !545, file: !3, line: 178, type: !7)
!559 = !DILabel(scope: !545, name: "out", file: !3, line: 196)
!560 = !DILocation(line: 0, scope: !545)
!561 = !DILocation(line: 167, column: 38, scope: !545)
!562 = !DILocation(line: 167, column: 27, scope: !545)
!563 = !DILocation(line: 167, column: 19, scope: !545)
!564 = !DILocation(line: 168, column: 34, scope: !545)
!565 = !DILocation(line: 168, column: 23, scope: !545)
!566 = !DILocation(line: 168, column: 15, scope: !545)
!567 = !DILocation(line: 175, column: 16, scope: !545)
!568 = !DILocation(line: 0, scope: !281, inlinedAt: !569)
!569 = distinct !DILocation(line: 187, column: 13, scope: !545)
!570 = !DILocation(line: 0, scope: !292, inlinedAt: !571)
!571 = distinct !DILocation(line: 129, column: 9, scope: !281, inlinedAt: !569)
!572 = !DILocation(line: 93, column: 14, scope: !319, inlinedAt: !571)
!573 = !DILocation(line: 93, column: 24, scope: !319, inlinedAt: !571)
!574 = !DILocation(line: 93, column: 6, scope: !292, inlinedAt: !571)
!575 = !DILocation(line: 97, column: 10, scope: !292, inlinedAt: !571)
!576 = !DILocation(line: 192, column: 2, scope: !545)
!577 = !DILocation(line: 193, column: 11, scope: !545)
!578 = !DILocation(line: 196, column: 1, scope: !545)
!579 = !DILocation(line: 0, scope: !509, inlinedAt: !580)
!580 = distinct !DILocation(line: 197, column: 9, scope: !545)
!581 = !DILocation(line: 26, column: 13, scope: !582, inlinedAt: !580)
!582 = distinct !DILexicalBlock(scope: !509, file: !161, line: 26, column: 6)
!583 = !DILocation(line: 26, column: 6, scope: !509, inlinedAt: !580)
!584 = !DILocation(line: 30, column: 24, scope: !509, inlinedAt: !580)
!585 = !DILocation(line: 31, column: 7, scope: !526, inlinedAt: !580)
!586 = !DILocation(line: 31, column: 6, scope: !509, inlinedAt: !580)
!587 = !DILocation(line: 38, column: 7, scope: !509, inlinedAt: !580)
!588 = !DILocation(line: 38, column: 17, scope: !509, inlinedAt: !580)
!589 = !DILocation(line: 39, column: 25, scope: !509, inlinedAt: !580)
!590 = !DILocation(line: 39, column: 41, scope: !509, inlinedAt: !580)
!591 = !DILocation(line: 39, column: 34, scope: !509, inlinedAt: !580)
!592 = !DILocation(line: 39, column: 19, scope: !509, inlinedAt: !580)
!593 = !DILocation(line: 39, column: 7, scope: !509, inlinedAt: !580)
!594 = !DILocation(line: 39, column: 16, scope: !509, inlinedAt: !580)
!595 = !DILocation(line: 41, column: 9, scope: !509, inlinedAt: !580)
!596 = !DILocation(line: 41, column: 2, scope: !509, inlinedAt: !580)
!597 = !DILocation(line: 42, column: 1, scope: !509, inlinedAt: !580)
!598 = !DILocation(line: 197, column: 2, scope: !545)
!599 = distinct !DISubprogram(name: "xdp_redirect_map_func", scope: !3, file: !3, line: 202, type: !168, scopeLine: 203, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !600)
!600 = !{!601, !602, !603, !604, !605, !606, !607, !608, !610}
!601 = !DILocalVariable(name: "ctx", arg: 1, scope: !599, file: !3, line: 202, type: !170)
!602 = !DILocalVariable(name: "data_end", scope: !599, file: !3, line: 204, type: !46)
!603 = !DILocalVariable(name: "data", scope: !599, file: !3, line: 205, type: !46)
!604 = !DILocalVariable(name: "nh", scope: !599, file: !3, line: 206, type: !183)
!605 = !DILocalVariable(name: "eth", scope: !599, file: !3, line: 207, type: !188)
!606 = !DILocalVariable(name: "eth_type", scope: !599, file: !3, line: 208, type: !108)
!607 = !DILocalVariable(name: "action", scope: !599, file: !3, line: 209, type: !108)
!608 = !DILocalVariable(name: "dst", scope: !599, file: !3, line: 210, type: !609)
!609 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!610 = !DILabel(scope: !599, name: "out", file: !3, line: 229)
!611 = !DILocation(line: 0, scope: !599)
!612 = !DILocation(line: 204, column: 38, scope: !599)
!613 = !DILocation(line: 204, column: 27, scope: !599)
!614 = !DILocation(line: 204, column: 19, scope: !599)
!615 = !DILocation(line: 205, column: 34, scope: !599)
!616 = !DILocation(line: 205, column: 23, scope: !599)
!617 = !DILocation(line: 205, column: 15, scope: !599)
!618 = !DILocation(line: 0, scope: !281, inlinedAt: !619)
!619 = distinct !DILocation(line: 216, column: 13, scope: !599)
!620 = !DILocation(line: 0, scope: !292, inlinedAt: !621)
!621 = distinct !DILocation(line: 129, column: 9, scope: !281, inlinedAt: !619)
!622 = !DILocation(line: 93, column: 14, scope: !319, inlinedAt: !621)
!623 = !DILocation(line: 93, column: 24, scope: !319, inlinedAt: !621)
!624 = !DILocation(line: 93, column: 6, scope: !292, inlinedAt: !621)
!625 = !DILocation(line: 97, column: 10, scope: !292, inlinedAt: !621)
!626 = !DILocation(line: 221, column: 46, scope: !599)
!627 = !DILocation(line: 221, column: 8, scope: !599)
!628 = !DILocation(line: 222, column: 7, scope: !629)
!629 = distinct !DILexicalBlock(scope: !599, file: !3, line: 222, column: 6)
!630 = !DILocation(line: 222, column: 6, scope: !599)
!631 = !DILocation(line: 229, column: 1, scope: !599)
!632 = !DILocation(line: 0, scope: !509, inlinedAt: !633)
!633 = distinct !DILocation(line: 230, column: 9, scope: !599)
!634 = !DILocation(line: 26, column: 6, scope: !509, inlinedAt: !633)
!635 = !DILocation(line: 226, column: 2, scope: !599)
!636 = !DILocation(line: 227, column: 11, scope: !599)
!637 = !DILocation(line: 26, column: 13, scope: !582, inlinedAt: !633)
!638 = !DILocation(line: 30, column: 24, scope: !509, inlinedAt: !633)
!639 = !DILocation(line: 31, column: 7, scope: !526, inlinedAt: !633)
!640 = !DILocation(line: 31, column: 6, scope: !509, inlinedAt: !633)
!641 = !DILocation(line: 38, column: 7, scope: !509, inlinedAt: !633)
!642 = !DILocation(line: 38, column: 17, scope: !509, inlinedAt: !633)
!643 = !DILocation(line: 39, column: 25, scope: !509, inlinedAt: !633)
!644 = !DILocation(line: 39, column: 41, scope: !509, inlinedAt: !633)
!645 = !DILocation(line: 39, column: 34, scope: !509, inlinedAt: !633)
!646 = !DILocation(line: 39, column: 19, scope: !509, inlinedAt: !633)
!647 = !DILocation(line: 39, column: 7, scope: !509, inlinedAt: !633)
!648 = !DILocation(line: 39, column: 16, scope: !509, inlinedAt: !633)
!649 = !DILocation(line: 41, column: 9, scope: !509, inlinedAt: !633)
!650 = !DILocation(line: 41, column: 2, scope: !509, inlinedAt: !633)
!651 = !DILocation(line: 42, column: 1, scope: !509, inlinedAt: !633)
!652 = !DILocation(line: 230, column: 2, scope: !599)
!653 = distinct !DISubprogram(name: "xdp_router_func", scope: !3, file: !3, line: 252, type: !168, scopeLine: 253, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !654)
!654 = !{!655, !656, !657, !658, !659, !660, !661, !662, !663, !664, !665, !666, !670, !671}
!655 = !DILocalVariable(name: "ctx", arg: 1, scope: !653, file: !3, line: 252, type: !170)
!656 = !DILocalVariable(name: "data_end", scope: !653, file: !3, line: 254, type: !46)
!657 = !DILocalVariable(name: "data", scope: !653, file: !3, line: 255, type: !46)
!658 = !DILocalVariable(name: "fib_params", scope: !653, file: !3, line: 256, type: !129)
!659 = !DILocalVariable(name: "eth", scope: !653, file: !3, line: 257, type: !188)
!660 = !DILocalVariable(name: "ip6h", scope: !653, file: !3, line: 258, type: !228)
!661 = !DILocalVariable(name: "iph", scope: !653, file: !3, line: 259, type: !200)
!662 = !DILocalVariable(name: "h_proto", scope: !653, file: !3, line: 260, type: !48)
!663 = !DILocalVariable(name: "nh_off", scope: !653, file: !3, line: 261, type: !109)
!664 = !DILocalVariable(name: "rc", scope: !653, file: !3, line: 262, type: !108)
!665 = !DILocalVariable(name: "action", scope: !653, file: !3, line: 263, type: !108)
!666 = !DILocalVariable(name: "src", scope: !667, file: !3, line: 297, type: !51)
!667 = distinct !DILexicalBlock(scope: !668, file: !3, line: 295, column: 47)
!668 = distinct !DILexicalBlock(scope: !669, file: !3, line: 295, column: 13)
!669 = distinct !DILexicalBlock(scope: !653, file: !3, line: 272, column: 6)
!670 = !DILocalVariable(name: "dst", scope: !667, file: !3, line: 298, type: !51)
!671 = !DILabel(scope: !653, name: "out", file: !3, line: 356)
!672 = !DILocation(line: 0, scope: !653)
!673 = !DILocation(line: 254, column: 38, scope: !653)
!674 = !DILocation(line: 254, column: 27, scope: !653)
!675 = !DILocation(line: 254, column: 19, scope: !653)
!676 = !DILocation(line: 255, column: 34, scope: !653)
!677 = !DILocation(line: 255, column: 23, scope: !653)
!678 = !DILocation(line: 255, column: 15, scope: !653)
!679 = !DILocation(line: 256, column: 2, scope: !653)
!680 = !DILocation(line: 256, column: 24, scope: !653)
!681 = !DILocation(line: 257, column: 23, scope: !653)
!682 = !DILocation(line: 266, column: 11, scope: !683)
!683 = distinct !DILexicalBlock(scope: !653, file: !3, line: 266, column: 6)
!684 = !DILocation(line: 266, column: 20, scope: !683)
!685 = !DILocation(line: 266, column: 6, scope: !653)
!686 = !DILocation(line: 271, column: 17, scope: !653)
!687 = !{!688, !325, i64 12}
!688 = !{!"ethhdr", !271, i64 0, !271, i64 6, !325, i64 12}
!689 = !DILocation(line: 272, column: 14, scope: !669)
!690 = !DILocation(line: 272, column: 6, scope: !653)
!691 = !DILocation(line: 273, column: 9, scope: !692)
!692 = distinct !DILexicalBlock(scope: !669, file: !3, line: 272, column: 38)
!693 = !DILocation(line: 275, column: 11, scope: !694)
!694 = distinct !DILexicalBlock(scope: !692, file: !3, line: 275, column: 7)
!695 = !DILocation(line: 275, column: 17, scope: !694)
!696 = !DILocation(line: 275, column: 15, scope: !694)
!697 = !DILocation(line: 275, column: 7, scope: !692)
!698 = !DILocation(line: 280, column: 12, scope: !699)
!699 = distinct !DILexicalBlock(scope: !692, file: !3, line: 280, column: 7)
!700 = !{!373, !271, i64 8}
!701 = !DILocation(line: 280, column: 16, scope: !699)
!702 = !DILocation(line: 280, column: 7, scope: !692)
!703 = !DILocation(line: 285, column: 21, scope: !692)
!704 = !{!705, !271, i64 0}
!705 = !{!"bpf_fib_lookup", !271, i64 0, !271, i64 1, !325, i64 2, !325, i64 4, !325, i64 6, !270, i64 8, !271, i64 12, !271, i64 16, !271, i64 32, !325, i64 48, !325, i64 50, !271, i64 52, !271, i64 58}
!706 = !DILocation(line: 286, column: 26, scope: !692)
!707 = !{!373, !271, i64 1}
!708 = !DILocation(line: 286, column: 14, scope: !692)
!709 = !DILocation(line: 286, column: 19, scope: !692)
!710 = !DILocation(line: 287, column: 33, scope: !692)
!711 = !DILocation(line: 287, column: 14, scope: !692)
!712 = !DILocation(line: 287, column: 26, scope: !692)
!713 = !{!705, !271, i64 1}
!714 = !DILocation(line: 289, column: 14, scope: !692)
!715 = !DILocation(line: 289, column: 20, scope: !692)
!716 = !{!705, !325, i64 4}
!717 = !DILocation(line: 290, column: 24, scope: !692)
!718 = !{!373, !325, i64 2}
!719 = !DILocation(line: 290, column: 14, scope: !692)
!720 = !DILocation(line: 290, column: 22, scope: !692)
!721 = !{!705, !325, i64 6}
!722 = !DILocation(line: 291, column: 30, scope: !692)
!723 = !DILocation(line: 291, column: 14, scope: !692)
!724 = !DILocation(line: 291, column: 23, scope: !692)
!725 = !DILocation(line: 292, column: 30, scope: !692)
!726 = !DILocation(line: 292, column: 14, scope: !692)
!727 = !DILocation(line: 292, column: 23, scope: !692)
!728 = !DILocation(line: 295, column: 2, scope: !692)
!729 = !DILocation(line: 295, column: 21, scope: !668)
!730 = !DILocation(line: 295, column: 13, scope: !669)
!731 = !DILocation(line: 297, column: 46, scope: !667)
!732 = !DILocation(line: 0, scope: !667)
!733 = !DILocation(line: 298, column: 46, scope: !667)
!734 = !DILocation(line: 300, column: 10, scope: !667)
!735 = !DILocation(line: 301, column: 12, scope: !736)
!736 = distinct !DILexicalBlock(scope: !667, file: !3, line: 301, column: 7)
!737 = !DILocation(line: 301, column: 18, scope: !736)
!738 = !DILocation(line: 301, column: 16, scope: !736)
!739 = !DILocation(line: 301, column: 7, scope: !667)
!740 = !DILocation(line: 306, column: 13, scope: !741)
!741 = distinct !DILexicalBlock(scope: !667, file: !3, line: 306, column: 7)
!742 = !{!398, !271, i64 7}
!743 = !DILocation(line: 306, column: 23, scope: !741)
!744 = !DILocation(line: 306, column: 7, scope: !667)
!745 = !DILocation(line: 311, column: 21, scope: !667)
!746 = !DILocation(line: 312, column: 25, scope: !667)
!747 = !DILocation(line: 312, column: 42, scope: !667)
!748 = !DILocation(line: 312, column: 14, scope: !667)
!749 = !DILocation(line: 312, column: 23, scope: !667)
!750 = !DILocation(line: 313, column: 34, scope: !667)
!751 = !DILocation(line: 313, column: 14, scope: !667)
!752 = !DILocation(line: 313, column: 26, scope: !667)
!753 = !DILocation(line: 315, column: 14, scope: !667)
!754 = !DILocation(line: 315, column: 20, scope: !667)
!755 = !DILocation(line: 316, column: 24, scope: !667)
!756 = !{!398, !325, i64 4}
!757 = !DILocation(line: 316, column: 14, scope: !667)
!758 = !DILocation(line: 316, column: 22, scope: !667)
!759 = !DILocation(line: 317, column: 18, scope: !667)
!760 = !DILocation(line: 318, column: 18, scope: !667)
!761 = !DILocation(line: 324, column: 28, scope: !653)
!762 = !{!269, !270, i64 12}
!763 = !DILocation(line: 324, column: 13, scope: !653)
!764 = !DILocation(line: 324, column: 21, scope: !653)
!765 = !{!705, !270, i64 8}
!766 = !DILocation(line: 326, column: 22, scope: !653)
!767 = !DILocation(line: 326, column: 7, scope: !653)
!768 = !DILocation(line: 327, column: 2, scope: !653)
!769 = !DILocation(line: 329, column: 7, scope: !770)
!770 = distinct !DILexicalBlock(scope: !653, file: !3, line: 327, column: 14)
!771 = !DILocalVariable(name: "iph", arg: 1, scope: !772, file: !3, line: 240, type: !200)
!772 = distinct !DISubprogram(name: "ip_decrease_ttl", scope: !3, file: !3, line: 240, type: !773, scopeLine: 241, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !775)
!773 = !DISubroutineType(types: !774)
!774 = !{!108, !200}
!775 = !{!771, !776}
!776 = !DILocalVariable(name: "check", scope: !772, file: !3, line: 244, type: !73)
!777 = !DILocation(line: 0, scope: !772, inlinedAt: !778)
!778 = distinct !DILocation(line: 330, column: 4, scope: !779)
!779 = distinct !DILexicalBlock(scope: !770, file: !3, line: 329, column: 7)
!780 = !DILocation(line: 244, column: 21, scope: !772, inlinedAt: !778)
!781 = !{!373, !325, i64 10}
!782 = !DILocation(line: 245, column: 8, scope: !772, inlinedAt: !778)
!783 = !DILocation(line: 246, column: 38, scope: !772, inlinedAt: !778)
!784 = !DILocation(line: 246, column: 29, scope: !772, inlinedAt: !778)
!785 = !DILocation(line: 246, column: 13, scope: !772, inlinedAt: !778)
!786 = !DILocation(line: 247, column: 16, scope: !772, inlinedAt: !778)
!787 = !DILocation(line: 247, column: 9, scope: !772, inlinedAt: !778)
!788 = !DILocation(line: 330, column: 4, scope: !779)
!789 = !DILocation(line: 331, column: 20, scope: !790)
!790 = distinct !DILexicalBlock(scope: !779, file: !3, line: 331, column: 12)
!791 = !DILocation(line: 331, column: 12, scope: !779)
!792 = !DILocation(line: 332, column: 10, scope: !790)
!793 = !DILocation(line: 332, column: 19, scope: !790)
!794 = !DILocation(line: 332, column: 4, scope: !790)
!795 = !DILocation(line: 346, column: 3, scope: !770)
!796 = !DILocation(line: 356, column: 1, scope: !653)
!797 = !DILocation(line: 0, scope: !509, inlinedAt: !798)
!798 = distinct !DILocation(line: 357, column: 9, scope: !653)
!799 = !DILocation(line: 26, column: 6, scope: !509, inlinedAt: !798)
!800 = !DILocation(line: 337, column: 3, scope: !770)
!801 = !DILocation(line: 338, column: 3, scope: !770)
!802 = !DILocation(line: 339, column: 36, scope: !770)
!803 = !DILocation(line: 339, column: 12, scope: !770)
!804 = !DILocation(line: 26, column: 13, scope: !582, inlinedAt: !798)
!805 = !DILocation(line: 30, column: 24, scope: !509, inlinedAt: !798)
!806 = !DILocation(line: 31, column: 7, scope: !526, inlinedAt: !798)
!807 = !DILocation(line: 31, column: 6, scope: !509, inlinedAt: !798)
!808 = !DILocation(line: 38, column: 7, scope: !509, inlinedAt: !798)
!809 = !DILocation(line: 38, column: 17, scope: !509, inlinedAt: !798)
!810 = !DILocation(line: 39, column: 25, scope: !509, inlinedAt: !798)
!811 = !DILocation(line: 39, column: 41, scope: !509, inlinedAt: !798)
!812 = !DILocation(line: 39, column: 34, scope: !509, inlinedAt: !798)
!813 = !DILocation(line: 39, column: 19, scope: !509, inlinedAt: !798)
!814 = !DILocation(line: 39, column: 7, scope: !509, inlinedAt: !798)
!815 = !DILocation(line: 39, column: 16, scope: !509, inlinedAt: !798)
!816 = !DILocation(line: 41, column: 9, scope: !509, inlinedAt: !798)
!817 = !DILocation(line: 41, column: 2, scope: !509, inlinedAt: !798)
!818 = !DILocation(line: 42, column: 1, scope: !509, inlinedAt: !798)
!819 = !DILocation(line: 358, column: 1, scope: !653)
!820 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 361, type: !168, scopeLine: 362, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !821)
!821 = !{!822}
!822 = !DILocalVariable(name: "ctx", arg: 1, scope: !820, file: !3, line: 361, type: !170)
!823 = !DILocation(line: 0, scope: !820)
!824 = !DILocation(line: 363, column: 2, scope: !820)

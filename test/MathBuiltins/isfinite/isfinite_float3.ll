; RUN: clspv-opt --passes=replace-opencl-builtin %s -o %t
; RUN: FileCheck %s < %t

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir64-unknown-unknown"

define spir_kernel void @test(<3 x float> %val, <3 x i32> addrspace(1)* nocapture %out) {
entry:
  %call = tail call spir_func <3 x i32> @_Z8isfiniteDv3_f(<3 x float> %val)
  ;CHECK: %0 = bitcast <3 x float> %val to <3 x i32>
  ;CHECK: %1 = and <3 x i32> splat (i32 2139095040), %0
  ;CHECK: %2 = icmp eq <3 x i32> %1, splat (i32 2139095040)
  ;CHECK: %3 = select <3 x i1> %2, <3 x i32> zeroinitializer, <3 x i32> splat (i32 -1)
  store <3 x i32> %call, <3 x i32> addrspace(1)* %out, align 8
  ret void
}

declare spir_func <3 x i32> @_Z8isfiniteDv3_f(<3 x float>)


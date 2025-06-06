// RUN: clspv %target %s -o %t.spv -arch=spir
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm --check-prefixes=CHECK,CHECK-32
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// RUN: clspv %target %s -o %t.spv -arch=spir64
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm --check-prefixes=CHECK,CHECK-64
// RUN: spirv-val --target-env vulkan1.0 %t.spv

kernel void foo(global float2* A, local uint* B, uint n) {
  A[0] = __clspv_vloada_half2(n, B);
  A[1] = __clspv_vloada_half2(0, B);
}

// CHECK-DAG: [[_float:%[0-9a-zA-Z_]+]] = OpTypeFloat 32
// CHECK-DAG: [[_v2float:%[0-9a-zA-Z_]+]] = OpTypeVector [[_float]] 2
// CHECK-DAG: [[_uint:%[0-9a-zA-Z_]+]] = OpTypeInt 32 0
// CHECK-64-DAG: [[_ulong:%[0-9a-zA-Z_]+]] = OpTypeInt 64 0
// CHECK-DAG: [[_uint_0:%[0-9a-zA-Z_]+]] = OpConstant [[_uint]] 0
// CHECK-DAG: [[_uint_1:%[0-9a-zA-Z_]+]] = OpConstant [[_uint]] 1
// CHECK: [[_5:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[B:%[0-9a-zA-Z_]+]] [[_uint_0]]
// CHECK-64: [[_offset_long:%[0-9a-zA-Z_]+]] = OpUConvert [[_ulong]]
// CHECK-64: [[_36:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[B]] [[_offset_long]]
// CHECK-32: [[_36:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[B]]
// CHECK: [[_37:%[0-9a-zA-Z_]+]] = OpLoad [[_uint]] [[_36]]
// CHECK: [[_38:%[0-9a-zA-Z_]+]] = OpExtInst [[_v2float]] {{.*}} UnpackHalf2x16 [[_37]]
// CHECK: [[_33:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[A:%[0-9a-zA-Z_]+]] [[_uint_0]] [[_uint_0]]
// CHECK: OpStore [[_33]] [[_38]]
// CHECK: [[_39:%[0-9a-zA-Z_]+]] = OpLoad [[_uint]] [[_5]]
// CHECK: [[_40:%[0-9a-zA-Z_]+]] = OpExtInst [[_v2float]] {{.*}} UnpackHalf2x16 [[_39]]
// CHECK: [[_41:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[A]] [[_uint_0]] [[_uint_1]]
// CHECK: OpStore [[_41]] [[_40]]

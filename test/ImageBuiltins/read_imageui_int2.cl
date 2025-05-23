// RUN: clspv %target %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(read_only image2d_t i, int2 c, global uint4* a)
{
  *a = read_imageui(i, c);
}

// CHECK-DAG:  [[_uint:%[0-9a-zA-Z_]+]] = OpTypeInt 32 0
// CHECK-DAG:  [[_v4uint:%[0-9a-zA-Z_]+]] = OpTypeVector [[_uint]] 4
// CHECK-DAG:  [[_4:%[0-9a-zA-Z_]+]] = OpTypeImage [[_uint]] 2D 0 0 0 1 Unknown
// CHECK-DAG:  [[_v2uint:%[0-9a-zA-Z_]+]] = OpTypeVector [[_uint]] 2
// CHECK-DAG:  [[_int0:%[0-9a-zA-Z_]+]] = OpConstant [[_uint]] 0
// CHECK:  [[_28:%[0-9a-zA-Z_]+]] = OpLoad [[_4]]
// CHECK:  [[_33:%[0-9a-zA-Z_]+]] = OpImageFetch [[_v4uint]] [[_28]] {{.*}} Lod [[_int0]]
// CHECK:  OpStore {{.*}} [[_33]]


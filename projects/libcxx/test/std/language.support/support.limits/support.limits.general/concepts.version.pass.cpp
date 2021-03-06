//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// WARNING: This test was generated by generate_feature_test_macro_components.py
// and should not be edited manually.

// <concepts>

// Test the feature test macros defined by <concepts>

/*  Constant              Value
    __cpp_lib_concepts    201806L [C++20]
*/

#include <concepts>
#include "test_macros.h"

#if TEST_STD_VER < 14

# ifdef __cpp_lib_concepts
#   error "__cpp_lib_concepts should not be defined before c++20"
# endif

#elif TEST_STD_VER == 14

# ifdef __cpp_lib_concepts
#   error "__cpp_lib_concepts should not be defined before c++20"
# endif

#elif TEST_STD_VER == 17

# ifdef __cpp_lib_concepts
#   error "__cpp_lib_concepts should not be defined before c++20"
# endif

#elif TEST_STD_VER == 20

# if !defined(_LIBCPP_VERSION)
#   ifndef __cpp_lib_concepts
#     error "__cpp_lib_concepts should be defined in c++20"
#   endif
#   if __cpp_lib_concepts != 201806L
#     error "__cpp_lib_concepts should have the value 201806L in c++20"
#   endif
# else // _LIBCPP_VERSION
#   ifdef __cpp_lib_concepts
#     error "__cpp_lib_concepts should not be defined because it is unimplemented in libc++!"
#   endif
# endif

#endif // TEST_STD_VER == 20

int main(int, char**) { return 0; }

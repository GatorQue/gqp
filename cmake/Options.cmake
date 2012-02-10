# Filename: Options.cmake
# Description: Define various CMake build options for all projects
# Modification Log:
# 2012-01-02 Initial version
#

# Detect the host architecture
include(CheckTypeSize)
check_type_size(void* SIZEOF_VOID_PTR)
if(${SIZEOF_VOID_PTR} MATCHES "^4$")
  set(HOST_ARCH_32BITS 1)
  set(HOST_ARCH_TYPE "x86")
else()
  set(HOST_ARCH_64BITS 1)
  set(HOST_ARCH_TYPE "x64")
endif()

# Option: TARGET_ARCH_TYPE
# Description: Target architecture type.
# Values:
#   x86 - 32 bit x86 architecture
#   x64 - 64 bit x86 architecture
set_option(TARGET_ARCH_TYPE "x86" STRING "Target architecture type (x86 or x64)")
if(TARGET_ARCH_TYPE STREQUAL "x86")
  set(TARGET_ARCH_32BITS 1)
elseif(TARGET_ARCH_TYPE STREQUAL "x64")
  set(TARGET_ARCH_64BITS 1)
else()
  message(FATAL_ERROR "error: Unsupported/Unknwon TARGET_ARCH_TYPE '${TARGET_ARCH_TYPE}'")
endif()

